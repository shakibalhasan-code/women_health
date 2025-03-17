// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:heroicons/heroicons.dart';
// import 'package:women_health/controller/community_controller.dart';
//
// class AllMatchedScreen extends StatelessWidget {
//   AllMatchedScreen({super.key});
//
//   final communityController = Get.put(CommunityController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: Padding(
//           padding: EdgeInsets.only(left: 16.w),
//           child: const Icon(Icons.people, color: Colors.red),
//         ),
//         title: Text(
//           'All matched',
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: 16.w),
//             child: IconButton(
//                 onPressed: () => Get.back(),
//                 icon: Icon(Icons.close, color: Colors.black)),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('New',
//                 style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black)),
//             SizedBox(height: 10.h),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(10.w),
//               color: Colors.red.shade50,
//               child: Obx(() => Wrap(
//                     spacing: 15.w,
//                     runSpacing: 15.h,
//                     children: communityController.matchedUsers
//                         .map((user) => _buildUserItem(user))
//                         .toList(),
//                   )),
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('All',
//                     style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black)),
//                 Text('150 Peoples',
//                     style: TextStyle(
//                         fontSize: 14.sp, color: Colors.grey.shade600)),
//               ],
//             ),
//             SizedBox(height: 10.h),
//             Expanded(
//               child: Obx(
//                 () => ListView.separated(
//                   itemCount: communityController.allMatchedUsers.length,
//                   separatorBuilder: (context, index) => Divider(),
//                   itemBuilder: (context, index) {
//                     final user = communityController.allMatchedUsers[index];
//                     return _buildMatchedUserItem(user);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildUserItem(Map<String, String> user) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 25.r,
//           backgroundImage:
//               user['image'] != null ? NetworkImage(user['image']!) : null,
//           backgroundColor: user['image'] == null ? Colors.grey.shade300 : null,
//           child: user['image'] == null
//               ? Icon(Icons.person, color: Colors.black, size: 24.sp)
//               : null,
//         ),
//         SizedBox(height: 5.h),
//         Text(
//           user['name']!,
//           style: TextStyle(fontSize: 12.sp, color: Colors.black),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMatchedUserItem(Map<String, String> user) {
//     return ListTile(
//       leading: CircleAvatar(
//         radius: 20.r,
//         backgroundImage:
//             user['image'] != null ? NetworkImage(user['image']!) : null,
//         backgroundColor: user['image'] == null ? Colors.grey.shade300 : null,
//         child: user['image'] == null
//             ? Icon(Icons.person, color: Colors.black, size: 24.sp)
//             : null,
//       ),
//       title: Text(user['name']!,
//           style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
//       subtitle: Text('5 Days ago',
//           style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)),
//       trailing: OutlinedButton(
//         onPressed: () {},
//         child: Text('Remove',
//             style: TextStyle(fontSize: 14.sp, color: Colors.black)),
//       ),
//     );
//   }
// }
