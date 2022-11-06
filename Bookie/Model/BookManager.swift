//
//  BookManager.swift
//  Bookie
//
//  Created by Burhan Kaynak on 04/09/2021.
//

import Foundation
import Firebase
import CoreData

protocol BookManagerDelegate {
    func didFetchBooks(manager: BookManager, books: [Book])
    func didFailWithError(error: Error)
    func didAddToList()
}

class BookManager {
    var delegate: BookManagerDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let session = Session()
    var books_CoreData = [Books]()
    
    // MARK: - Core Data
    private func loadBooks(with request: NSFetchRequest<Books> = Books.fetchRequest()) {
        do {
            books_CoreData = try context.fetch(request)
        } catch {
            print("Error loading the books \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving to core data \(error)")
        }
    }
    
    private func saveBook(_ book: Book) {
        let newBook = Books(context: self.context)
        newBook.id = book.id
        newBook.status = book.status
        self.books_CoreData.append(newBook)
        saveContext()
    }
    
    private func updateBook(_ book: Book) {
        let updatedBook = Books(context: self.context)
        updatedBook.id = book.id
        updatedBook.status = book.status
        saveContext()
    }
    
    private func removeBook(_ book: Book) {
        loadBooks()
        for book in books_CoreData {
            if book.id == book.id {
                context.delete(book)
                saveContext()
            }
        }
    }
    
    func checkBook(with id: String) -> Bool {
        var isOnTheList = false
        loadBooks()
        for book in books_CoreData {
            if book.id == id {
                isOnTheList = true
            } else {
                isOnTheList = false
            }
        }
        return isOnTheList
    }
    
    // MARK: - Firebase
    func addToList(book: Book, to list: String) {
        guard let currentUser = session.user?.uid else { return }
        
        let newBook = [
            B.Fire.addedBy : currentUser,
            B.Fire.status : list,
            B.Fire.id : book.id,
            B.Fire.title : book.title,
            B.Fire.authors : book.authors,
            B.Fire.date : book.date,
            B.Fire.desc : book.desc,
            B.Fire.categories : book.categories,
            B.Fire.pageCount : book.pageCount,
            B.Fire.rating : book.rating,
            B.Fire.link : book.link,
            B.Fire.image : book.image,
            B.Fire.smallImage : book.smallImage,
        ] as [String : Any]
        
        saveBook(book)
        session.db.collection(B.Fire.collection).document(book.id).setData(newBook) { err in
            if let err = err {
                self.delegate?.didFailWithError(error: err)
            } else {
                self.delegate?.didAddToList()
            }
        }
    }
    
    func removeFromList(_ book: Book) {
        session.db.collection(B.Fire.collection).document(book.id).delete() { err in
            if let err = err {
                print("Error removing the book from the list \(err)")
            } else {
                self.removeBook(book)
                print("Book removed from the list")
            }
        }
    }
    
    func updateTheList(book: Book, list: String) {
        session.db.collection(B.Fire.collection).document(book.id)
            .updateData([B.Fire.status : list]) { err in
                if let err = err {
                    self.delegate?.didFailWithError(error: err)
                } else {
                    self.updateBook(book)
                    self.delegate?.didAddToList()
                }
            }
    }
    
    func fetchBooks(with query: String) {
        let mainUrl = "https://www.googleapis.com/books/v1/volumes?q="
        let temp = query.replacingOccurrences(of: " ", with: "%20")
        
        if let url = URL(string: "\(mainUrl)\(temp)&key=\(apiKey)") {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { data, response, err in
                if let error = err {
                    self.delegate?.didFailWithError(error: error)
                    print(error)
                } else {
                    if let safeData = data {
                        if let decodedBooks = self.parseData(safeData) {
                            self.delegate?.didFetchBooks(manager: self, books: decodedBooks)
                        }
                    }
                }
            }.resume()
        } else {
            print("Unable to produce a URL")
        }
    }
    
    func parseData(_ data: Data) -> [Book]? {
        let decoder = JSONDecoder()
        var books = [Book]()
        
        do {
            let decodedData = try decoder.decode(BooksData.self, from: data)
            for i in 0...decodedData.items.count - 1 {
                let id = decodedData.items[i].id
                let title = decodedData.items[i].volumeInfo.title ?? ""
                let authors = decodedData.items[i].volumeInfo.authors ?? [""]
                let date = decodedData.items[i].volumeInfo.publishedDate ?? "n/a"
                let desc = decodedData.items[i].volumeInfo.description ?? " "
                let categories = decodedData.items[i].volumeInfo.categories ?? [""]
                let pageCount = decodedData.items[i].volumeInfo.pageCount ?? 0
                let rating = decodedData.items[i].volumeInfo.averageRating ?? 0.0
                let link = decodedData.items[i].volumeInfo.previewLink ?? ""
                let image = decodedData.items[i].volumeInfo.imageLinks?.thumbnail ?? ""
                let smallImage = decodedData.items[i].volumeInfo.imageLinks?.smallThumbnail ?? ""
                
                let book = Book(id: id, title: title, authors: authors, date: date,
                                desc: desc, categories: categories, pageCount: pageCount,
                                rating: rating, link: link, image: image, smallImage: smallImage)
                books.append(book)
            }
            return books
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func starRatings(rating: Double, _ oneStar: UIImageView, _ twoStar: UIImageView, _ threeStar: UIImageView, _ fourStar: UIImageView, _ fiveStar: UIImageView) {
        let emptyStar = B.General.emptyStar
        let fullStar = B.General.fullStar
        let halfStar = B.General.halfStar
        
        if rating == 1 {
            oneStar.image = fullStar
            twoStar.image = emptyStar
            threeStar.image = emptyStar
            fourStar.image = emptyStar
            fiveStar.image = emptyStar
        } else if rating == 1.5 {
            oneStar.image = fullStar
            twoStar.image = halfStar
            threeStar.image = emptyStar
            fourStar.image = emptyStar
            fiveStar.image = emptyStar
        } else if rating == 2 {
            oneStar.image = fullStar
            twoStar.image = fullStar
            threeStar.image = emptyStar
            fourStar.image = emptyStar
            fiveStar.image = emptyStar
        } else if rating == 2.5 {
            oneStar.image = fullStar
            twoStar.image = fullStar
            threeStar.image = halfStar
            fourStar.image = emptyStar
            fiveStar.image = emptyStar
        } else if rating == 3 {
            oneStar.image = fullStar
            twoStar.image = fullStar
            threeStar.image = fullStar
            fourStar.image = emptyStar
            fiveStar.image = emptyStar
        } else if rating == 3.5 {
            oneStar.image = fullStar
            twoStar.image = fullStar
            threeStar.image = fullStar
            fourStar.image = halfStar
            fiveStar.image = emptyStar
        } else if rating == 4 {
            oneStar.image = fullStar
            twoStar.image = fullStar
            threeStar.image = fullStar
            fourStar.image = fullStar
            fiveStar.image = emptyStar
        } else if rating == 4.5 {
            oneStar.image = fullStar
            twoStar.image = fullStar
            threeStar.image = fullStar
            fourStar.image = fullStar
            fiveStar.image = halfStar
        } else if rating == 5 {
            oneStar.image = fullStar
            twoStar.image = fullStar
            threeStar.image = fullStar
            fourStar.image = fullStar
            fiveStar.image = fullStar
        } else {
            oneStar.image = emptyStar
            twoStar.image = emptyStar
            threeStar.image = emptyStar
            fourStar.image = emptyStar
            fiveStar.image = emptyStar
        }
    }
}
