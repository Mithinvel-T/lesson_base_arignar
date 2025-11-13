import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/app_button.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

class AdaptiveLessonLayout extends StatelessWidget {
  const AdaptiveLessonLayout({
    super.key,
    required this.questionCard,
    required this.mainContent,
    required this.progressContent,
    required this.lessonTitle,
    this.onExitPressed,
    this.onPrevPressed,
    this.onNextPressed,
    this.onJumpToQuestion,
  });

  final Widget questionCard;
  final Widget mainContent;
  final Widget progressContent;
  final String lessonTitle;
  final VoidCallback? onExitPressed;
  final VoidCallback? onPrevPressed;
  final VoidCallback? onNextPressed;
  final VoidCallback? onJumpToQuestion;

  @override
  Widget build(BuildContext context) {
    // Always use mobile-first single column layout
    return _buildMobileLayout(context);
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ScalableText(
                  lessonTitle,
                  style: AppTextStyles.headlineMedium(context).copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxFontSize: 20,
                  minFontSize: 16,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              AppButton(
                label: 'Exit',
                onPressed: onExitPressed,
                expanded: false,
                height: 36,
              ),
            ],
          ),
          const SizedBox(height: 8),
          progressContent,
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;
        final isCompact = screenWidth < 420;

        return Column(
          children: [
            // Header with title and progress bar
            _buildHeader(context),

            // Main content area
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: isCompact ? 16 : 20,
                  right: isCompact ? 16 : 20,
                  top: 8,
                  bottom: 8,
                ),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    questionCard,
                    const SizedBox(height: 8),
                    // Show mainContent if it exists
                    if (!(mainContent is SizedBox &&
                        (mainContent as SizedBox).width == 0.0 &&
                        (mainContent as SizedBox).height == 0.0)) ...[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isCompact ? 12 : 16),
                          child: mainContent,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    // Add spacing for bottom navigation
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),

            // Bottom navigation with icon buttons
            _buildBottomNavigation(context),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightYellowBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(
            icon: Icons.home,
            onPressed: onExitPressed,
          ),
          _buildIconButton(
            icon: Icons.arrow_back,
            onPressed: onPrevPressed,
          ),
          _buildIconButton(
            icon: Icons.arrow_forward,
            onPressed: onNextPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: AppColors.headerOrange,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: AppColors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
