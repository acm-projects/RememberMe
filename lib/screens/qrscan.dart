import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rememberme/screens/modifycard.dart';
import 'package:rememberme/screens/qrview.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:tuple/tuple.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  static const Color bgColor = Color(0x44000000);

  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => _controller.switchCamera(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller.torchState,
              builder: (context, value, child) {
                switch (value) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
        elevation: 0,
        backgroundColor: bgColor,
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const QRView()),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        child: const Icon(Icons.qr_code_2),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (barcode, args) => _showScanDialog(barcode.rawValue),
      ),
    );
  }

  void _showScanDialog(String? data) async {
    Widget getErrorDialog(String err) => AlertDialog(
          content: Text(err),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Exit'),
            )
          ],
        );

    if (data == null) {
      showDialog(
        context: context,
        builder: (_) => getErrorDialog('Failed to read any data from QR Code.'),
      );
    } else {
      var res = await showDialog<Tuple2<PersonCard, File?>>(
        context: context,
        builder: (context) {
          return FutureBuilder(
            future: CardService.getPublicCardAndImage(id: data),
            builder: (ctx, snapshot) {
              if (snapshot.hasData || snapshot.hasError) {
                if (snapshot.data != null) {
                  Navigator.of(ctx).pop(snapshot.data);
                  return Container();
                } else {
                  return getErrorDialog(
                    'Failed to retrieve card data. ${snapshot.error}',
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      );
      if (mounted) {
        if (res != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ModifyCard(
                existingCard: res.item1,
                existingImage: res.item2,
                saveToNewCard: true,
              ),
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }
}
