import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:juiceApp/screens/edit_profile_settings.dart';
import '../provider/auth.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../provider/delivery_data.dart';
import '../provider/cart.dart';

class Settings extends StatefulWidget {
  final BuildContext context;
  Settings(this.context);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notification = false;

  void toggleNotification() {
    setState(() {
      notification = !notification;
    });
  }

  @override
  void dispose() {
    print('PRODUCTS GRIIIIIID SETTINGS');
    super.dispose();
  }

  String currAddress;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return FutureBuilder(
        future:
            Provider.of<DeliveryData>(context, listen: true).getDeliveryData(),
        builder: (ctx, snapshot) {
          final singleData = Provider.of<DeliveryData>(context).getSingleData();
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: 'Common',
                  tiles: [
                    SettingsTile(
                      title: 'Language',
                      subtitle: 'English',
                      leading: Icon(Icons.language),
                      onPressed: (BuildContext context) {},
                    ),
                    SettingsTile.switchTile(
                        title: 'Notification',
                        leading: Icon(Icons.notification_important),
                        switchValue: notification,
                        onToggle: (bool value) {
                          toggleNotification();
                        }),
                  ],
                ),
                SettingsSection(
                  title: 'Account',
                  tiles: [
                    SettingsTile(
                      title: 'Delivery data',
                      subtitle:
                          snapshot.connectionState == ConnectionState.waiting
                              ? 'None'
                              : singleData.zipCode == null
                                  ? 'None'
                                  : singleData.zipCode,
                      leading: Icon(PlatformIcons(context).person),
                      onPressed:
                          snapshot.connectionState == ConnectionState.waiting
                              ? (_) {}
                              : (_) {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) =>
                                          new EditProfileSettings(singleData),
                                    ),
                                  );
                                },
                    ),
                    SettingsTile(
                      title: 'Profile',
                      subtitle:
                          (auth.getUser() != null ? auth.getUser() : 'None'),
                      leading: Icon(PlatformIcons(context).location),
                      onPressed: (_) {
                        //_locationDialog(context, location);
                      },
                    ),
                    SettingsTile(
                      title: 'Sign Out',
                      subtitle: null,
                      leading: Icon(PlatformIcons(context).home),
                      onPressed: (_) => showPlatformDialog(
                          context: context,
                          builder: (ctx) => PlatformAlertDialog(
                                title: Text(
                                  'Confirm',
                                ),
                                content: Text('Do you want to logout?'),
                                actions: <Widget>[
                                  PlatformDialogAction(
                                      child: Text('Cancel'), onPressed: () {}),
                                  PlatformDialogAction(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      // Provider.of<Auth>(context, listen: false)
                                      //     .resetData();
                                      // Provider.of<Cart>(context, listen: false)
                                      //     .resetData();
                                      // Provider.of<DeliveryData>(context,
                                      //         listen: false)
                                      //     .resetData();
                                      auth.signOut();
                                      Navigator.pushNamedAndRemoveUntil(
                                          widget.context,
                                          '/auth-screen',
                                          (_) => false);
                                    },
                                  ),
                                ],
                              )),
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Misc',
                  tiles: [
                    SettingsTile(
                        title: 'Terms of Service',
                        leading: Icon(Icons.description)),
                    SettingsTile(
                        title: 'Open source licenses',
                        leading: Icon(Icons.collections_bookmark)),
                  ],
                ),
              ],

              //Text(auth.getUser().displayName)
              //Image.network(auth.getUser().photoURL),
            ),
          );
        });
  }
}
