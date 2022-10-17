import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:tickettouch/utils/helper_widgets.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  bool scanning = true;

  QRViewController? qrViewController;
  Barcode? ticket;

  @override
  void dispose() {
    super.dispose();
    qrViewController?.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await qrViewController!.pauseCamera();
    }
    qrViewController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return scanning
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                iconSize: 24,
                icon: const Icon(Icons.menu),
                onPressed: () =>
                    SimpleHiddenDrawerController.of(context).open(),
              ),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  buildQrView(context),
                ],
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              leading: IconButton(
                iconSize: 24,
                icon: const Icon(Icons.menu),
                onPressed: () =>
                    SimpleHiddenDrawerController.of(context).open(),
              ),
            ),
            backgroundColor: Colors.green,
            body: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                distanceHeight(30),
                const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 70,
                ),
                distanceHeight(20),
                const Text(
                  'VALID TICKET',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                distanceHeight(40),
                Expanded(
                  child: Container(),
                ),
                TicketWidget(
                  width: MediaQuery.of(context).size.width - 50,
                  height: MediaQuery.of(context).size.height * .45,
                  isCornerRounded: true,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Name: null'),
                      Text('Geburtsdatum: null'),
                      Text('Ticket Info'),
                      Text('Eventname: null '),
                      Text('Ticket-ID: TT-878983247320'),
                      Text('Scanned at: null'),
                    ],
                  ),
                ),
                distanceHeight(80),
                distanceWidth(MediaQuery.of(context).size.width)
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  scanning = true;
                  qrViewController!.resumeCamera();
                });
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              label: const Text(
                'CONTINUE',
                style: TextStyle(fontSize: 17),
              ),
              icon: const Icon(Icons.arrow_forward),
            ),
          );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        cameraFacing: CameraFacing.back,
        formatsAllowed: const [
          BarcodeFormat.qrcode,
        ],
        overlay: QrScannerOverlayShape(
          borderWidth: 10,
          borderLength: 40,
          borderRadius: 15,
          cutOutSize: MediaQuery.of(context).size.width * .75,
          //cutOutBottomOffset: MediaQuery.of(context).size.height * .17,
          borderColor: Theme.of(context).colorScheme.surface,
          overlayColor: Theme.of(context).backgroundColor,
        ),
      );

  void onQRViewCreated(QRViewController qrViewController) {
    setState(() => this.qrViewController = qrViewController);

    qrViewController.scannedDataStream.listen((ticket) {
      setState(() {
        if (ticket.code!.startsWith('TT')) {
          qrViewController.pauseCamera();
          scanning = false;
          HapticFeedback.vibrate();
        }
      });
    });
  }
}
