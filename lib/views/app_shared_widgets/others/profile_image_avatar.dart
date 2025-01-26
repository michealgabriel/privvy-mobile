import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:privvy/utils/app_theme_constants.dart';

class ProfileImageAvatar extends StatelessWidget {
  final String imagePath;
  final bool isLocalImage;
  final double? radius;
  final bool paintBackground;
  final double imageSize;
  const ProfileImageAvatar(
      {Key? key,
      required this.imagePath,
      required this.isLocalImage,
      this.radius = 60,
      this.paintBackground = false,
      this.imageSize = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      // backgroundColor: AppThemeConstants.APP_PRIMARY_COLOR,
      backgroundColor: paintBackground
          ? AppThemeConstants.APP_PRIMARY_COLOR
          : Colors.transparent,
      radius: radius,
      child: ClipOval(
          child: isLocalImage
              ? Image.asset(
                  imagePath,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: imagePath,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(radius: 10),
                )),
    );
  }
}
