import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      color: const Color.fromARGB(255, 27, 27, 27),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24 ,),
            child: Column(
              children: [
                 Image.asset(
                  'assets/logo.png',
                  height: 100,
                  width: 100,
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
                  title: 'العروض الخاصة',
                  icon: Icons.local_offer_outlined,
                  isSelected: selectedIndex == 2,
                  onItemSelected: onItemSelected,
                ),
                
                MenuItemWidget(
                  index: 3,
                  title: 'التصنيفات',
                  icon: Icons.category_outlined,
                  isSelected: selectedIndex == 3,
                  onItemSelected: onItemSelected,
                ),
                MenuItemWidget(
                  index: 4,
                  title: 'المستخدمين',
                  icon: Icons.people_outline,
                  isSelected: selectedIndex == 4,
                  onItemSelected: onItemSelected,
                ),
                MenuItemWidget(
                  index: 5,
                  title: 'الطلبات',
                  icon: Icons.shopping_cart_outlined,
                  isSelected: selectedIndex == 5,
                  onItemSelected: onItemSelected,
                ),
             
              ],
            ),
          ),
     
         
          
        ],
      ),
    );
  }
}
