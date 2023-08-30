import 'package:flutter/material.dart';
import 'package:image_upload_app/settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _deviceId = '';
  String _serviceUuid = '';
  String _characteristicUuid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _deviceId = value;
                });
              },
              decoration: InputDecoration(labelText: 'Device ID'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  _serviceUuid = value;
                });
              },
              decoration: InputDecoration(labelText: 'Service UUID'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  _characteristicUuid = value;
                });
              },
              decoration: InputDecoration(labelText: 'Characteristic UUID'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Save settings and navigate back
                Navigator.pop(context, {
                  'deviceId': _deviceId,
                  'serviceUuid': _serviceUuid,
                  'characteristicUuid': _characteristicUuid,
                });
              },
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
