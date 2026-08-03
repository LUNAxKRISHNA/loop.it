import 'package:flutter/material.dart';
import '../theme.dart';

class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;
  final IconData? prefixIcon;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isSecondary ? LoopitColors.white : LoopitColors.black,
          borderRadius: BorderRadius.circular(32),
          border: isSecondary ? Border.all(color: LoopitColors.grey100, width: 1.5) : null,
        ),
        child: Row(
          mainAxisAlignment: prefixIcon != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: LoopitColors.grey50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(prefixIcon, color: LoopitColors.black, size: 20),
              ),
            if (prefixIcon != null) const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                textAlign: prefixIcon != null ? TextAlign.left : TextAlign.center,
                style: TextStyle(
                  color: isSecondary ? LoopitColors.black : LoopitColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: isSecondary ? LoopitColors.black : LoopitColors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
