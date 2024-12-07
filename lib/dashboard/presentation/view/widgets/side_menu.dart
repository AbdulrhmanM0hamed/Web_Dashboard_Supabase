import 'package:flutter/material.dart';
import 'package:supabase_dashboard/core/constants/colors.dart';
import 'package:supabase_dashboard/core/constants/font_manger.dart';
import 'package:supabase_dashboard/core/constants/styles_manger.dart';
import 'package:supabase_dashboard/dashboard/presentation/view/widgets/menu_item_widget.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: TColors.primary,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                const Icon(
                  Icons.dashboard_rounded,
                  size: 40,
                  color: TColors.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'لوحة التحكم',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                MenuItemWidget(
                  index: 0,
                  title: 'نظرة عامة',
                  icon: Icons.dashboard_outlined,
                  isSelected: selectedIndex == 0,
                  onItemSelected: onItemSelected,
                ),
                MenuItemWidget(
                  index: 1,
                  title: 'المنتجات',
                  icon: Icons.shopping_bag_outlined,
                  isSelected: selectedIndex == 1,
                  onItemSelected: onItemSelected,
                ),
                MenuItemWidget(
                  index: 2,
                  title: 'التصنيفات',
                  icon: Icons.category_outlined,
                  isSelected: selectedIndex == 2,
                  onItemSelected: onItemSelected,
                ),
                MenuItemWidget(
                  index: 3,
                  title: 'المستخدمين',
                  icon: Icons.people_outline,
                  isSelected: selectedIndex == 3,
                  onItemSelected: onItemSelected,
                ),
                MenuItemWidget(
                  index: 4,
                  title: 'الطلبات',
                  icon: Icons.shopping_cart_outlined,
                  isSelected: selectedIndex == 4,
                  onItemSelected: onItemSelected,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
              color: Colors.white70,
            ),
            title: Text(
              'الإعدادات',
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: Colors.white70,
              ),
            ),
            onTap: () {
              // Handle settings
            },
          ),
        ],
      ),
    );
  }
}
