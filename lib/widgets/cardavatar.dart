import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rememberme/services/authservice.dart';
import 'package:rememberme/services/cardservice.dart';

class CardAvatar extends StatelessWidget {
  final PersonCard? card;
  final String? localImage;
  final double? radius;

  const CardAvatar({super.key, this.card, this.localImage, this.radius});

  @override
  Widget build(BuildContext context) {
    if (localImage != null) {
      return _getAvatar(Image.file(File(localImage!)).image);
    } else {
      final defaultImageProvider = Image.asset('assets/avatar.webp').image;
      if (card != null && AuthService.isUserSignedIn()) {
        return FutureBuilder(
          future: card!.getImageURL(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return _getAvatar(CachedNetworkImageProvider(snapshot.data!));
            } else {
              return _getAvatar(defaultImageProvider);
            }
          },
        );
      } else {
        return _getAvatar(defaultImageProvider);
      }
    }
  }

  Widget _getAvatar(ImageProvider provider) {
    return CircleAvatar(
      maxRadius: radius,
      minRadius: radius,
      backgroundImage: provider,
    );
  }
}
