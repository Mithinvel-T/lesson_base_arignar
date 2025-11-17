import 'package:flutter/material.dart';

class QuizImage extends StatelessWidget {
  const QuizImage({
    super.key,
    required this.imageUrl,
    this.aspectRatio =
        2.2 / 1, // CHANGED from 16/9 to 2.2/1 for more compact height
  });

  final String? imageUrl;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    // Responsive calculations for zoom support
    final isVeryCompact = screenWidth < 400;
    final isCompact = screenWidth < 600;

    // COMPACT sizing - Much smaller images for better layout balance
    final containerWidth =
        screenWidth *
        (isVeryCompact
            ? 0.65 // REDUCED from 0.85 to 0.65
            : (isCompact ? 0.60 : 0.55)); // REDUCED from 0.80/0.75 to 0.60/0.55
    final maxContainerWidth = isCompact
        ? 240.0
        : 300.0; // REDUCED from 320/400 to 240/300
    final finalWidth = containerWidth.clamp(
      200.0, // REDUCED minimum from 280 to 200
      maxContainerWidth,
    );

    // Smaller border radius and shadow for compact look
    final borderRadius = (screenWidth * 0.03).clamp(
      12.0,
      18.0,
    ); // REDUCED from 0.05 and 22-28 to 0.03 and 12-18
    final shadowBlurRadius = (screenWidth * 0.015).clamp(
      4.0,
      8.0,
    ); // REDUCED from 0.02 and 8-14 to 0.015 and 4-8

    return Center(
      child: Container(
        width: finalWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: shadowBlurRadius,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFF5F5F5),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFF8F00),
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF5F5F5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_rounded,
                              size: finalWidth * 0.15,
                              color: const Color(0xFFBDBDBD),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Unable to load image',
                              style: TextStyle(
                                fontSize: finalWidth * 0.035,
                                color: const Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_rounded,
                          size: finalWidth * 0.15,
                          color: const Color(0xFFBDBDBD),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No image available',
                          style: TextStyle(
                            fontSize: finalWidth * 0.035,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
