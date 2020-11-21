![App Brewery Banner](Documentation/AppBreweryBanner.png)

# Flash-Chat

## Our Goal

One of the most fundamental component of modern iOS apps is the Table View. Table Views are used everywhere from the Mail app to the Messages app. It’s a crucial part of every iOS developer’s tool belt. In this tutorial we’ll be getting to grips with Table Views, creating custom cells, and making our own cloud-based backend database. It’s going to be epic, so buckle up.

## What you will create

Flash Chat is an internet based messaging app similar to WhatsApp, the popular messaging app that was bought by Facebook for $22 billion. We will be using a service called Firebase Firestore as a backend database to store and retrieve our messages from the cloud. 

## What you will learn

* How to integrate third party libraries in your app using Cocoapods and Swift Package Manager.
* How to store data in the cloud using Firebase Firestore.
* How to query and sort the Firebase database.
* How to use Firebase for user authentication, registration and login.
* How to work with UITableViews and how to set their data sources and delegates.
* How to create custom views using .xib files to modify native design components.
* How to embed View Controllers in a Navigation Controller and understand the navigation stack.
* How to create a constants file and use static properties to store Strings and other constants.
* Learn about Swift loops and create animations using loops.
* Learn about the App Lifecycle and how to use viewWillAppear or viewWillDisappear.
* How to create direct Segues for navigation.

>This is a companion project to The App Brewery's Complete App Developement Bootcamp, check out the full course at [www.appbrewery.co](https://www.appbrewery.co/)

![End Banner](Documentation/readme-end-banner.png)

## Denis' Notes

* Added email and password validation; also added error messages, displayed via an alert pop-up. 
* Changed the authentication workflow: starting with a single email field first checking whether such an email address has already been registered with FirebaseAuth. If it's been already registered, segueing to the LoginViewController and passing the email address. If it hasn't been already registered, segueing to the RegisterViewController and passing the email address.
* Persisting a custom session with user email in UserDefaults: added a profileInfo Dictionary with an email key, saving it in UserDefaults. Checking with FirebaseAuth whether Auth.auth().currentUser != nil i.e. whether a user is already logged-in, and segueing to the ChatViewController if so. If the user email saved in UserDefaults is different from the currently logged-in user, saving the currently logged-in user's email address in UserDefaults. Upon calling Auth.auth().createUser(withEmail:password:) or Auth.auth().signIn(withEmail:password:) also saving the currently logged-in user's email address in UserDefaults.
