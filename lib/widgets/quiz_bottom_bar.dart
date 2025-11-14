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

    // Fixed button size across all devices for consistency
    const buttonSize = 56.0;

    // Responsive horizontal padding for balanced layout
    final horizontalPadding = screenWidth < 600
        ? 20.0 // Mobile: tight padding
        : screenWidth < 1024
        ? 32.0 // Tablet: medium padding
        : 48.0; // Desktop: generous padding

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 16.0,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8E1), // Soft cream background
        boxShadow: [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 12,
            offset: Offset(0, -3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Home button
            _buildNavigationButton(
              icon: Icons.home_rounded,
              onPressed: onHomePressed,
              buttonSize: buttonSize,
              isEnabled: true,
              buttonType: 'home',
            ),

            // Back button
            _buildNavigationButton(
              icon: Icons.arrow_back_rounded,
              onPressed: canGoBack ? onBackPressed : null,
              buttonSize: buttonSize,
              isEnabled: canGoBack,
              buttonType: 'back',
            ),

            // Next button
            _buildNavigationButton(
              icon: Icons.arrow_forward_rounded,
              onPressed: canGoNext ? onNextPressed : null,
              buttonSize: buttonSize,
              isEnabled: canGoNext,
              buttonType: 'next',
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
    String buttonType = 'default',
  }) {
    // Determine button color based on type and state
    Color buttonColor;
    Color shadowColor;

    if (!isEnabled) {
      buttonColor = const Color(0xFFE0E0E0); // Disabled grey
      shadowColor = Colors.black.withOpacity(0.1);
    } else if (buttonType == 'back') {
      buttonColor = const Color(0xFFE0E0E0); // Soft grey for back
      shadowColor = Colors.black.withOpacity(0.15);
    } else {
      buttonColor = const Color(0xFFFFA726); // Warm orange for home/next
      shadowColor = const Color(0xFFFFA726).withOpacity(0.25);
    }

    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(22.0), // Fixed 22px corners
      elevation: isEnabled ? 6 : 2,
      shadowColor: shadowColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(22.0),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isEnabled
                ? (buttonType == 'back'
                      ? const Color(0xFF555555)
                      : Colors.white)
                : const Color(0xFF9E9E9E),
            size: buttonSize * 0.4,
          ),
        ),
      ),
    );
  }
}
