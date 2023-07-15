import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:qrcoder/db/db_helper.dart';
import 'package:qrcoder/ResourceModels/person_from_bar.dart';
import 'package:qrcoder/presentation/components/group_data_table.dart';
import 'dart:convert';

import 'package:qrcoder/presentation/components/person_data_table.dart';

class QRCodeScannerScreen extends StatefulWidget {
  final DatabaseHelper database;
  const QRCodeScannerScreen({super.key, required this.database});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  int currentPageIndex = 0;

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
        widget.database.insertPerson(person);
        setState(() {});
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
      body: <Widget>[
        FutureBuilder(
            future: widget.database.getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return PersonDataTable(
                key: const Key('table'),
                data: snapshot.data!,
              );
            }),
        FutureBuilder(
            future: widget.database.getGroupData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GroupDataTable(
                key: const Key('group_table'),
                data: snapshot.data!,
              );
            }),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Person',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.group),
            icon: Icon(Icons.group_outlined),
            label: 'Group',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code),
        onPressed: () => scanQRCode(context),
      ),
    );
  }
}
