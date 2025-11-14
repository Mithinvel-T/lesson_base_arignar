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

    // Device-specific container width calculations (luxury requirement)
    double containerWidth;
    if (isMobile) {
      containerWidth = screenWidth * 0.90; // Mobile: 90% of screen
    } else if (isTablet) {
      containerWidth = screenWidth * 0.70; // Tablet: 70% of screen
    } else {
      containerWidth = screenWidth * 0.60; // Laptop/Desktop: 60% of screen
    }

    // Grid configuration
    final crossAxisCount = isMobile ? 1 : 2;

    // Fixed height for ALL option containers - luxury equal height requirement
    final fixedHeight = isMobile ? 85.0 : 95.0;

    // Premium luxury styling constants
    const borderRadius = 23.0; // Premium rounded corners (22-24px)
    const horizontalPadding = 18.0; // Equal padding (16-20px)
    const verticalPadding = 18.0;
    final spacing = isMobile ? 16.0 : 20.0; // Equal spacing between containers

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
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(
                                0xFFFF8F00,
                              ) // Orange text for selected
                            : AppColors.darkText,
                        height:
                            1.4, // Premium line height for luxury readability
                        fontSize: isMobile ? 15 : 16,
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
