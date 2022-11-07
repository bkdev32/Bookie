# 📚 Bookie

This app allows users to search for different books, add them to different lists (Currently Reading, Read, Want to Read). I have used Google Books API to be able to perform searches and retrieve information.

The data is saved online using Firebase and persisted locally to allow offline access.

I have used Firebase Authentication to allow users to sign up/log in. The books saved to the lists are persisted online using Cloud Firestore with offline cache.


I wanted to use some of the views twice without creating separate storyboards and as part of this, I have set up a simple Core Data model to persist saved book ids in order to update UI accordingly. For example, if a user is viewing a book already saved to their list, the BookDetailVieController will update and show them with two buttons to either remove from or update the list.
  
![bookie](https://user-images.githubusercontent.com/11230240/200288378-b90b5955-f889-40c3-91d5-b7d88abfbbd2.gif)


## Project Setup

To be able to run this project, you will need to have a [Firebase](https://firebase.google.com) account.

Set up a new project on Firebase Console and follow the instructions to add config file and Firebase SDK.

Clone the repository and run:

``` pod init ```

Add the following to your project Podfile

``` 
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'SDWebImage', '~> 5.0'
```

Then run:

``` pod install ```

Once the setup is completed, you will need to create a Firestore database and set-up the user Authentication. You can access the Firebase docs at [firebase.google.com](https://firebase.google.com/docs/build)

In order to access Google Books, you will need to obtain a free API key from [Google Books](https://developers.google.com/books). Add the API key to the project to be accessed by the BookManager



Book icons created by [Smashicons](https://www.flaticon.com/free-icons/book) - Flaticon

=====================


