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
    
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
