// // lib/features/presets/presentation/screens/preset_list_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dart:async';
// import 'package:uuid/uuid.dart';

// // =========================================================================
// // --- THEME & CONSTANTS ---
// // =========================================================================

// class AppColors {
//   static const primary = Color(0xFF2563EB);
//   static const primaryLight = Color(0xFFEFF6FF);
//   static const success = Color(0xFF16A34A);
//   static const successLight = Color(0xFFF0FDF4);
//   static const warning = Color(0xFFEAB308);
//   static const warningLight = Color(0xFFFEFCE8);
//   static const danger = Color(0xFFDC2626);
//   static const background = Color(0xFFFAFAFA);
//   static const surface = Colors.white;
//   static const textPrimary = Color(0xFF111827);
//   static const textSecondary = Color(0xFF6B7280);
//   static const textTertiary = Color(0xFF9CA3AF);
//   static const border = Color(0xFFE5E7EB);
//   static const shadow = Color(0x0A000000);
// }

// class AppSpacing {
//   static const xs = 4.0;
//   static const sm = 8.0;
//   static const md = 16.0;
//   static const lg = 24.0;
//   static const xl = 32.0;
//   static const xxl = 48.0;
// }

// class AppRadius {
//   static const sm = 8.0;
//   static const md = 12.0;
//   static const lg = 16.0;
//   static const xl = 20.0;
// }

// // =========================================================================
// // --- MODELS (Unchanged) ---
// // =========================================================================

// enum PresetCreator { flocify, user }

// class PresetParameter {
//   final String id;
//   final String name;
//   final double min;
//   final double max;
//   final String unit;

//   PresetParameter({
//     required this.id,
//     required this.name,
//     required this.min,
//     required this.max,
//     required this.unit,
//   });

//   PresetParameter copyWith({
//     String? id,
//     String? name,
//     double? min,
//     double? max,
//     String? unit,
//   }) {
//     return PresetParameter(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       min: min ?? this.min,
//       max: max ?? this.max,
//       unit: unit ?? this.unit,
//     );
//   }
// }

// class Preset {
//   final String id;
//   final String name;
//   final String commodity;
//   final PresetCreator creator;
//   final String? description;
//   final List<PresetParameter> parameters;

//   const Preset({
//     required this.id,
//     required this.name,
//     required this.commodity,
//     required this.creator,
//     this.description,
//     this.parameters = const [],
//   });
// }

// // =========================================================================
// // --- REPOSITORY & STATE MANAGEMENT (Unchanged) ---
// // =========================================================================

// class FakePresetRepository {
//   final _uuid = const Uuid();
//   final List<Preset> _presets = [
//     Preset(
//       id: 'flc_preset_1',
//       name: 'Lele Pembesaran',
//       commodity: 'Lele',
//       creator: PresetCreator.flocify,
//       description:
//           'Preset standar untuk budidaya lele dari benih hingga panen dengan parameter optimal.',
//       parameters: [
//         PresetParameter(id: 'p1', name: 'pH', min: 6.5, max: 7.5, unit: ''),
//         PresetParameter(id: 'p2', name: 'Suhu', min: 26, max: 30, unit: '°C'),
//         PresetParameter(
//           id: 'p3',
//           name: 'Amonia',
//           min: 0,
//           max: 0.1,
//           unit: 'mg/L',
//         ),
//         PresetParameter(
//           id: 'p4',
//           name: 'Oksigen',
//           min: 4,
//           max: 6,
//           unit: 'mg/L',
//         ),
//       ],
//     ),
//     Preset(
//       id: 'flc_preset_2',
//       name: 'Udang Vaname Intensif',
//       commodity: 'Udang Vaname',
//       creator: PresetCreator.flocify,
//       description:
//           'Optimal untuk sistem bioflok dengan salinitas rendah 10-15 ppt.',
//       parameters: [
//         PresetParameter(id: 'p5', name: 'pH', min: 7.8, max: 8.5, unit: ''),
//         PresetParameter(id: 'p6', name: 'Suhu', min: 28, max: 32, unit: '°C'),
//         PresetParameter(
//           id: 'p7',
//           name: 'Salinitas',
//           min: 10,
//           max: 15,
//           unit: 'ppt',
//         ),
//       ],
//     ),
//     Preset(
//       id: 'user_preset_1',
//       name: 'Nila Merah Kolam Terpal',
//       commodity: 'Nila',
//       creator: PresetCreator.user,
//       description: 'Preset khusus untuk kolam terpal di halaman belakang.',
//       parameters: [
//         PresetParameter(id: 'p8', name: 'pH', min: 7.0, max: 8.0, unit: ''),
//         PresetParameter(id: 'p9', name: 'Suhu', min: 25, max: 30, unit: '°C'),
//       ],
//     ),
//   ];

//   Future<List<Preset>> getPresets() async {
//     await Future.delayed(const Duration(milliseconds: 800));
//     return List.from(_presets);
//   }

//   Future<void> addPreset(Preset preset) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _presets.add(preset);
//   }

//   Future<void> updatePreset(Preset preset) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     final index = _presets.indexWhere((p) => p.id == preset.id);
//     if (index != -1) {
//       _presets[index] = preset;
//     }
//   }

//   Future<void> deletePreset(String presetId) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _presets.removeWhere((p) => p.id == presetId);
//   }
// }

// final presetRepositoryProvider = Provider<FakePresetRepository>((ref) {
//   return FakePresetRepository();
// });

// class PresetListNotifier extends StateNotifier<AsyncValue<List<Preset>>> {
//   final FakePresetRepository _repository;

//   PresetListNotifier(this._repository) : super(const AsyncValue.loading()) {
//     fetchPresets();
//   }

//   Future<void> fetchPresets() async {
//     state = const AsyncValue.loading();
//     try {
//       final presets = await _repository.getPresets();
//       state = AsyncValue.data(presets);
//     } catch (e, s) {
//       state = AsyncValue.error(e, s);
//     }
//   }

//   Future<void> addPreset(Preset preset) async {
//     try {
//       await _repository.addPreset(preset);
//       await fetchPresets();
//     } catch (e, s) {
//       state = AsyncValue.error(e, s);
//     }
//   }

//   Future<void> updatePreset(Preset preset) async {
//     try {
//       await _repository.updatePreset(preset);
//       await fetchPresets();
//     } catch (e, s) {
//       state = AsyncValue.error(e, s);
//     }
//   }

//   Future<void> deletePreset(String presetId) async {
//     try {
//       await _repository.deletePreset(presetId);
//       await fetchPresets();
//     } catch (e, s) {
//       state = AsyncValue.error(e, s);
//     }
//   }
// }

// final presetListProvider =
//     StateNotifierProvider.autoDispose<
//       PresetListNotifier,
//       AsyncValue<List<Preset>>
//     >((ref) {
//       return PresetListNotifier(ref.watch(presetRepositoryProvider));
//     });

// // =========================================================================
// // --- MAIN SCREEN ---
// // =========================================================================

// class PresetListScreen extends ConsumerWidget {
//   const PresetListScreen({super.key});

//   void _showPresetEditor(BuildContext context, {Preset? existingPreset}) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => _PresetEditorScreen(preset: existingPreset),
//         fullscreenDialog: true,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final presetsAsyncValue = ref.watch(presetListProvider);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         elevation: 0.5,
//         shadowColor: AppColors.shadow,
//         backgroundColor: AppColors.surface,
//         surfaceTintColor: Colors.transparent,
//         title: const Text(
//           'Preset Budidaya',
//           style: TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             letterSpacing: -0.5,
//           ),
//         ),
//         centerTitle: false,
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//       ),
//       body: presetsAsyncValue.when(
//         loading: () => const _LoadingState(),
//         error: (error, stack) => _ErrorState(
//           onRetry: () => ref.read(presetListProvider.notifier).fetchPresets(),
//         ),
//         data: (presets) {
//           if (presets.isEmpty) {
//             return _EmptyState(onAdd: () => _showPresetEditor(context));
//           }

//           final userPresets = presets
//               .where((p) => p.creator == PresetCreator.user)
//               .toList();
//           final flocifyPresets = presets
//               .where((p) => p.creator == PresetCreator.flocify)
//               .toList();

//           return RefreshIndicator(
//             onRefresh: () =>
//                 ref.read(presetListProvider.notifier).fetchPresets(),
//             color: AppColors.primary,
//             backgroundColor: AppColors.surface,
//             child: CustomScrollView(
//               slivers: [
//                 // Header dengan statistik
//                 SliverToBoxAdapter(
//                   child: Container(
//                     margin: const EdgeInsets.all(AppSpacing.md),
//                     padding: const EdgeInsets.all(AppSpacing.lg),
//                     decoration: BoxDecoration(
//                       color: AppColors.surface,
//                       borderRadius: BorderRadius.circular(AppRadius.lg),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.shadow,
//                           blurRadius: 10,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         _StatCard(
//                           icon: Icons.inventory_2_outlined,
//                           title: 'Total Preset',
//                           value: '${presets.length}',
//                           color: AppColors.primary,
//                         ),
//                         const SizedBox(width: AppSpacing.md),
//                         _StatCard(
//                           icon: Icons.person_outline,
//                           title: 'Milik Anda',
//                           value: '${userPresets.length}',
//                           color: AppColors.success,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // User Presets Section
//                 if (userPresets.isNotEmpty) ...[
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(
//                         AppSpacing.md,
//                         0,
//                         AppSpacing.md,
//                         AppSpacing.sm,
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 4,
//                             height: 24,
//                             decoration: BoxDecoration(
//                               color: AppColors.success,
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ),
//                           const SizedBox(width: AppSpacing.sm),
//                           const Text(
//                             'Preset Saya',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.textPrimary,
//                               letterSpacing: -0.3,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) => _PresetCard(
//                         preset: userPresets[index],
//                         onEdit: () => _showPresetEditor(
//                           context,
//                           existingPreset: userPresets[index],
//                         ),
//                       ),
//                       childCount: userPresets.length,
//                     ),
//                   ),
//                   const SliverToBoxAdapter(
//                     child: SizedBox(height: AppSpacing.lg),
//                   ),
//                 ],

//                 // Flocify Presets Section
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(
//                       AppSpacing.md,
//                       0,
//                       AppSpacing.md,
//                       AppSpacing.sm,
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 4,
//                           height: 24,
//                           decoration: BoxDecoration(
//                             color: AppColors.primary,
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                         const SizedBox(width: AppSpacing.sm),
//                         const Text(
//                           'Rekomendasi Flocify',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.textPrimary,
//                             letterSpacing: -0.3,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) => _PresetCard(
//                       preset: flocifyPresets[index],
//                       onEdit: () => _showPresetEditor(
//                         context,
//                         existingPreset: flocifyPresets[index],
//                       ),
//                     ),
//                     childCount: flocifyPresets.length,
//                   ),
//                 ),
//                 const SliverToBoxAdapter(child: SizedBox(height: 100)),
//               ],
//             ),
//           );
//         },
//       ),
//       floatingActionButton: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(AppRadius.lg),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primary.withOpacity(0.3),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: FloatingActionButton.extended(
//           onPressed: () => _showPresetEditor(context),
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppRadius.lg),
//           ),
//           icon: const Icon(Icons.add, size: 20),
//           label: const Text(
//             'Buat Preset',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // =========================================================================
// // --- UI COMPONENTS ---
// // =========================================================================

// class _StatCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;
//   final Color color;

//   const _StatCard({
//     required this.icon,
//     required this.title,
//     required this.value,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(AppSpacing.md),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(AppRadius.md),
//           border: Border.all(color: color.withOpacity(0.1)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(height: AppSpacing.sm),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: color,
//                 letterSpacing: -0.5,
//               ),
//             ),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PresetCard extends ConsumerWidget {
//   final Preset preset;
//   final VoidCallback onEdit;

//   const _PresetCard({required this.preset, required this.onEdit});

//   void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         backgroundColor: AppColors.surface,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppRadius.lg),
//         ),
//         title: const Text(
//           'Hapus Preset?',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         content: Text(
//           'Preset "${preset.name}" akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.',
//           style: const TextStyle(
//             fontSize: 15,
//             color: AppColors.textSecondary,
//             height: 1.4,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(dialogContext).pop(),
//             child: const Text(
//               'Batal',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ),
//           FilledButton(
//             onPressed: () {
//               Navigator.of(dialogContext).pop();
//               ref.read(presetListProvider.notifier).deletePreset(preset.id);
//               _showSuccessSnackBar(
//                 context,
//                 'Preset "${preset.name}" berhasil dihapus',
//               );
//             },
//             style: FilledButton.styleFrom(
//               backgroundColor: AppColors.danger,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppRadius.sm),
//               ),
//             ),
//             child: const Text(
//               'Hapus',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSuccessSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColors.success,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppRadius.sm),
//         ),
//         margin: const EdgeInsets.all(AppSpacing.md),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isUserCreated = preset.creator == PresetCreator.user;
//     final parameterCount = preset.parameters.length;

//     return Container(
//       margin: const EdgeInsets.fromLTRB(
//         AppSpacing.md,
//         0,
//         AppSpacing.md,
//         AppSpacing.md,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(AppRadius.lg),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadow,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(AppRadius.lg),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(AppRadius.lg),
//           onTap: onEdit,
//           child: Padding(
//             padding: const EdgeInsets.all(AppSpacing.lg),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 48,
//                       height: 48,
//                       decoration: BoxDecoration(
//                         color:
//                             (isUserCreated
//                                     ? AppColors.success
//                                     : AppColors.primary)
//                                 .withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(AppRadius.md),
//                       ),
//                       child: Icon(
//                         isUserCreated
//                             ? Icons.person_outline
//                             : Icons.auto_awesome_outlined,
//                         color: isUserCreated
//                             ? AppColors.success
//                             : AppColors.primary,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: AppSpacing.md),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             preset.name,
//                             style: const TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.textPrimary,
//                               letterSpacing: -0.3,
//                             ),
//                           ),
//                           const SizedBox(height: 2),
//                           Row(
//                             children: [
//                               _CreatorBadge(isUserCreated: isUserCreated),
//                               const SizedBox(width: AppSpacing.sm),
//                               Container(
//                                 width: 4,
//                                 height: 4,
//                                 decoration: const BoxDecoration(
//                                   color: AppColors.textTertiary,
//                                   shape: BoxShape.circle,
//                                 ),
//                               ),
//                               const SizedBox(width: AppSpacing.sm),
//                               Text(
//                                 preset.commodity,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.textSecondary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     PopupMenuButton<String>(
//                       onSelected: (value) {
//                         if (value == 'edit') onEdit();
//                         if (value == 'delete') {
//                           _showDeleteConfirmation(context, ref);
//                         }
//                       },
//                       itemBuilder: (context) => [
//                         const PopupMenuItem(
//                           value: 'edit',
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.edit_outlined,
//                                 size: 18,
//                                 color: AppColors.textSecondary,
//                               ),
//                               SizedBox(width: 12),
//                               Text(
//                                 'Edit',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (isUserCreated)
//                           const PopupMenuItem(
//                             value: 'delete',
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.delete_outline,
//                                   size: 18,
//                                   color: AppColors.danger,
//                                 ),
//                                 SizedBox(width: 12),
//                                 Text(
//                                   'Hapus',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.danger,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                       icon: const Icon(
//                         Icons.more_vert,
//                         color: AppColors.textTertiary,
//                         size: 20,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(AppRadius.md),
//                       ),
//                       elevation: 8,
//                       shadowColor: AppColors.shadow,
//                     ),
//                   ],
//                 ),
//                 if (preset.description != null &&
//                     preset.description!.isNotEmpty) ...[
//                   const SizedBox(height: AppSpacing.md),
//                   Text(
//                     preset.description!,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: AppColors.textSecondary,
//                       height: 1.4,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//                 const SizedBox(height: AppSpacing.md),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: AppSpacing.sm,
//                     vertical: AppSpacing.xs,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryLight,
//                     borderRadius: BorderRadius.circular(AppRadius.sm),
//                   ),
//                   child: Text(
//                     '$parameterCount Parameter',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _CreatorBadge extends StatelessWidget {
//   final bool isUserCreated;

//   const _CreatorBadge({required this.isUserCreated});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppSpacing.sm,
//         vertical: 2,
//       ),
//       decoration: BoxDecoration(
//         color: (isUserCreated ? AppColors.success : AppColors.primary)
//             .withOpacity(0.1),
//         borderRadius: BorderRadius.circular(AppRadius.sm),
//         border: Border.all(
//           color: (isUserCreated ? AppColors.success : AppColors.primary)
//               .withOpacity(0.2),
//         ),
//       ),
//       child: Text(
//         isUserCreated ? 'Milik Anda' : 'Flocify',
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           color: isUserCreated ? AppColors.success : AppColors.primary,
//         ),
//       ),
//     );
//   }
// }

// // =========================================================================
// // --- STATE WIDGETS ---
// // =========================================================================

// class _LoadingState extends StatelessWidget {
//   const _LoadingState();

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
//           SizedBox(height: AppSpacing.lg),
//           Text(
//             'Memuat preset...',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _EmptyState extends StatelessWidget {
//   final VoidCallback onAdd;

//   const _EmptyState({required this.onAdd});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(AppSpacing.xl),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryLight,
//                 borderRadius: BorderRadius.circular(60),
//               ),
//               child: const Icon(
//                 Icons.inventory_2_outlined,
//                 size: 60,
//                 color: AppColors.primary,
//               ),
//             ),
//             const SizedBox(height: AppSpacing.lg),
//             const Text(
//               'Belum Ada Preset',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//                 letterSpacing: -0.5,
//               ),
//             ),
//             const SizedBox(height: AppSpacing.sm),
//             Text(
//               'Buat preset pertama untuk menyimpan pengaturan parameter budidaya yang ideal',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: AppColors.textSecondary,
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: AppSpacing.xl),
//             FilledButton.icon(
//               onPressed: onAdd,
//               icon: const Icon(Icons.add),
//               label: const Text(
//                 'Buat Preset Pertama',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               style: FilledButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppSpacing.lg,
//                   vertical: AppSpacing.md,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(AppRadius.md),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ErrorState extends StatelessWidget {
//   final VoidCallback onRetry;

//   const _ErrorState({required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(AppSpacing.xl),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: AppColors.danger.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(60),
//               ),
//               child: Icon(
//                 Icons.cloud_off_outlined,
//                 size: 60,
//                 color: AppColors.danger,
//               ),
//             ),
//             const SizedBox(height: AppSpacing.lg),
//             const Text(
//               'Terjadi Kesalahan',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//                 letterSpacing: -0.5,
//               ),
//             ),
//             const SizedBox(height: AppSpacing.sm),
//             Text(
//               'Tidak dapat memuat data preset. Periksa koneksi internet dan coba lagi.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: AppColors.textSecondary,
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: AppSpacing.xl),
//             FilledButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh),
//               label: const Text(
//                 'Coba Lagi',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               style: FilledButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppSpacing.lg,
//                   vertical: AppSpacing.md,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(AppRadius.md),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // =========================================================================
// // --- PRESET EDITOR SCREEN ---
// // =========================================================================

// class _PresetEditorScreen extends ConsumerStatefulWidget {
//   final Preset? preset;
//   const _PresetEditorScreen({this.preset});

//   @override
//   ConsumerState<_PresetEditorScreen> createState() =>
//       _PresetEditorScreenState();
// }

// class _PresetEditorScreenState extends ConsumerState<_PresetEditorScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _uuid = const Uuid();

//   late TextEditingController _nameController;
//   late TextEditingController _commodityController;
//   late TextEditingController _descriptionController;
//   late List<PresetParameter> _parameters;

//   bool get _isEditing => widget.preset != null;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.preset?.name ?? '');
//     _commodityController = TextEditingController(
//       text: widget.preset?.commodity ?? '',
//     );
//     _descriptionController = TextEditingController(
//       text: widget.preset?.description ?? '',
//     );
//     _parameters =
//         widget.preset?.parameters.map((p) => p.copyWith()).toList() ?? [];
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _commodityController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   void _addParameter() {
//     setState(() {
//       _parameters.add(
//         PresetParameter(id: _uuid.v4(), name: '', min: 0, max: 0, unit: ''),
//       );
//     });
//   }

//   void _removeParameter(String id) {
//     setState(() {
//       _parameters.removeWhere((p) => p.id == id);
//     });
//   }

//   void _updateParameter(int index, PresetParameter newParam) {
//     setState(() {
//       _parameters[index] = newParam;
//     });
//   }

//   Future<void> _savePreset() async {
//     if (!_formKey.currentState!.validate()) return;

//     // Validasi parameter
//     if (_parameters.isEmpty) {
//       _showErrorSnackBar('Tambahkan minimal satu parameter');
//       return;
//     }

//     for (final param in _parameters) {
//       if (param.name.isEmpty) {
//         _showErrorSnackBar('Semua parameter harus dipilih');
//         return;
//       }
//       if (param.min >= param.max) {
//         _showErrorSnackBar('Nilai minimum harus lebih kecil dari maksimum');
//         return;
//       }
//     }

//     setState(() => _isLoading = true);

//     try {
//       final newPreset = Preset(
//         id: widget.preset?.id ?? _uuid.v4(),
//         name: _nameController.text.trim(),
//         commodity: _commodityController.text.trim(),
//         description: _descriptionController.text.trim().isEmpty
//             ? null
//             : _descriptionController.text.trim(),
//         creator: PresetCreator.user,
//         parameters: _parameters,
//       );

//       if (_isEditing) {
//         await ref.read(presetListProvider.notifier).updatePreset(newPreset);
//       } else {
//         await ref.read(presetListProvider.notifier).addPreset(newPreset);
//       }

//       if (mounted) {
//         Navigator.of(context).pop();
//         _showSuccessSnackBar(
//           'Preset "${newPreset.name}" berhasil ${_isEditing ? 'diperbarui' : 'dibuat'}',
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar('Terjadi kesalahan saat menyimpan preset');
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColors.success,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppRadius.sm),
//         ),
//         margin: const EdgeInsets.all(AppSpacing.md),
//       ),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColors.danger,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppRadius.sm),
//         ),
//         margin: const EdgeInsets.all(AppSpacing.md),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         elevation: 0.5,
//         shadowColor: AppColors.shadow,
//         backgroundColor: AppColors.surface,
//         surfaceTintColor: Colors.transparent,
//         title: Text(
//           _isEditing ? 'Edit Preset' : 'Buat Preset Baru',
//           style: const TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             letterSpacing: -0.5,
//           ),
//         ),
//         centerTitle: false,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: AppSpacing.sm),
//             child: FilledButton(
//               onPressed: _isLoading ? null : _savePreset,
//               style: FilledButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 disabledBackgroundColor: AppColors.textTertiary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(AppRadius.sm),
//                 ),
//               ),
//               child: _isLoading
//                   ? const SizedBox(
//                       width: 16,
//                       height: 16,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                   : const Text(
//                       'Simpan',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//             ),
//           ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: CustomScrollView(
//           slivers: [
//             // Basic Information Section
//             SliverToBoxAdapter(
//               child: Container(
//                 margin: const EdgeInsets.all(AppSpacing.md),
//                 padding: const EdgeInsets.all(AppSpacing.lg),
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(AppRadius.lg),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.shadow,
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(
//                           Icons.info_outline,
//                           color: AppColors.primary,
//                           size: 20,
//                         ),
//                         SizedBox(width: AppSpacing.sm),
//                         Text(
//                           'Informasi Dasar',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.textPrimary,
//                             letterSpacing: -0.3,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: AppSpacing.lg),
//                     _buildTextField(
//                       controller: _nameController,
//                       label: 'Nama Preset',
//                       hint: 'Contoh: Lele Kolam Terpal',
//                       icon: Icons.label_outline,
//                     ),
//                     const SizedBox(height: AppSpacing.md),
//                     _buildTextField(
//                       controller: _commodityController,
//                       label: 'Komoditas',
//                       hint: 'Contoh: Lele, Nila, Udang',
//                       icon: Icons.waves_outlined,
//                     ),
//                     const SizedBox(height: AppSpacing.md),
//                     _buildTextField(
//                       controller: _descriptionController,
//                       label: 'Deskripsi (Opsional)',
//                       hint: 'Jelaskan kegunaan preset ini...',
//                       icon: Icons.description_outlined,
//                       maxLines: 3,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Parameters Section
//             SliverToBoxAdapter(
//               child: Container(
//                 margin: const EdgeInsets.fromLTRB(
//                   AppSpacing.md,
//                   0,
//                   AppSpacing.md,
//                   AppSpacing.md,
//                 ),
//                 padding: const EdgeInsets.all(AppSpacing.lg),
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(AppRadius.lg),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.shadow,
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.tune,
//                           color: AppColors.primary,
//                           size: 20,
//                         ),
//                         const SizedBox(width: AppSpacing.sm),
//                         const Expanded(
//                           child: Text(
//                             'Parameter Kualitas Air',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.textPrimary,
//                               letterSpacing: -0.3,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: AppSpacing.sm,
//                             vertical: AppSpacing.xs,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.primaryLight,
//                             borderRadius: BorderRadius.circular(AppRadius.sm),
//                           ),
//                           child: Text(
//                             '${_parameters.length} Parameter',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (_parameters.isEmpty) ...[
//                       const SizedBox(height: AppSpacing.lg),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(AppSpacing.lg),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryLight,
//                           borderRadius: BorderRadius.circular(AppRadius.md),
//                           border: Border.all(
//                             color: AppColors.primary.withOpacity(0.2),
//                             style: BorderStyle.solid,
//                           ),
//                         ),
//                         child: Column(
//                           children: [
//                             Icon(
//                               Icons.add_circle_outline,
//                               size: 48,
//                               color: AppColors.primary.withOpacity(0.7),
//                             ),
//                             const SizedBox(height: AppSpacing.sm),
//                             const Text(
//                               'Belum ada parameter',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Tambahkan parameter untuk mengatur kualitas air',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: AppColors.primary.withOpacity(0.8),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                     const SizedBox(height: AppSpacing.lg),
//                     SizedBox(
//                       width: double.infinity,
//                       child: OutlinedButton.icon(
//                         onPressed: _addParameter,
//                         icon: const Icon(Icons.add, size: 18),
//                         label: const Text(
//                           'Tambah Parameter',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           foregroundColor: AppColors.primary,
//                           side: const BorderSide(color: AppColors.primary),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(AppRadius.md),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             vertical: AppSpacing.md,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Parameter Cards
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) => _ParameterCard(
//                   parameter: _parameters[index],
//                   index: index,
//                   onUpdate: (newParam) => _updateParameter(index, newParam),
//                   onRemove: () => _removeParameter(_parameters[index].id),
//                 ),
//                 childCount: _parameters.length,
//               ),
//             ),

//             const SliverToBoxAdapter(child: SizedBox(height: 100)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       maxLines: maxLines,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         color: AppColors.textPrimary,
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
//         labelStyle: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: AppColors.textSecondary,
//         ),
//         hintStyle: TextStyle(fontSize: 15, color: AppColors.textTertiary),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.md),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.md),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.md),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.md),
//           borderSide: const BorderSide(color: AppColors.danger),
//         ),
//         filled: true,
//         fillColor: AppColors.surface,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.md,
//           vertical: AppSpacing.md,
//         ),
//       ),
//       validator: (value) {
//         if (label.contains('Opsional')) return null;
//         if (value == null || value.trim().isEmpty) {
//           return '$label tidak boleh kosong';
//         }
//         return null;
//       },
//     );
//   }
// }

// // =========================================================================
// // --- PARAMETER CARD COMPONENT ---
// // =========================================================================

// class _ParameterCard extends StatelessWidget {
//   final PresetParameter parameter;
//   final int index;
//   final ValueChanged<PresetParameter> onUpdate;
//   final VoidCallback onRemove;

//   const _ParameterCard({
//     required this.parameter,
//     required this.index,
//     required this.onUpdate,
//     required this.onRemove,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(
//         AppSpacing.md,
//         0,
//         AppSpacing.md,
//         AppSpacing.md,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(AppRadius.lg),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadow,
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(AppSpacing.lg),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryLight,
//                     borderRadius: BorderRadius.circular(AppRadius.sm),
//                   ),
//                   child: Center(
//                     child: Text(
//                       '${index + 1}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: AppSpacing.sm),
//                 const Expanded(
//                   child: Text(
//                     'Parameter',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: onRemove,
//                   icon: const Icon(
//                     Icons.delete_outline,
//                     color: AppColors.danger,
//                     size: 20,
//                   ),
//                   style: IconButton.styleFrom(
//                     backgroundColor: AppColors.danger.withOpacity(0.1),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(AppRadius.sm),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: AppSpacing.md),
//             DropdownButtonFormField<String>(
//               value: parameter.name.isEmpty ? null : parameter.name,
//               hint: const Text(
//                 'Pilih Parameter',
//                 style: TextStyle(fontSize: 15, color: AppColors.textTertiary),
//               ),
//               items:
//                   const [
//                         'pH',
//                         'Suhu',
//                         'Amonia',
//                         'Oksigen',
//                         'Salinitas',
//                         'Alkalinitas',
//                         'Nitrit',
//                         'Nitrat',
//                       ]
//                       .map(
//                         (param) => DropdownMenuItem(
//                           value: param,
//                           child: Text(
//                             param,
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       )
//                       .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   onUpdate(parameter.copyWith(name: value));
//                 }
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(AppRadius.md),
//                   borderSide: const BorderSide(color: AppColors.border),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(AppRadius.md),
//                   borderSide: const BorderSide(color: AppColors.border),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(AppRadius.md),
//                   borderSide: const BorderSide(
//                     color: AppColors.primary,
//                     width: 2,
//                   ),
//                 ),
//                 filled: true,
//                 fillColor: AppColors.background,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: AppSpacing.md,
//                   vertical: AppSpacing.md,
//                 ),
//               ),
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: AppSpacing.md),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildNumericField(
//                     label: 'Minimum',
//                     value: parameter.min,
//                     onChanged: (val) => onUpdate(parameter.copyWith(min: val)),
//                   ),
//                 ),
//                 const SizedBox(width: AppSpacing.md),
//                 Expanded(
//                   child: _buildNumericField(
//                     label: 'Maksimum',
//                     value: parameter.max,
//                     onChanged: (val) => onUpdate(parameter.copyWith(max: val)),
//                   ),
//                 ),
//                 const SizedBox(width: AppSpacing.md),
//                 Expanded(
//                   child: _buildUnitField(
//                     value: parameter.unit,
//                     onChanged: (val) => onUpdate(parameter.copyWith(unit: val)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNumericField({
//     required String label,
//     required double value,
//     required ValueChanged<double> onChanged,
//   }) {
//     return TextFormField(
//       initialValue: value.toString(),
//       keyboardType: const TextInputType.numberWithOptions(decimal: true),
//       style: const TextStyle(
//         fontSize: 15,
//         fontWeight: FontWeight.w500,
//         color: AppColors.textPrimary,
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: AppColors.textSecondary,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.sm),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.sm),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.sm),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         filled: true,
//         fillColor: AppColors.background,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.sm,
//           vertical: AppSpacing.sm,
//         ),
//       ),
//       onChanged: (value) => onChanged(double.tryParse(value) ?? 0),
//     );
//   }

//   Widget _buildUnitField({
//     required String value,
//     required ValueChanged<String> onChanged,
//   }) {
//     return TextFormField(
//       initialValue: value,
//       style: const TextStyle(
//         fontSize: 15,
//         fontWeight: FontWeight.w500,
//         color: AppColors.textPrimary,
//       ),
//       decoration: InputDecoration(
//         labelText: 'Unit',
//         hintText: '°C, mg/L',
//         labelStyle: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: AppColors.textSecondary,
//         ),
//         hintStyle: TextStyle(fontSize: 13, color: AppColors.textTertiary),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.sm),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.sm),
//           borderSide: const BorderSide(color: AppColors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(AppRadius.sm),
//           borderSide: const BorderSide(color: AppColors.primary, width: 2),
//         ),
//         filled: true,
//         fillColor: AppColors.background,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.sm,
//           vertical: AppSpacing.sm,
//         ),
//       ),
//       onChanged: onChanged,
//     );
//   }
// }
