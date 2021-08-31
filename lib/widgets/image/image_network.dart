import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNetwork extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final IconData? errorIcon;

  const ImageNetwork(
      {Key? key,
      required this.imageUrl,
      this.fit,
      this.width,
      this.height,
      this.errorIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit ?? BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Container(color: Theme.of(context).primaryColor),
        errorWidget: (context, url, error) => Container(
            color: Colors.grey.withOpacity(0.1),
            child: Icon(
              errorIcon ?? Icons.image,
              color: Theme.of(context).accentColor,
            )),
        width: width,
        height: height);
  }
}
