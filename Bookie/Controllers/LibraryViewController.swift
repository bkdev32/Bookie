//
//  LibraryViewController.swift
//  Bookie
//
//  Created by Burhan Kaynak on 07/09/2021.
//

import UIKit

class LibraryViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: B.Segue.toListDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ListDetailViewController
        if let index = tableView.indexPathForSelectedRow {
            if index.row == 0 {
                destination.list = B.Fire.wantToRead
            } else if index.row == 1 {
                destination.list = B.Fire.currentlyReading
            } else if index.row == 2 {
                destination.list = B.Fire.read
            }
        }
    }
}
