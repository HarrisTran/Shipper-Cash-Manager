import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ScmStatus { completed, pending, error }

class ScmStatusTag extends StatelessWidget {
  final String label;
  final ScmStatus status;

  const ScmStatusTag({super.key, required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData icon;

    switch (status) {
      case ScmStatus.completed:
        bgColor = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case ScmStatus.pending:
        bgColor = AppColors.warning;
        icon = Icons.access_time;
        break;
      case ScmStatus.error:
        bgColor = AppColors.error;
        icon = Icons.error_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
