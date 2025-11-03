import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Production-level cache configuration for images
/// This helps manage memory and disk cache for optimal performance
class ImageCacheConfig {
  /// Clear all cached images (useful for logout or settings)
  static Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
  }
}
