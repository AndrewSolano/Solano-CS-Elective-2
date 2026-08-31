import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfluttersactivity/platform_helper.dart';

/// A button styled to match the assignment's reference mockup:
/// - Material: dark navy, rounded-rectangle, full width.
/// - iOS (Cupertino): system-blue, rounded-pill, full width.
class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  bool get _disabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              ],
            ],
          );

    if (PlatformHelper.isCupertino) {
      // iOS style: solid blue, fully rounded pill.
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _disabled ? CupertinoColors.systemGrey4 : const Color(0xFF0A84FF),
            borderRadius: BorderRadius.circular(22),
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(22),
            onPressed: onPressed,
            child: child,
          ),
        ),
      );
    }

    // Material style: dark navy, slightly rounded rectangle.
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _disabled ? const Color(0xFFCBD3DA) : const Color(0xFF2C3E50),
          disabledBackgroundColor: const Color(0xFFCBD3DA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: child,
      ),
    );
  }
}
