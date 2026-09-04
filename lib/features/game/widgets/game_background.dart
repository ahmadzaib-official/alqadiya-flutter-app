import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';

class GameBackground extends StatelessWidget {
  GameBackground({
    super.key,
    required this.imageUrl,
    required this.body,
    this.isPurchased = false,
  });
  final String imageUrl;
  final Widget body;
  final bool isPurchased;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    isPurchased
                        ? CachedNetworkImageProvider(imageUrl)
                        : AssetImage(MyImages.gamebackground),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          if (isPurchased)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MyColors.backgroundColor.withValues(alpha: 0.5),
                    MyColors.backgroundColor.withValues(alpha: 0.6),
                    MyColors.backgroundColor.withValues(alpha: 0.7),
                    MyColors.backgroundColor.withValues(alpha: 0.8),
                    MyColors.backgroundColor.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          body,
        ],
      ),
    );
  }
}
