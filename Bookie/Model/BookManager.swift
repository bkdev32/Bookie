//
//  BookManager.swift
//  Bookie
//
//  Created by Burhan Kaynak on 04/09/2021.
//

import Foundation
import Firebase

protocol BookManagerDelegate {
    func didFetchBooks(manager: BookManager, books: [Book])
    func didFailWithError(error: Error)
    func didAddToList()
}

struct BookManager {
    var delegate: BookManagerDelegate?
    let session = Session()
    
    func addToList(book: Book, to list: String) {
        guard let currentUser = session.user?.uid else { return }
        
        let newBook = [
            B.Fire.addedBy : currentUser,
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
        
        session.db.collection(list).addDocument(data: newBook) { err in
            if let error = err {
                delegate?.didFailWithError(error: error)
            } else {
                delegate?.didAddToList()
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
                    delegate?.didFailWithError(error: error)
                    print(error)
                } else {
                    if let safeData = data {
                        if let decodedBooks = parseData(safeData) {
                            delegate?.didFetchBooks(manager: self, books: decodedBooks)
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
