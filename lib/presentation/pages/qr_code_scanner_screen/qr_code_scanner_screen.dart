import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:qrcoder/Controller/db_helper.dart';
import 'package:qrcoder/Models/person.dart';
import 'package:qrcoder/ResourceModels/person_from_bar.dart';
import 'dart:convert';

import 'package:qrcoder/presentation/components/data_table.dart';

class QRCodeScannerScreen extends StatelessWidget {
  final DatabaseHelper database;
  QRCodeScannerScreen({super.key, required this.database});

  final List<Person> people = [
    Person(name: 'a', group: 'ba'),
    Person(name: 'a', group: 'ta')
  ];

  Future<void> scanQRCode(BuildContext context) async {
    try {
      String name = '';
      ScanResult barcode = await BarcodeScanner.scan();
      String rawContent = barcode.rawContent;
      PersonFromBar personConverter = PersonFromBar(barCodeData: rawContent);
      // Either Person object or 0
      var person = personConverter.getPerson();
      if (person != 0) {
        name = person.name;
      } else {
        name = rawContent;
      }

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Scanned QR code'),
            content: Text(name),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Camera Access Denied'),
              content: const Text(
                  'Please grant camera permission to use QR code scanner.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error: ${ex.message}'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on FormatException {
      // User pressed the back button before scanning anything.
      return;
    } catch (ex) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error: $ex'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Coder'),
      ),
      body: FutureBuilder(
          future: database.getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return CustomDataTable(
              key: const Key('table'),
              data: snapshot.data!,
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code),
        onPressed: () => scanQRCode(context),
      ),
    );
  }
}
