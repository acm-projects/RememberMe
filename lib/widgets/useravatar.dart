import 'package:flutter/material.dart';
import 'package:rememberme/services/userservice.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key, this.radius});

  final double? radius;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  ImageProvider? _imageProvider;
  static final _defaultProvider = Image.asset('assets/avatar.webp').image;

  @override
  void initState() {
    super.initState();
    _updateImage();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundImage: _imageProvider ?? _defaultProvider,
    );
  }

  _updateImage() {
    UserService.getUserAvatar().then((value) {
      setState(() {
        _imageProvider = value;
      });
    });
  }
}
