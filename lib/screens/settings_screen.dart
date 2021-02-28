import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
              radius: 100,
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textColor: Colors.blue,
            ),

            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.g_translate,
                      color: Colors.purple,
                    ),
                    title: Text("Change Language"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      //open change language
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.purple,
                    ),
                    title: Text("Change Location"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      //open change location
                    },
                  ),
                ],
              ),
            ),
            //Sync settings section
            const SizedBox(height: 10.0),
            ValueListenableBuilder(
                valueListenable: Hive.box('settings').listenable(),
                builder: (context, box, widget) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SwitchListTile(
                        activeColor: Colors.cyanAccent,
                        inactiveTrackColor: Colors.white30,
                        contentPadding: const EdgeInsets.all(0),
                        value: box.get('cloudBackup', defaultValue: true),
                        title: Text(
                          'Automaticaly uploade backups to the cloud',
                          style: TextStyle(color: Colors.white),
                        ),
                        onChanged: null,
                      ),
                      SwitchListTile(
                        activeColor: Colors.cyanAccent,
                        inactiveTrackColor: Colors.white30,
                        contentPadding: const EdgeInsets.all(0),
                        value: box.get('gcSync', defaultValue: false),
                        title: Text(
                          'Automaticaly synchronize with Google calendar',
                          style: TextStyle(color: Colors.white),
                        ),
                        onChanged: (val){
                          box.put('gcSync', val);
                          box.put('showAlert', !val);
                        },
                      ),
                      //notifications settings section
                      const SizedBox(height: 10.0),
                      Text(
                        'Notification Settings',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SwitchListTile(
                        activeColor: Colors.cyanAccent,
                        inactiveTrackColor: Colors.white30,
                        contentPadding: const EdgeInsets.all(0),
                        value: box.get('notifications', defaultValue: true),
                        title: Text(
                          'Receive Notifications',
                          style: TextStyle(color: Colors.white),
                        ),
                        onChanged: (val) {
                          box.put('notifications', val);
                        },
                      ),
                      SwitchListTile(
                        activeColor: Colors.cyanAccent,
                        inactiveTrackColor: Colors.white30,
                        contentPadding: const EdgeInsets.all(0),
                        value: box.get('reminders', defaultValue: true),
                        title: Text(
                          'Reminders',
                          style: TextStyle(color: Colors.white),
                        ),
                        onChanged: null,
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
