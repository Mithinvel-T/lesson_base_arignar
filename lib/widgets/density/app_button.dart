import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.trailing,
    this.expanded = true,
    this.height,
    this.padding,
    this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final bool expanded;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final resolvedPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 10);
    final resolvedHeight = height ?? 36;
    final resolvedRadius = borderRadius ?? 8;

    final button = FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.headerOrange,
        foregroundColor: AppColors.white,
        minimumSize: Size(expanded ? double.infinity : 0, resolvedHeight),
        padding: resolvedPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(resolvedRadius),
        ),
        elevation: 1,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          ScalableText(
            label,
            autoScale: true,
            minFontSize: 12,
            maxFontSize: 15,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );

    if (!expanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
