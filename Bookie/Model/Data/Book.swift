//
//  Book.swift
//  Bookie
//
//  Created by Burhan Kaynak on 05/09/2021.
//

import Foundation

struct Book {
    let addedBy: String
    let status: String
    let id: String
    let title: String
    let authors: [String]
    let date: String
    let desc: String
    let categories: [String]
    let pageCount: Int
    let rating: Double
    let link: String
    let image: String
    let smallImage: String
    
    init(addedBy: String = "", status: String = "", id: String = "", title: String = "", authors: [String] = [""], date: String = "", desc: String = "", categories: [String] = [""], pageCount: Int = 0, rating: Double = 0.0, link: String = "", image: String = "", smallImage: String = "" ) {
        self.addedBy = addedBy
        self.status = status
        self.id = id
        self.title = title
        self.authors = authors
        self.date = date
        self.desc = desc
        self.categories = categories
        self.pageCount = pageCount
        self.rating = rating
        self.link = link
        self.image = image
        self.smallImage = smallImage
    }
}
