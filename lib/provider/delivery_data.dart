import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import './delivery_model.dart';

class DeliveryData with ChangeNotifier {
  DatabaseReference database = FirebaseDatabase.instance.reference();
  String authId = FirebaseAuth.instance.currentUser.uid;
  DeliveryModel data;

  Future<void> setDeliveryData(DeliveryModel data) async {
    await database
        .child('users')
        .child(authId)
        .set({
          'firstName': data.firstName,
          'lastName': data.lastName,
          'street': data.street,
          'number': data.number,
          'zip_code': data.zipCode,
          'city': data.city,
          'country': data.country,
          'phone': data.phone,
        })
        .then((value) => print(data))
        .catchError((error) => print(error));
    notifyListeners();
  }

  Future<DeliveryModel> getDeliveryData() async {
    data = new DeliveryModel();
    await database
        .child('users')
        .child(authId)
        .once()
        .then((DataSnapshot dataSn) {
      if (dataSn != null)
        data = DeliveryModel(
            firstName: dataSn.value['firstName'],
            lastName: dataSn.value['lastName'],
            street: dataSn.value['street'],
            number: dataSn.value['number'].toString(),
            zipCode: dataSn.value['zip_code'].toString(),
            city: dataSn.value['city'],
            country: dataSn.value['country'],
            phone: dataSn.value['phone'].toString());
    }).catchError((onError) => print('${onError}rrrrr'));
    print(data.firstName);
    return data;
  }

  DeliveryModel getSingleData() {
    return data;
  }
}
