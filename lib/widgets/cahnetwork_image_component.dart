import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? imageUrl; // Make nullable
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? borderRadius;
  final Color? color;
  final String placeholderImage; // Add custom placeholder option

  const NetworkImageWidget({
    super.key,
    this.height,
    this.width,
    this.fit,
    this.imageUrl,
    this.borderRadius,
    this.errorWidget,
    this.color,
    this.placeholderImage =
        AppStrings.placeHolderImage, // Default to your constant
  });

  @override
  Widget build(BuildContext context) {
    final imgHeight = height ?? Responsive.height(8, context);
    final imgWidth = width ?? Responsive.width(15, context);

    // If no imageUrl provided or it's empty, show placeholder immediately
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder(imgHeight, imgWidth);
    }

    // Validate URL format
    if (!Uri.tryParse(imageUrl!)!.hasAbsolutePath) {
      return _buildPlaceholder(imgHeight, imgWidth);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit:
          fit ??
          BoxFit.cover, // Changed from fitWidth to cover for better display
      height: imgHeight,
      width: imgWidth,
      color: color,
      imageBuilder:
          (context, imageProvider) => ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
            child: Image(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
              height: imgHeight,
              width: imgWidth,
            ),
          ),
      progressIndicatorBuilder:
          (context, url, downloadProgress) =>
              _buildShimmerLoader(imgHeight, imgWidth),
      errorWidget:
          (context, url, error) =>
              errorWidget ?? _buildPlaceholder(imgHeight, imgWidth),
    );
  }

  Widget _buildShimmerLoader(double height, double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(double height, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      child: CachedNetworkImage(
        imageUrl: placeholderImage,
        fit: fit ?? BoxFit.cover,
        height: height,
        width: width,
        errorWidget:
            (context, url, error) => Container(
              height: height,
              width: width,
              color: Colors.grey.shade200,
              child: Icon(Icons.broken_image, color: Colors.grey.shade400),
            ),
      ),
    );
  }
}
