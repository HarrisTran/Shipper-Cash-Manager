import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ScmCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool useLargeRadius;

  const ScmCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.useLargeRadius = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(useLargeRadius ? 16 : 8),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
