import 'package:flutter/material.dart';

class ZoomableImageScreen extends StatelessWidget {
  final String imageUrl;
  const ZoomableImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              
              panEnabled: true,
              // constrained: false, // Disable constraints
              minScale: 0.1, // Minimum zoom scale
              maxScale: 4.0, // Maximum zoom scale
              child: Image.network(imageUrl), // Fit image to screen

            ),
          ),
          Positioned(
            top: 30, // Adjust top positioning
            left: 10, // Adjust left positioning
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25), // Back icon
              onPressed: () {
                Navigator.pop(context); // Navigate back to previous screen
              },
            ),
          ),
        ],
      ),
    );
  }
}