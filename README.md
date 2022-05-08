# 📚 Bookie


This app allows users to search for different books, mark them as Currently Reading, Read or Want to Read and leave notes. I have used Google Books API to perform searches and retrieve information.

The data is saved online using Firebase and persisted locally to allow offline access.

I have used Firebase Authentication to allow users to sign up/log in. The users can message and the messages are persisted online using Cloud Firestore.
  



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

=====================


