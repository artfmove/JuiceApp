import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class SelectLocation extends StatefulWidget {
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Select location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            PlatformTextField(
              keyboardType: TextInputType.emailAddress,
              cupertino: (_, __) => CupertinoTextFieldData(
                placeholder: 'Email',
              ),
              material: (_, __) => MaterialTextFieldData(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            TextFormField(
              initialValue: 'ggg',
            ),
          ],
        ),
      ),
    );
  }
}
