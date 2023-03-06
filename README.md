# Parcel App

Parcal App is application which simulates working with parcel machine and sending or received packages. Also app allows to return packages. Parcel App delievers basic authentication and autorization. All these functionalities are delievered by Firebase and Firestore. App uses Bloc and Hydrated Bloc to manage and persist states. These libraries are used for packages, user state, returns, fonts, themes and language (Parcel App supports internationalization with Polish and English languages). Google Maps API is also included in app for searching parcel machines. 

## Technologies, libraries and APIs

* Flutter
* Firebase
* Firestore
* Bloc
* HydratedBloc
* Google Maps API
* intl (Internationalization)
* Geolocator


## Overview

* ### Sign In, Sign Up, Sign Out, Forgot Password and validation
    First of widgets are Sign In and Sign Up widgets, presented in the images below: 

    ![SignIn](assets/images/readme/SignIn.png) 
    ![SignUp](assets/images/readme/SignUp.png)
    
    User can toggle between both widgets by hitting Sign Up and Sign In text buttons.


    When form is not valid (I mean, in both widgets) there is specific info in each form fields. 
    
    ![SignInInvalid](assets/images/readme/SignInInvalid.png) 
    ![SignUpInvalid](assets/images/readme/SignUpInvalid.png)     


    Confirmation password field is not valid only when it's value is different than Password form field value.

    App includes proper messaging after different activities. For example, when user typed wrong credentials for his/her account, there is info about that:
    
    ![SignInIncorrect](assets/images/readme/SignInIncorrect.png)    

    Also, if user tries to sign out with existing email:
    
    ![SignUpIncorrect](assets/images/readme/SignUpIncorrect.png) 


    Scenario when account is created (app automatically navigates user to Sign In widget):
    
    ![SignUpCorrect](assets/images/readme/SignUpCorrect.png) 

    Successful sign in operation navigates to Home widget with info about it:
    
    ![SignInCorrect](assets/images/readme/SignInCorrect.png) 
    
    By hitting three dots in right-up corner, there is menu widget. When user clicks "Sign out", app navigates back to Sign In widget with information about successful signing out.

    ![AppBarMenu](assets/images/readme/AppBarMenu.png) 
    ![SignOut](assets/images/readme/SignOut.png) 

    Another text button called "Forgot password?" navigates to widget which enables user to reset his/her password. This functionality is delivered by Firebase, same as Sign Up and Sign In.
    
    ![ForgetPassword](assets/images/readme/ForgotPassword.png)

* ### Send packages
    In Parcel App, user is able to list sent package and send new one to another registered user. "Sent" item on a bottom bar navigates to widget. By clicking Floating Action Button in the Sent Package widget, send package form shows up. 

    ![SentPackagesEmpty](assets/images/readme/SentPackagesEmpty.png) 
    ![SendPackageForm](assets/images/readme/SendPackageForm.png) 
    
    If user wants to send package, he/she must type correct information about receiver, who must be signed up. If, at least, one of the first three wafield is wrong, package wont be created. Also, user cannot send package to himself/herself. Example:

     ![SendPackageInvalid](assets/images/readme/SendPackageInvalid.png) 

     About last two fields, which are: address of sender's parcel machine and address of receiver parcel machine. These addresses are deliverd by Google Maps API. When user clicks one of the field, app navigates to Google Maps widget. There user can type searched address and Google Maps shows nearby parcel machines. These machines are not mocked up. There was a problem with searching them, because there is not any type regarded to parcels machines. That is why apps looks for objects with "Paczkomat" ("Parcel machine" in English) phrase in theirs names. Another problem was that apps can search parcel machines only within Poland. After choosing marker with search parcel machine and clicking Floating Action Button, app navigates back to form with parcel machine's address as value in clicked form. 
    
    ![GoogleMapsChosenParcel](assets/images/readme/GoogleMapsChosenParcel.png) 
    ![SendPackageFormWithAddr](assets/images/readme/SendPackageFormWithAddr.png) 

    If payload is valid, package is created with navigation back to Sent Packages widget with info:

    ![SendPackageSuccess](assets/images/readme/SendPackageSuccess.png) 


    Few things to clarify. Firstly, "Address track" button shows chosen sender's parcel machine on Maps. Secondly, "Non received" and "Received" tabs. "Non received" tab shows packages sent by user (sender) by not yet received by receiver. "Received" shows already received packages by receiver and those sent by user(sender).

    Obviously, user can deleted his sent packages from history. He/she can delete single or multiple packages. Single delete can be done by hitting red button with delete icon. To delete multiple packages, user has to click on the one of packages. Checkboxes with buttons show up. 

    ![SentPackagesDeleteCheckboxes](assets/images/readme/SentPackagesDeleteCheckboxes.png) 

    First button from left deletes selected packages, middle one - selects all packages, right one - clears checkboxes and hids checkboxes with buttons. 

    When user presses button with selected packages, alert confirmation dialog pops up. If user chooses Cancel, no deleting is being proccess and dialog disappears, but pressing button Delete, removes selected packages and navigates back to Sent Packages widget with correct information.

    ![DeletePackagesDialog](assets/images/readme/DeletePackagesDialog.png) 
    ![PackagesDeleted](assets/images/readme/PackagesDeleted.png) 
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
