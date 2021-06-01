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

### Initial View
<img src="screenshots/home.png"/><img src="screenshots/emptyCart.png"/>
<img src="screenshots/emptyOrder.png"/><img src="screenshots/noProfile.png"/>

### Restuarants
<img src="screenshots/resturant.png"/><img src="screenshots/resturant2.png"/>

### During Order

<img src="screenshots/cartWithLocation.png"/><img src="screenshots/checkout.png"/>
<img src="screenshots/trackOrder.png"/><img src="screenshots/displayProfile.png"/>

### Choosing Delivery Location


<img src="screenshots/chooseLocation.png"/><img src="screenshots/searchLocation.png"/>

### Phone Auth and Profile

<img src="screenshots/phone.png"/><img src="screenshots/verification.png"/>
<img src="screenshots/profileInput.png"/>

### Order Display on Maps

<img src="screenshots/orderMap.png"/><img src="screenshots/orderMapDetails.png"/>

### Firebase display

<img src="screenshots/usersFirebase.png"/><img src="screenshots/cartFirebase.png"/>








