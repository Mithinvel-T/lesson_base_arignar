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

    // Compact button size for embedded view
    final buttonSize = screenWidth < 600
        ? 36.0 // Mobile: ultra compact
        : screenWidth < 1024
        ? 42.0 // Tablet: compact
        : 48.0; // Desktop: moderate

    // Reduced horizontal padding for embedded view
    final horizontalPadding = screenWidth < 600
        ? 16.0 // Mobile: tight padding
        : screenWidth < 1024
        ? 24.0 // Tablet: reduced padding
        : 32.0; // Desktop: moderate padding

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 8.0, // Reduced from 16.0 for embedded view
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
    // Enhanced button color scheme - NO grey for back button
    Color buttonColor;
    Color shadowColor;

    if (!isEnabled) {
      buttonColor = const Color(
        0xFFE0E0E0,
      ); // Disabled grey only when truly disabled
      shadowColor = Colors.black.withOpacity(0.1);
    } else if (buttonType == 'back') {
      buttonColor = const Color(
        0xFFFFB74D,
      ); // Soft muted orange for back (NOT grey)
      shadowColor = const Color(0xFFFFB74D).withOpacity(0.2);
    } else {
      buttonColor = const Color(0xFFFFA726); // Bright orange for home/next
      shadowColor = const Color(0xFFFFA726).withOpacity(0.25);
    }

    // Fixed shape consistency: border radius proportional to button size
    // This maintains the same visual shape ratio across all device sizes
    final borderRadius =
        buttonSize * 0.42; // Consistent 42% ratio for stable shape

    return Material(
      color: buttonColor,
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: isEnabled ? 4 : 1, // Reduced elevation for embedded view
      shadowColor: shadowColor,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: buttonSize,
          height: buttonSize,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isEnabled
                ? Colors
                      .white // All active buttons get white icons (including back)
                : const Color(0xFF9E9E9E),
            size:
                buttonSize *
                0.48, // Slightly increased for better visibility in compact size
          ),
        ),
      ),
    );
  }
}
