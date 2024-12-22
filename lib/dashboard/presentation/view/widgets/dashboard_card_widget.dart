import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.icon, required this.title, required this.value, required this.color});

   final IconData icon;
    final String title;
    final String value;
    final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive sizes
        double iconSize = constraints.maxWidth * 0.2;  // 20% of card width
        double titleFontSize = constraints.maxWidth * 0.09;  // 9% of card width
        double valueFontSize = constraints.maxWidth * 0.12;  // 12% of card width
        
        // Set minimum and maximum sizes
        iconSize = iconSize.clamp(30.0, 50.0);
        titleFontSize = titleFontSize.clamp(14.0, 20.0);
        valueFontSize = valueFontSize.clamp(18.0, 28.0);

        return Card(
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(constraints.maxWidth * 0.08),  // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: iconSize, color: color),
                SizedBox(height: constraints.maxHeight * 0.08),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: constraints.maxHeight * 0.06),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }




}