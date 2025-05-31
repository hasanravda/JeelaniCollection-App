import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildProductShimmer(double screenWidth) {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: calculateCrossAxisCount(screenWidth),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 9 / 16,
    ),
    itemCount: 6, // Placeholder count for shimmer
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image shimmer
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            // Title shimmer
            Container(
              height: 16,
              width: screenWidth * 0.4,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            // Description shimmer
            Container(
              height: 14,
              width: screenWidth * 0.3,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            // Price shimmer
            Container(
              height: 14,
              width: screenWidth * 0.2,
              color: Colors.white,
            ),
          ],
        ),
      );
    },
  );
}

int calculateCrossAxisCount(double screenWidth) {
  if (screenWidth <= 600) {
    return 2; // Mobile screens
  } else if (screenWidth <= 1200) {
    return 3; // Tablet screens
  } else {
    return 4; // Desktop screens
  }
}
