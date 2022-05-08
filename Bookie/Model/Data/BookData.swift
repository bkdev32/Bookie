//
//  Books.swift
//  Bookie
//
//  Created by Burhan Kaynak on 04/09/2021.
//

import Foundation

// MARK: - BooksData
struct BooksData: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: String
    let selfLink: String
    let volumeInfo: VolumeInfo
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let description: String?
    let publishedDate: String?
    let pageCount: Int?
    let categories: [String]?
    let imageLinks: ImageLinks?
    let averageRating: Double?
    let previewLink: String?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String
}
