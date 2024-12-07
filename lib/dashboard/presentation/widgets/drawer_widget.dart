// import 'package:flutter/material.dart';
// import 'package:supabase_dashboard/dashboard/presentation/view/categories/categories_view.dart';
// import 'package:supabase_dashboard/dashboard/presentation/view/products/products_view.dart';


// class DrawerWidget extends StatelessWidget {
//   const DrawerWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//             ),
//             child: const Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.shopping_cart,
//                     size: 40,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'هايبر ماركت',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.category),
//             title: const Text('الفئات'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CategoriesView(),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.shopping_bag),
//             title: const Text('المنتجات'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const ProductsView(),
//                 ),
//               );
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('الإعدادات'),
//             onTap: () {
//               // TODO: Navigate to settings
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('تسجيل الخروج'),
//             onTap: () {
//               // TODO: Implement logout
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
