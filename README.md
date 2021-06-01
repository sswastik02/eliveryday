# Eliveryday

An Android Food delivery with Map integration and Firebase app built using flutter 

# Technologies 
Flutter and Firebase

# Requirements

Basic Flutter Setup with Android SDK

# Setup

Add the Google API key to local.properties

### API Setup

```
google.map.key = AIzaS************
```

Add mapbox search API key by creating a new file
lib/Maps/mapboxAPI.dart

```
final kApiKey =
    'pk.eyJ*********************';
```


### Firebase Setup
Create a new project along with SHA-1 keys in firebase console
You can find instructions for doing that in the official [Firebase docs](https://firebase.google.com/docs/flutter/setup?platform=android). Be sure to include your SHA-1 key when you’re adding your Android app to the Firebase console you can find instructions for finding your SHA-1 in [Android’s official docs](https://developers.google.com/android/guides/client-auth)

#### Phone Auth
head to sign-in methods and turn on phone number

#### Firestore
create collections 'users' and 'carts'

# Screenshots

<img src="screenshots/home.png" style="zoom: 20%" />
<img src="screenshots/emptyCart.png" style="zoom: 20%" />
<img src="screenshots/emptyOrder.png" style="zoom: 20%" />
<img src="screenshots/noProfile.png" style="zoom: 20%" />
<img src="screenshots/cartWithLocation.png" style="zoom: 20%" />
<img src="screenshots/trackOrder.png" style="zoom: 20%" />
<img src="screenshots/diplayProfile.png" style="zoom: 20%" />
<img src="screenshots/checkout.png" style="zoom: 20%" />
<img src="screenshots/chooseLocation.png" style="zoom: 20%" />
<img src="screenshots/searchLocation.png" style="zoom: 20%" />
<img src="screenshots/phone.png" style="zoom: 20%" />
<img src="screenshots/verification.png" style="zoom: 20%" />
<img src="screenshots/profileInput.png" style="zoom: 20%" />
<img src="screenshots/orderMap.png" style="zoom: 20%" />
<img src="screenshots/orderMapDetails.png" style="zoom: 20%" />
<img src="screenshots/resturant.png" style="zoom: 20%" />
<img src="screenshots/resturant2.png" style="zoom: 20%" />
<img src="screenshots/usersFirebase.png" style="zoom: 20%" />
<img src="screenshots/cartFirebase.png" style="zoom: 20%" />







