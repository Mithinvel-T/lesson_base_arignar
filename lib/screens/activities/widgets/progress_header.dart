import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/density/scalable_text.dart';

class ProgressHeader extends StatelessWidget {
  final double progress;
  final bool isMobile;
  final double screenWidth;
  final int currentQuestion;
  final int totalQuestions;

  const ProgressHeader({
    super.key,
    required this.progress,
    required this.isMobile,
    required this.screenWidth,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.015,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8EF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          ScalableText(
            '$currentQuestion/$totalQuestions',
            style: AppTextStyles.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppColors.progressTrackGrey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.headerOrange,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ScalableText(
            '${(progress * 100).toInt()}%',
            style: AppTextStyles.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
