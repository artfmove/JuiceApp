import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:provider/provider.dart';
import '../provider/delivery_data.dart';
import '../provider/delivery_model.dart';

class EditProfileSettings extends StatefulWidget {
  final DeliveryModel initData;

  EditProfileSettings(this.initData);

  @override
  _EditProfileSettingsState createState() => _EditProfileSettingsState();
}

class _EditProfileSettingsState extends State<EditProfileSettings> {
  DeliveryModel deliveryModel;

  @override
  void initState() {
    deliveryModel = new DeliveryModel(
        firstName: widget.initData.firstName,
        lastName: widget.initData.lastName,
        street: widget.initData.street,
        number: widget.initData.number,
        zipCode: widget.initData.zipCode,
        city: widget.initData.city,
        country: widget.initData.country,
        phone: widget.initData.phone);
    super.initState();
  }
  // final _firstName = TextEditingController(text: '');
  //final _lastName = TextEditingController(text: '');
  // final _street = TextEditingController(text: '');
  // final _number = TextEditingController(text: '');
  // final _zipCode = TextEditingController(text: '');
  // final _city = TextEditingController(text: '');
  // final _country = TextEditingController(text: '');
  // final _phone = TextEditingController(text: '');

  @override
  void dispose() {
    // _firstName.dispose();
    // _lastName.dispose();
    // _number.dispose();
    // _zipCode.dispose();
    // _city.dispose();
    // _country.dispose();
    // _phone.dispose();
    super.dispose();
  }

  bool isDataEmpty() {
    print(deliveryModel);
    if (deliveryModel.firstName.isEmpty ||
        deliveryModel.lastName.isEmpty ||
        deliveryModel.street.isEmpty ||
        deliveryModel.number.isEmpty ||
        deliveryModel.zipCode.isEmpty ||
        deliveryModel.city.isEmpty ||
        deliveryModel.country.isEmpty ||
        deliveryModel.phone.isEmpty) {
      return true;
    } else
      return false;
  }

  void _sendData(DeliveryData delivery, BuildContext context, node) {
    if (isDataEmpty()) {
      showPlatformDialog(
          context: context,
          builder: (ctx) => PlatformAlertDialog(
                title: Text('Enter all entries'),
                actions: [
                  PlatformDialogAction(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(ctx).pop())
                ],
              ));
    } else {
      delivery.setDeliveryData(deliveryModel);
      node.unfocus();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    final delivery = Provider.of<DeliveryData>(context, listen: false);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Edit profile data'),
        trailingActions: [
          PlatformIconButton(
              icon: Icon(PlatformIcons(context).checkMark),
              onPressed: () => _sendData(delivery, context, node)),
        ],
      ),
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                onChanged: (value) => deliveryModel.firstName = value,
                decoration: InputDecoration(
                  labelText: 'First name',
                ),
                initialValue: deliveryModel.firstName,
                onEditingComplete: () => node.nextFocus(),
              ),
              TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Last name',
                  ),
                  initialValue: deliveryModel.lastName,
                  onEditingComplete: () => node.nextFocus(),
                  onChanged: (value) => deliveryModel.lastName = value),
              TextFormField(
                //controller: _street,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  labelText: 'Street',
                ),
                onChanged: (value) => deliveryModel.street = value.toString(),
                onEditingComplete: () => node.nextFocus(),
                initialValue: deliveryModel.street,
              ),
              TextFormField(
                //controller: _number,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number',
                ),
                onChanged: (value) => deliveryModel.number = value.toString(),
                onEditingComplete: () => node.nextFocus(),
                initialValue: deliveryModel.number,
              ),
              TextFormField(
                  // controller: _zipCode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Zip Code',
                  ),
                  onChanged: (value) =>
                      deliveryModel.zipCode = value.toString(),
                  onEditingComplete: () => node.nextFocus(),
                  initialValue: deliveryModel.zipCode),
              TextFormField(
                  //controller: _city,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'City',
                  ),
                  onChanged: (value) => deliveryModel.city = value,
                  onEditingComplete: () => node.nextFocus(),
                  initialValue: deliveryModel.city),
              TextFormField(
                //controller: _country,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Country',
                ),
                onChanged: (value) => deliveryModel.country = value,
                onEditingComplete: () => node.nextFocus(),
                initialValue: deliveryModel.country,
              ),
              TextFormField(
                //controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                ),
                onChanged: (value) => deliveryModel.phone = value.toString(),
                onEditingComplete: () => _sendData(delivery, context, node),
                initialValue: deliveryModel.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
