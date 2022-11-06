//
//  HomeViewController.swift
//  Bookie
//
//  Created by Burhan Kaynak on 03/09/2021.
//

import UIKit
import SDWebImage

class HomeViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var bookManager = BookManager()
    var books = [Book]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookManager.delegate = self
        searchBar.delegate = self
        tabBarController!.navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: B.General.bookCell, bundle: nil), forCellReuseIdentifier: B.General.bookCell)
    }
}

// MARK: - SEARCH BAR
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        bookManager.fetchBooks(with: searchBar.text!)
        searchBar.text = ""
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

// MARK: - BookManager
extension HomeViewController: BookManagerDelegate {
    func didAddToList() {}
    
    func didFetchBooks(manager: BookManager, books: [Book]) {
        DispatchQueue.main.async {
            self.books = books
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.makeAlert(title: "Error", message: error.localizedDescription)
        }
    }
}

// MARK: - TableView
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: B.Segue.toBookDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BookDetailViewController
        if let index = tableView.indexPathForSelectedRow {
            let book = Book(
                addedBy: books[index.row].addedBy,
                status: books[index.row].status,
                id: books[index.row].id,
                title: books[index.row].title,
                authors: books[index.row].authors,
                date: books[index.row].date,
                desc: books[index.row].desc,
                categories: books[index.row].categories,
                pageCount: books[index.row].pageCount,
                rating: books[index.row].rating,
                link: books[index.row].link,
                image: books[index.row].image,
                smallImage: books[index.row].smallImage
            )
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
