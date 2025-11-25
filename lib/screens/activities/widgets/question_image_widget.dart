import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class QuestionImageWidget extends StatelessWidget {
  final String imageUrl;
  final double screenWidth;
  final bool isMobile;

  const QuestionImageWidget({
    super.key,
    required this.imageUrl,
    required this.screenWidth,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobile ? 120.0 : 150.0,
      height: isMobile ? 120.0 : 150.0,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.headerOrange, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.softShadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.primaryBlue,
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.image_not_supported,
                size: 30,
                color: AppColors.subtleText,
              ),
            );
          },
        ),
      ),
    );
  }
}
