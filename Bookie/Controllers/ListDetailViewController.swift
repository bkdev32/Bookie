//
//  ListDetailViewController.swift
//  Bookie
//
//  Created by Burhan Kaynak on 09/09/2021.
//

import UIKit
import Firebase

class ListDetailViewController: UITableViewController {
    let session = Session()
    var bookManager = BookManager()
    var books = [Book]()
    var list = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: B.General.bookCell, bundle: nil), forCellReuseIdentifier: B.General.bookCell)
        loadList(list)
    }

    func loadList(_ list: String) {
        session.db.collection(list).getDocuments { query, err in
            if let error = err {
                print(error)
            } else {
                if query?.isEmpty != true && query != nil {
                    for book in query!.documents {
                        if let id = book.get(B.Fire.id) as? String,
                           let addedBy = book.get(B.Fire.addedBy) as? String,
                           let title = book.get(B.Fire.title) as? String,
                           let authors = book.get(B.Fire.authors) as? [String],
                           let date = book.get(B.Fire.date) as? String,
                           let desc = book.get(B.Fire.desc) as? String,
                           let categories = book.get(B.Fire.categories) as? [String],
                           let pageCount = book.get(B.Fire.pageCount) as? Int,
                           let rating = book.get(B.Fire.rating) as? Double,
                           let link = book.get(B.Fire.link) as? String,
                           let image = book.get(B.Fire.image) as? String,
                           let smallImage = book.get(B.Fire.smallImage) as? String
                        {
                            let newBook = Book(addedBy: addedBy, id: id, title: title, authors: authors, date: date, desc: desc, categories: categories, pageCount: pageCount, rating: rating, link: link, image: image, smallImage: smallImage)
                            if self.session.user?.uid == addedBy {
                                self.books.append(newBook)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ListDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: B.Segue.toBookDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BookDetailViewController
        if let index = tableView.indexPathForSelectedRow {
            let book = Book(id: books[index.row].id, title: books[index.row].title, authors: books[index.row].authors, date: books[index.row].date, desc: books[index.row].desc, categories: books[index.row].categories, pageCount: books[index.row].pageCount, rating: books[index.row].rating, link: books[index.row].link, image: books[index.row].image, smallImage: books[index.row].smallImage)
            destination.book = book
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: B.General.bookCell, for: indexPath) as! BookCell
        cell.titleLabel?.text = book.title
        cell.authorLabel?.text = "by \(book.authors.joined(separator: ", "))"
        cell.bookImage?.sd_setImage(with: URL(string: book.image))
        
        bookManager.starRatings(rating: book.rating, cell.oneStar, cell.twoStar, cell.threeStar, cell.fourStar, cell.fiveStar)
        
        return cell
    }
}
