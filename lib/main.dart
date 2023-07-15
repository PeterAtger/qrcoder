import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcoder/db/db_helper.dart';
import 'package:qrcoder/presentation/pages/qr_code_scanner_screen/qr_code_scanner_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = DatabaseHelper();
  await database.init();

  runApp(MyApp(
    key: const Key('App'),
    database: database,
  ));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper database;
  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Coder',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: QRCodeScannerScreen(database: database),
    );
  }
}
