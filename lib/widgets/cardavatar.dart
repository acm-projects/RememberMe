import 'package:flutter/material.dart';
import 'package:rememberme/services/cardservice.dart';

class CardAvatar extends StatefulWidget {
  const CardAvatar({super.key, this.card, this.radius, this.providerOverride});

  final PersonCard? card;
  final double? radius;
  final ImageProvider? providerOverride;

  @override
  State<CardAvatar> createState() => _CardAvatarState();
}

class _CardAvatarState extends State<CardAvatar> {
  bool _imageHasBeenRequested = true;
  final _defaultImageProvider = Image.asset('assets/avatar.webp').image;

  @override
  void initState() {
    super.initState();
    _updateImage();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;
    if (widget.providerOverride != null) {
      provider = widget.providerOverride;
    } else if (widget.card != null) {
      if (CardService.isImageCached(widget.card!.id)) {
        provider = CardService.getImageFromCache(widget.card!.id);
      } else if (!_imageHasBeenRequested) {
        _updateImage();
        _imageHasBeenRequested = true;
      }
    }

    return CircleAvatar(
      radius: widget.radius,
      backgroundImage: provider ?? _defaultImageProvider,
    );
  }

  _updateImage() {
    if (widget.card != null) {
      CardService.getImage(widget.card!.id).then((_) {
        if (mounted) {
          setState(() {
            _imageHasBeenRequested = false;
          });
        }
      });
    }
  }
}
