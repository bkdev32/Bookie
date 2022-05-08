//
//  BookDetailViewController.swift
//  Bookie
//
//  Created by Burhan Kaynak on 08/09/2021.
//

import UIKit
import SDWebImage

class BookDetailViewController: UITableViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    @IBOutlet weak var oneStar: UIImageView!
    @IBOutlet weak var twoStar: UIImageView!
    @IBOutlet weak var threeStar: UIImageView!
    @IBOutlet weak var fourStar: UIImageView!
    @IBOutlet weak var fiveStar: UIImageView!
    
    var bookManager = BookManager()
    var book = Book()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookManager.delegate = self
        bookImageView.sd_setImage(with: URL(string: book.image))
        titleLabel.text = book.title
        authorLabel.text = "by \(book.authors.joined(separator: ", "))"
        descTextView.text = book.desc
        bookManager.starRatings(rating: book.rating, oneStar, twoStar, threeStar, fourStar, fiveStar)
    }
    
    @IBAction func addToListButton(_ sender: UIButton) {
        let ac = UIAlertController(title: "Add to a list", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: B.Fire.wantToRead, style: .default) { action in
            self.bookManager.addToList(book: self.book, to: B.Fire.wantToRead)
        })
        ac.addAction(UIAlertAction(title: B.Fire.currentlyReading, style: .default) { action in
            self.bookManager.addToList(book: self.book, to: B.Fire.currentlyReading)
        })
        ac.addAction(UIAlertAction(title: B.Fire.read, style: .default) { action in
            self.bookManager.addToList(book: self.book, to: B.Fire.read)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { // image
            return 315.0
        } else if indexPath.row == 1 { // title
            return 50.0
        } else if indexPath.row == 3 || indexPath.row == 4 { // rating & button
            return 44
        } else if indexPath.row == 5 { // textView
            return 272.0
        } else { // author
            return 20.0
        }
    }
}

extension BookDetailViewController: BookManagerDelegate {
    func didFetchBooks(manager: BookManager, books: [Book]) { }
    
    func didFailWithError(error: Error) {
        makeAlert(title: "Error", message: "Unable to add, please try again: \(error)")
    }
    
    func didAddToList() {
        print("Successfully added to the list")
        makeAlert(title: "Success", message: "Added to list")
    }
}
