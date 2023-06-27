import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(QRCodeScannerApp());
}

class QRCodeScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRCodeScannerPage(),
    );
  }
}

class QRCodeScannerPage extends StatefulWidget {
  @override
  _QRCodeScannerPageState createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  String qrText = '';
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scanned QR: $qrText'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isScanning = !isScanning;
              });
              isScanning
                  ? controller?.resumeCamera()
                  : controller?.pauseCamera();
            },
            child: Text(isScanning ? 'Stop Scanning' : 'Start Scanning'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code ?? '';
        print(qrText);
      });
      launchURL(qrText);
    });
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      print("launched");
    } else {
      print('Could not launch $url');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
