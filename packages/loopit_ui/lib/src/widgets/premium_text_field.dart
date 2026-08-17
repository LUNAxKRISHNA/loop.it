import 'package:flutter/material.dart';
import '../theme.dart';

class PremiumTextField extends StatefulWidget {
  final String title;
  final String? hintText;
  final IconData prefixIcon;
  final bool isPassword;

  const PremiumTextField({
    super.key,
    required this.title,
    this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LoopitColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LoopitColors.grey100, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: LoopitColors.grey50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(widget.prefixIcon, color: LoopitColors.black, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: LoopitColors.grey500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextField(
                  obscureText: widget.isPassword ? _obscureText : false,
                  style: const TextStyle(
                    fontSize: 16,
                    color: LoopitColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(color: LoopitColors.grey300),
                  ),
                ),
              ],
            ),
          ),
          if (widget.isPassword)
            IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: LoopitColors.grey500,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
        ],
      ),
    );
  }
}
