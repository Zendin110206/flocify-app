// // lib/features/presets/presentation/widgets/professional_refresh_indicator.dart

// import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
// import 'package:flutter/material.dart';
// import '../screens/preset_list_screen.dart'; // Untuk AppColors

// class ProfessionalRefreshIndicator extends StatelessWidget {
//   final Widget child;
//   final Future<void> Function() onRefresh;

//   const ProfessionalRefreshIndicator({
//     super.key,
//     required this.child,
//     required this.onRefresh,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomRefreshIndicator(
//       onRefresh: onRefresh,
//       offsetToArmed: 100, // Seberapa jauh harus ditarik untuk memicu refresh
//       builder: (context, child, controller) {
//         return Stack(
//           clipBehavior: Clip.none,
//           children: [
//             // Latar belakang yang berubah warna saat ditarik
//             AnimatedBuilder(
//               animation: controller,
//               builder: (context, _) {
//                 // Gradien dari biru AppBar ke warna latar
//                 final color = Color.lerp(
//                   AppColors.background,
//                   AppColors.appBarSurface,
//                   controller.value.clamp(0.0, 1.0),
//                 )!;
//                 return Container(color: color, height: controller.value * 100);
//               },
//             ),
//             // Konten utama (daftar preset)
//             AnimatedBuilder(
//               animation: controller,
//               builder: (context, _) {
//                 return Transform.translate(
//                   offset: Offset(0, controller.value * 100),
//                   child: child,
//                 );
//               },
//             ),
//             // Indikator loading kustom
//             Positioned(
//               top: 20,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: AnimatedBuilder(
//                   animation: controller,
//                   builder: (context, _) {
//                     return Opacity(
//                       opacity: controller.isLoading
//                           ? 1.0
//                           : controller.value.clamp(0.0, 1.0),
//                       child: Transform.scale(
//                         scale: controller.isLoading
//                             ? 1.0
//                             : controller.value.clamp(0.0, 1.0),
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 10,
//                               ),
//                             ],
//                           ),
//                           child: controller.isLoading
//                               ? Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2.5,
//                                     color: AppColors.primary,
//                                   ),
//                                 )
//                               : Icon(
//                                   Icons.arrow_downward,
//                                   color: AppColors.primary,
//                                   size: 20,
//                                 ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//       child: child,
//     );
//   }
// }
