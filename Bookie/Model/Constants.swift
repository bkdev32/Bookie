//
//  Constants.swift
//  Bookie
//
//  Created by Burhan Kaynak on 03/09/2021.
//

import UIKit

enum B {
    enum General {
        public static let bookCell = "BookCell"
        public static let libraryCell = "LibraryCell"
        public static let emptyStar = UIImage(systemName: "star")
        public static let fullStar = UIImage(systemName: "star.fill")
        public static let halfStar = UIImage(systemName: "star.leadinghalf.fill")
    }
    enum Segue {
        public static let signInToHome = "signInToHomeVC"
        public static let signUpToHome = "signUpToHomeVC"
        public static let changeName = "toChangeNameVC"
        public static let changePassword = "toChangePasswordVC"
        public static let changePasstoSignIn = "changePasswordToSignInVC"
        public static let toBookDetail = "toBookDetailVC"
        public static let toListDetail = "toListDetailVC"
    }
    enum Fire {
        public static let collection = "Books"
        public static let wantToRead = "Want To Read"
        public static let read = "Read"
        public static let currentlyReading = "Currently Reading"
        public static let addedBy = "addedBy"
        public static let status = "status"
        public static let id = "id"
        public static let title = "title"
        public static let authors = "authors"
        public static let date = "date"
        public static let desc = "desc"
        public static let categories = "categories"
        public static let pageCount = "pageCount"
        public static let rating = "rating"
        public static let link = "link"
        public static let image = "image"
        public static let smallImage = "smallImage"
    }
}
