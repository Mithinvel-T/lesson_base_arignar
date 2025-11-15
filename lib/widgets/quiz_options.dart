import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/responsive/responsive.dart';

class QuizOptions extends StatelessWidget {
  const QuizOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.selectedIndex,
    this.isAnswerCorrect,
    this.correctIndex,
  });

  final List<String> options;
  final ValueChanged<int> onOptionSelected;
  final int? selectedIndex;
  final bool? isAnswerCorrect;
  final int? correctIndex;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, responsive) {
        // Get screen dimensions for flexible sizing
        final screenWidth = MediaQuery.of(context).size.width;

        // Reduced spacing for more compact look
        final spacing = screenWidth < 600 ? 8.0 : 12.0; // Reduced from 12/16
        final borderRadius = screenWidth < 600
            ? 10.0
            : 12.0; // Reduced from 12/16
        final verticalPadding = screenWidth < 600
            ? 6.0
            : 8.0; // Reduced from 8/12

        // OPTIONS FONT SIZE - MUCH SMALLER than question
        final questionLength =
            80; // Average question length for consistent sizing
        double baseMaxFont;

        // Much smaller font sizes than question (question: 16-24, options: 12-18)
        if (questionLength > 160) {
          baseMaxFont = 12; // Much smaller than question (16)
        } else if (questionLength > 110) {
          baseMaxFont = 14; // Much smaller than question (18)
        } else if (questionLength > 80) {
          baseMaxFont = 15; // Much smaller than question (20)
        } else if (questionLength > 40) {
          baseMaxFont = 16; // Much smaller than question (22)
        } else {
          baseMaxFont = 17; // Much smaller than question (24)
        }

        // Apply same responsive scaling as question
        final isVeryCompact = screenWidth < 600;
        final isCompact = screenWidth < 900;

        final maxFont =
            baseMaxFont * (isVeryCompact ? 0.9 : (isCompact ? 0.95 : 1.1));
        final fontSize = maxFont.clamp(
          12.0,
          18.0,
        ); // Much smaller range (12-18) vs question (16-24)

        // Calculate dynamic height based on ALL options text content
        double maxRequiredHeight = 0;

        // Check each option to find the maximum height needed
        for (String option in options) {
          final textLength = option.length;
          final wordCount = option.split(' ').length;

          // Estimate lines needed for this option
          double estimatedLines = 1.0;
          if (textLength > 40 || wordCount > 6) {
            estimatedLines = 2.0; // Likely 2 lines
          }
          if (textLength > 80 || wordCount > 12) {
            estimatedLines = 3.0; // Likely 3 lines
          }

          // Calculate height needed for this option
          final heightForOption =
              (fontSize * estimatedLines * 1.2) +
              (verticalPadding * 2 * 0.8) +
              10;

          // Keep track of maximum height needed
          if (heightForOption > maxRequiredHeight) {
            maxRequiredHeight = heightForOption;
          }
        }

        // Use the maximum height for ALL containers (uniform height)
        final containerHeight = maxRequiredHeight.clamp(50.0, 120.0);

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            alignment: WrapAlignment.center,
            children: List.generate(options.length, (index) {
              // All containers have SAME SIZE - uniform width for all options
              final containerWidth =
                  screenWidth * 0.42; // Fixed 42% width for all containers

              // No text-based sizing - all containers are equal size

              final isSelected = selectedIndex == index;

              // Determine feedback colors based on answer correctness
              Color backgroundColor;
              Color borderColor;
              Color textColor;
              Color shadowColor;

              if (isSelected && isAnswerCorrect != null) {
                // Answer has been provided - show feedback colors
                if (isAnswerCorrect!) {
                  // Correct answer - luxury green
                  backgroundColor = const Color(0xFF4CAF50).withOpacity(0.1);
                  borderColor = const Color(0xFF43A047);
                  textColor = const Color(0xFF43A047);
                  shadowColor = const Color(0xFF4CAF50).withOpacity(0.2);
                } else {
                  // Wrong answer - premium red
                  backgroundColor = const Color(0xFFE53935).withOpacity(0.1);
                  borderColor = const Color(0xFFD32F2F);
                  textColor = const Color(0xFFD32F2F);
                  shadowColor = const Color(0xFFE53935).withOpacity(0.2);
                }
              } else if (isSelected) {
                // Selected but no feedback yet - default orange
                backgroundColor = const Color(0xFFFFF3E0);
                borderColor = const Color(0xFFFF8F00);
                textColor = const Color(0xFFFF8F00);
                shadowColor = const Color(0xFFFF8F00).withOpacity(0.15);
              } else {
                // Not selected - default white
                backgroundColor = const Color(0xFFFFFFFF);
                borderColor = Colors.grey.withOpacity(0.3);
                textColor = AppColors.darkText;
                shadowColor = Colors.black.withOpacity(0.06);
              }

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onOptionSelected(index),
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width:
                        containerWidth, // Dynamic width based on text content
                    height:
                        containerHeight, // Uniform height for all containers
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(
                        color: borderColor,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: screenWidth < 600
                              ? 8.0
                              : 12.0, // Enhanced shadow
                          offset: const Offset(0, 3),
                          spreadRadius: isSelected
                              ? 1
                              : 0, // Spread for selected state
                        ),
                        // Additional subtle inner shadow for luxury effect
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 1.0,
                          offset: const Offset(0, 1),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0, // 10px spacing on left and right sides
                      vertical:
                          verticalPadding * 0.8, // Slightly reduce vertical too
                    ),
                    child: Center(
                      // Centered as requested
                      child: Text(
                        options[index],
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          fontWeight:
                              FontWeight.w600, // SAME as question (w600)
                          color: textColor,
                          height: 1.2, // Tighter for better fit
                          fontSize: fontSize,
                          letterSpacing:
                              0.2, // Slight letter spacing for Tamil readability
                        ),
                        textAlign: TextAlign
                            .left, // Left-aligned for natural multi-line reading
                        maxLines:
                            3, // Allow up to 3 lines for better text accommodation
                        overflow:
                            TextOverflow.ellipsis, // Graceful overflow handling
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
