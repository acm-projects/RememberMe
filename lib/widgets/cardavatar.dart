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
  static final _defaultProvider = Image.asset('assets/avatar.webp').image;

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      var id = widget.card!.id;
      if (!CardService.isImageCached(id)) {
        CardService.getImage(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CardService.imageNotifier,
      builder: (context, value, child) {
        ImageProvider? prov;
        if (widget.card != null && CardService.isImageCached(widget.card!.id)) {
          prov = CardService.getImageFromCache(widget.card!.id);
        }
        return CircleAvatar(
          radius: widget.radius,
          backgroundImage: widget.providerOverride ?? prov ?? _defaultProvider,
        );
      },
    );
  }
}
