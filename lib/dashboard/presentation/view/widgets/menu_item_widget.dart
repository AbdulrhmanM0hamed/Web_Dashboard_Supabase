import 'package:flutter/material.dart';
import 'package:supabase_dashboard/core/constants/colors.dart';
import 'package:supabase_dashboard/core/constants/font_manger.dart';
import 'package:supabase_dashboard/core/constants/styles_manger.dart';

class MenuItemWidget extends StatelessWidget {
  final int index;
  final String title;
  final IconData icon;
  final bool isSelected;
  final Function(int) onItemSelected;

  const MenuItemWidget({
    super.key,
    required this.index,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onItemSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.07) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? TColors.black : const Color.fromARGB(183, 255, 255, 255),
                size: 26,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: getBoldStyle(
                  fontSize: 17,
                  fontFamily: FontConstant.cairo,
                  color: isSelected ? TColors.black : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
