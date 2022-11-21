import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rememberme/screens/login-signup.dart';
import 'package:rememberme/screens/modifycard.dart';
import 'package:rememberme/screens/qrview.dart';
import 'package:rememberme/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rememberme/services/cardservice.dart';
import 'package:rememberme/services/userservice.dart';
import 'package:rememberme/widgets/roundedpage.dart';
import 'package:rememberme/widgets/useravatar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return RoundedPage(
      roundedMargin: 200,
      bodyMargin: 0,
      useListView: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () async {
                      var picker = ImagePicker();
                      var image = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 512,
                        maxWidth: 512,
                      );
                      if (image != null) {
                        await UserService.updateUserAvatar(File(image.path));
                        setState(() {});
                      }
                    },
                    child: const Hero(
                      tag: 'userAvatar',
                      child: UserAvatar(
                        radius: 64,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    AuthService.getUser()?.displayName ?? 'Hello!',
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
            margin: const EdgeInsets.only(top: 80),
            child: RichText(
              text: TextSpan(
                text: 'Email\n',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: AuthService.getUser()?.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            margin: const EdgeInsets.only(top: 20),
            child: RichText(
              text: TextSpan(
                text: 'Verification Status\n',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: AuthService.getUser()?.emailVerified == true
                        ? 'Verified'
                        : 'Unverified',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            margin: const EdgeInsets.only(top: 20),
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const QRView()),
              ),
              icon: const Icon(Icons.qr_code, size: 24),
              label: const Text(
                'View Personal QR Code',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () async {
                var tuple = await CardService.getPublicCardAndImage();
                if (mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ModifyCard(
                        existingCard: tuple?.item1,
                        existingImage: tuple?.item2,
                        personal: true,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.note_add_outlined, size: 24),
              label: const Text(
                'Edit Personal Card',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.fromLTRB(40, 0, 40, 40),
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginOptions()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    //to set border radius to button
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
