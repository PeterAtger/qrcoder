import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcoder/presentation/pages/qr_code_scanner_screen/qr_code_scanner_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const QRCodeScannerScreen(),
    );
  }
}
