import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';



class Controller extends GetxController {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  Future scanDvice() async {
    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 10));

    // Delay to allow scanning to run for the specified duration
    await Future.delayed(const Duration(seconds: 5));

    // Stop scanning after the desired duration
    flutterBlue.stopScan();

    // Important: You should await for the scan to complete and then stop it
    await flutterBlue.stopScan();
  }

  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;
}

/*

class Controller extends GetxController {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  Future scanDvice() async {
    flutterBlue.startScan(timeout: const Duration(seconds: 5));
    flutterBlue.stopScan();
  }

  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;
}*/
