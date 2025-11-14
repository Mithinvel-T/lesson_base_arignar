import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';

class QuizOptions extends StatelessWidget {
  const QuizOptions({
    super.key,
    required this.options,
    required this.onOptionSelected,
    this.selectedIndex,
  });

  final List<String> options;
  final ValueChanged<int> onOptionSelected;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    // Device-based responsive calculations for luxury layout
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth < 1024;

    // Device-specific container width calculations (compact for embedded view)
    double containerWidth;
    if (isMobile) {
      containerWidth = screenWidth * 0.85; // Mobile: 85% (reduced from 90%)
    } else if (isTablet) {
      containerWidth = screenWidth * 0.65; // Tablet: 65% (reduced from 70%)
    } else {
      containerWidth = screenWidth * 0.55; // Desktop: 55% (reduced from 60%)
    }

    // Grid configuration
    final crossAxisCount = isMobile ? 1 : 2;

    // Reduced fixed height for embedded view
    final fixedHeight = isMobile ? 70.0 : 80.0; // Reduced by ~15px

    // Compact styling constants for embedded view
    const borderRadius = 20.0; // Slightly reduced corners
    const horizontalPadding = 14.0; // Reduced padding
    const verticalPadding = 12.0; // Reduced vertical padding
    final spacing = isMobile ? 12.0 : 16.0; // Reduced spacing

    return Center(
      child: SizedBox(
        width: containerWidth,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: fixedHeight, // Fixed height for equal containers
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onOptionSelected(index),
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  height: fixedHeight, // Fixed height prevents stretching
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFF3E0) // Light orange for selected
                        : const Color(0xFFFFFFFF), // Pure white background
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: isSelected
                          ? const Color(
                              0xFFFF8F00,
                            ) // Orange border for selected
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? const Color(0xFFFF8F00).withOpacity(0.15)
                            : Colors.black.withOpacity(
                                0.10,
                              ), // Luxury shadow rgba(0,0,0,0.10)
                        blurRadius: 20, // Premium blur (18-22px)
                        offset: const Offset(0, 4), // Luxury offset (0, 4)
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  // Slightly center-aligned vertically, naturally balanced
                  child: Align(
                    alignment: Alignment
                        .centerLeft, // Slightly center vertically, left horizontally
                    child: Text(
                      options[index],
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        // Enhanced font weight for desktop visibility
                        fontWeight: isMobile
                            ? FontWeight.w500
                            : FontWeight.w600,
                        color: isSelected
                            ? const Color(
                                0xFFFF8F00,
                              ) // Orange text for selected
                            : AppColors.darkText,
                        height:
                            1.4, // Premium line height for luxury readability
                        // Enhanced font sizing for desktop prominence
                        fontSize: isMobile ? 15 : (isTablet ? 16 : 17),
                      ),
                      // LEFT aligned text (each new line starts from left)
                      textAlign: TextAlign.left,
                      // Natural text wrapping within fixed height
                      maxLines: null,
                      overflow: TextOverflow.visible, // No overflow issues
                      softWrap: true, // Enable natural wrapping
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
