import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rememberme/screens/modifycard.dart';
import 'package:rememberme/services/authservice.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/widgets/roundedpage.dart';
import 'package:rememberme/widgets/useravatar.dart';

class QRView extends StatefulWidget {
  const QRView({super.key});

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  @override
  Widget build(BuildContext context) {
    return RoundedPage(
      roundedMargin: 200,
      bodyMargin: 0,
      useListView: false,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: const UserAvatar(
                    radius: 64,
                  ),
                ),
                Flexible(
                  child: Text(
                    'Nice to Meet You! I\'m ${AuthService.getUser()?.displayName}.',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: AlignmentDirectional.center,
            margin: const EdgeInsets.only(top: 75),
            child: QrImage(
              data: CardService.getPublicCardId(),
              version: QrVersions.auto,
              size: MediaQuery.of(context).size.width * 0.85,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            child: TextButton(
              onPressed: () async {
                var tuple = await CardService.getPublicCardAndImage();
                if (mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ModifyCard(
                      existingCard: tuple?.item1,
                      existingImage: tuple?.item2,
                      personal: true,
                    ),
                  ));
                }
              },
              child: const Text(
                'Edit Personal Card',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
