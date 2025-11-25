import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/density/scalable_text.dart';

class LetterClassificationCard extends StatelessWidget {
  final String letter;
  final int letterIndex;
  final bool isMobile;
  final String? selectedCategory;
  final bool showResult;
  final Function(String) onCategorySelected;

  const LetterClassificationCard({
    super.key,
    required this.letter,
    required this.letterIndex,
    required this.isMobile,
    required this.selectedCategory,
    required this.showResult,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppColors.lightYellowBackground.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.headerOrange.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.headerOrange,
                  AppColors.headerOrange.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.headerOrange, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.headerOrange.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildCategoryButton(
                    'uyir',
                    '',
                    AppColors.success,
                    context,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCategoryButton(
                    'mei',
                    'மெய்',
                    AppColors.headerOrange,
                    context,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCategoryButton(
                    'uyirmei',
                    'உயிர்மெய்',
                    AppColors.primaryBlue,
                    context,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
    String category,
    String label,
    Color color,
    BuildContext context,
  ) {
    final isSelected = selectedCategory == category;

    return InkWell(
      onTap: showResult ? null : () => onCategorySelected(category),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2.5 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: ScalableText(
          label,
          style: AppTextStyles.bodyMedium(context).copyWith(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.subtleText,
          ),
        ),
      ),
    );
  }
}
