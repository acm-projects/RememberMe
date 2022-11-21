import 'package:flutter/material.dart';
import 'package:rememberme/services/userservice.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key, this.radius});

  final double? radius;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  static final _defaultProvider = Image.asset('assets/avatar.webp').image;

  @override
  void initState() {
    super.initState();
    if (UserService.avatarNotifier.value == null) {
      UserService.getUserAvatar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserService.avatarNotifier,
      builder: (context, value, child) {
        return CircleAvatar(
          radius: widget.radius,
          backgroundImage: value ?? _defaultProvider,
        );
      },
    );
  }
}
