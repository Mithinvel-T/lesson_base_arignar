import 'package:flutter/material.dart';

class QuizBottomBar extends StatelessWidget {
  const QuizBottomBar({
    super.key,
    required this.onHomePressed,
    required this.onBackPressed,
    required this.onNextPressed,
    this.canGoBack = true,
    this.canGoNext = true,
  });

  final VoidCallback onHomePressed;
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;
  final bool canGoBack;
  final bool canGoNext;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;

    // Dynamic sizing based on viewport
    final buttonSize = (screenWidth * 0.12).clamp(48.0, 64.0);
    final horizontalPadding = (screenWidth * 0.06).clamp(24.0, 48.0);
    final verticalPadding = (screenWidth * 0.025).clamp(12.0, 20.0);
    final buttonSpacing = (screenWidth * 0.08).clamp(32.0, 80.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8E1), // Soft cream background
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Home button
            _buildNavigationButton(
              icon: Icons.home_rounded,
              onPressed: onHomePressed,
              buttonSize: buttonSize,
              isEnabled: true,
            ),

            SizedBox(width: buttonSpacing),

            // Back button
            _buildNavigationButton(
              icon: Icons.arrow_back_rounded,
              onPressed: canGoBack ? onBackPressed : null,
              buttonSize: buttonSize,
              isEnabled: canGoBack,
            ),

            SizedBox(width: buttonSpacing),

            // Next button
            _buildNavigationButton(
              icon: Icons.arrow_forward_rounded,
              onPressed: canGoNext ? onNextPressed : null,
              buttonSize: buttonSize,
              isEnabled: canGoNext,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required double buttonSize,
    required bool isEnabled,
  }) {
    return Material(
      color: isEnabled
          ? const Color(0xFFFFA726) // Warm orange
          : const Color(0xFFE0E0E0), // Disabled grey
      borderRadius: BorderRadius.circular(buttonSize * 0.25),
      elevation: isEnabled ? 4 : 1,
      shadowColor: isEnabled
          ? const Color(0xFFFFA726).withOpacity(0.3)
          : Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(buttonSize * 0.25),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isEnabled ? Colors.white : const Color(0xFF9E9E9E),
            size: buttonSize * 0.45,
          ),
        ),
      ),
    );
  }
}
