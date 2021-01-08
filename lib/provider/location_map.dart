// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'dart:convert';
// import 'package:firebase_database/firebase_database.dart';

// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';

// class LocationMap with ChangeNotifier {
//   final database = FirebaseDatabase.instance.reference();

//   static const GOOGLE_API_KEY = 'AIzaSyBLApT08sXa99PA3XbjZ89zXY_j6EaGUXc';

//   LatLng latLng;
//   String address;

//   setCurrentLocation() async {
//     final authId = await FirebaseAuth.instance.currentUser.uid;
//     await getCurrentLocation();
//     await getPlaceAddress();

//     await database
//         .child('users')
//         .child(authId)
//         .set({
//           'address': address,
//           'latitude': latLng.latitude,
//           'longitude': latLng.longitude,
//         })
//         .then((value) => print(address))
//         .catchError((error) => print('error location'));
//   }

//   Future<String> getLocationFromFirebase() async {
//     final authId = await FirebaseAuth.instance.currentUser.uid;
//     await database
//         .child('users')
//         .child(authId)
//         .once()
//         .then((DataSnapshot dataSnapshot) {
//       address = dataSnapshot.value['address'];
//       latLng = LatLng(double.parse(dataSnapshot.value['latitude']),
//           double.parse(dataSnapshot.value['longitude']));
//     }).then((value) {
//       if (address == null) address = 'No location selected';
//     }).catchError((onError) => print('error getLocation'));

//     return address;
//   }

//   String getAddressFromFirebase() {
//     getLocationFromFirebase();

//     return address;
//   }

//   LatLng getLatLng() {
//     return latLng;
//   }

//   Future<void> getCurrentLocation() async {
//     Location location = new Location();

//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//     LocationData _locationData;

//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     _locationData = await location.getLocation();
//     latLng = LatLng(_locationData.latitude, _locationData.longitude);
//   }

//   String generateLocationPreviewImage() {
//     return 'https://maps.googleapis.com/maps/api/staticmap?center=&${latLng.latitude},${latLng.longitude}&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${latLng.latitude},${latLng.longitude}&key=$GOOGLE_API_KEY';
//   }

//   Future<String> getPlaceAddress() async {
//     print(latLng.latitude);
//     print(latLng.longitude);
//     final url =
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$GOOGLE_API_KEY';
//     final response = await http.get(url);
//     // address = json.decode(response.body)['results'][0]['address_components']
//     //     ['postal_code'];
//     address = json.decode(response.body)['results'][0]['formatted_address'];
//     print(address);
//     return address;
//   }
// }

// // GoogleMap(
// //                         initialCameraPosition: CameraPosition(
// //                           target: LatLng(location.getLatLng().latitude,
// //                               location.getLatLng().longitude),
// //                           zoom: 16,
// //                         ),
// //                         markers: {
// //                           Marker(
// //                             markerId: MarkerId('m1'),
// //                             position: LatLng(location.getLatLng().latitude,
// //                                 location.getLatLng().longitude),
// //                           ),
// //                         },
// //                         onTap: _selectLocation,
// //                       ),
