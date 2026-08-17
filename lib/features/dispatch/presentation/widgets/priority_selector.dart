import 'package:flutter/material.dart';
import 'package:loopit_ui/loopit_ui.dart';

class PrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String> onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final priorities = ['Low', 'Medium', 'High'];
    final selectedIndex = priorities.indexOf(selectedPriority);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: LoopitColors.grey50,
        borderRadius: BorderRadius.circular(30), // Pill background
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          // Sliding Black Pill Background
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic, // Smoother animation
            alignment: selectedIndex == 0
                ? Alignment.centerLeft
                : selectedIndex == 1
                    ? Alignment.center
                    : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: LoopitColors.black, // Black pill
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: LoopitColors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Foreground Labels
          Row(
            children: priorities.map((label) {
              final isSelected = selectedPriority == label;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onPriorityChanged(label),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? LoopitColors.white : LoopitColors.grey500,
                    ),
                    child: Center(
                      child: Text(label),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
