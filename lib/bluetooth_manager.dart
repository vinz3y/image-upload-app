import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothManager {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  Future<void> connectToESP32(String deviceName) async {
    // Scan for devices
    await flutterBlue.startScan(timeout: Duration(seconds: 5));

    // Look for the ESP32 device
    var scanSubscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name == deviceName) {
          // Stop scanning and connect to the device
          flutterBlue.stopScan();
          _connectToDevice(result.device);
          return;
        }
      }
    });

    // Dispose of the subscription after a certain time
    await Future.delayed(Duration(seconds: 10));
    scanSubscription.cancel();
    await flutterBlue.stopScan();
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    await device.connect();

    // Discover services and characteristics
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        // Implement your communication logic here
      }
    }
  }
}
