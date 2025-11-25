import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/density/scalable_text.dart';

class NavigationButtons extends StatelessWidget {
  final bool isMobile;
  final double screenWidth;
  final bool canGoPrevious;
  final bool areAllAnswersSelected;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const NavigationButtons({
    super.key,
    required this.isMobile,
    required this.screenWidth,
    required this.canGoPrevious,
    required this.areAllAnswersSelected,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: canGoPrevious ? onPrevious : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primaryBlue,
                disabledBackgroundColor: AppColors.white.withOpacity(0.5),
                disabledForegroundColor: AppColors.primaryBlue.withOpacity(0.5),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: canGoPrevious
                        ? AppColors.primaryBlue
                        : AppColors.primaryBlue.withOpacity(0.5),
                  ),
                ),
                elevation: 0,
              ),
              child: ScalableText(
                'Previous',
                style: AppTextStyles.buttonText(context).copyWith(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: ElevatedButton(
              onPressed: areAllAnswersSelected ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.5),
                padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: ScalableText(
                'Next',
                style: AppTextStyles.buttonText(context).copyWith(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
