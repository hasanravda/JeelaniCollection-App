import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Optimized image widget with caching, loading states, and error handling
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? placeholderColor;
  final bool useFadeIn;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.placeholderColor,
    this.useFadeIn = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: useFadeIn ? const Duration(milliseconds: 300) : Duration.zero,
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (context, url) => placeholder ?? _buildShimmerPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
      // Cache configuration for production
      // Only set memory cache dimensions if width/height are finite values
      memCacheWidth: width != null && width!.isFinite 
          ? (width! * MediaQuery.of(context).devicePixelRatio).round() 
          : null,
      memCacheHeight: height != null && height!.isFinite 
          ? (height! * MediaQuery.of(context).devicePixelRatio).round() 
          : null,
      maxWidthDiskCache: 2000, // Max width for disk cache
      maxHeightDiskCache: 2000, // Max height for disk cache
      // Use high quality but reasonable size
      filterQuality: FilterQuality.medium,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: placeholderColor ?? Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height ?? 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height ?? 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }
}

/// Optimized image for product tiles with consistent sizing
class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.height = 230,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OptimizedImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        borderRadius: borderRadius ?? BorderRadius.circular(5),
        placeholderColor: Colors.grey[300],
      ),
    );
  }
}

