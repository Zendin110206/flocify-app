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
//   static const Color primary = Color(0xFF2563EB);
//   static const Color primaryLight = Color(0xFFEFF6FF);
//   static const Color secondary = Color(0xFF059669);
//   static const Color background = Color(0xFFFAFAFA);
//   static const Color surface = Color(0xFFFFFFFF);
//   static const Color textPrimary = Color(0xFF111827);
//   static const Color textSecondary = Color(0xFF6B7280);
//   static const Color textMuted = Color(0xFF9CA3AF);
//   static const Color border = Color(0xFFE5E7EB);
//   static const Color success = Color(0xFF10B981);
//   static const Color warning = Color(0xFFF59E0B);
//   static const Color error = Color(0xFFEF4444);
// }

// class AppSpacing {
//   static const double xs = 4.0;
//   static const double sm = 8.0;
//   static const double md = 16.0;
//   static const double lg = 24.0;
//   static const double xl = 32.0;
// }

// // =========================================================================
// // --- MODELS (Same as original) ---
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
// // --- REPOSITORY & STATE MANAGEMENT (Same as original) ---
// // =========================================================================

// class FakePresetRepository {
//   final _uuid = const Uuid();
//   final List<Preset> _presets = [
//     Preset(
//       id: 'flc_preset_1',
//       name: 'Lele Pembesaran',
//       commodity: 'Lele',
//       creator: PresetCreator.flocify,
//       description: 'Standar budidaya lele dari benih hingga panen',
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
//       ],
//     ),
//     Preset(
//       id: 'flc_preset_2',
//       name: 'Udang Vaname',
//       commodity: 'Udang Vaname',
//       creator: PresetCreator.flocify,
//       description: 'Optimal untuk sistem bioflok salinitas rendah',
//       parameters: [
//         PresetParameter(id: 'p4', name: 'pH', min: 7.8, max: 8.5, unit: ''),
//         PresetParameter(id: 'p5', name: 'Suhu', min: 28, max: 32, unit: '°C'),
//       ],
//     ),
//     Preset(
//       id: 'user_preset_1',
//       name: 'Nila Kolam Terpal',
//       commodity: 'Nila',
//       creator: PresetCreator.user,
//       description: 'Kolam terpal di halaman belakang',
//       parameters: [
//         PresetParameter(id: 'p6', name: 'pH', min: 7.0, max: 8.0, unit: ''),
//       ],
//     ),
//   ];

//   Future<List<Preset>> getPresets() async {
//     await Future.delayed(const Duration(milliseconds: 800));
//     return List.from(_presets);
//   }

//   Future<void> addPreset(Preset preset) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _presets.add(preset);
//   }

//   Future<void> updatePreset(Preset preset) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     final index = _presets.indexWhere((p) => p.id == preset.id);
//     if (index != -1) {
//       _presets[index] = preset;
//     }
//   }

//   Future<void> deletePreset(String presetId) async {
//     await Future.delayed(const Duration(milliseconds: 300));
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
//       appBar: _buildAppBar(context),
//       body: presetsAsyncValue.when(
//         loading: () => _buildLoadingState(),
//         error: (error, stack) => _ErrorState(
//           onRetry: () => ref.read(presetListProvider.notifier).fetchPresets(),
//         ),
//         data: (presets) {
//           if (presets.isEmpty) {
//             return _EmptyState(onAdd: () => _showPresetEditor(context));
//           }
//           return _buildPresetList(context, presets);
//         },
//       ),
//       floatingActionButton: _buildFAB(context),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: AppColors.surface,
//       elevation: 0,
//       systemOverlayStyle: SystemUiOverlayStyle.dark,
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Preset Budidaya',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: AppColors.textPrimary,
//               letterSpacing: -0.5,
//             ),
//           ),
//           Text(
//             'Kelola pengaturan kualitas air',
//             style: TextStyle(
//               fontSize: 13,
//               color: AppColors.textMuted,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//       toolbarHeight: 72,
//       bottom: PreferredSize(
//         preferredSize: Size.fromHeight(1),
//         child: Container(height: 1, color: AppColors.border),
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 48,
//             height: 48,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//               valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//             ),
//           ),
//           SizedBox(height: AppSpacing.md),
//           Text(
//             'Memuat preset...',
//             style: TextStyle(
//               color: AppColors.textMuted,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPresetList(BuildContext context, List<Preset> presets) {
//     final userPresets = presets
//         .where((p) => p.creator == PresetCreator.user)
//         .toList();
//     final flocifyPresets = presets
//         .where((p) => p.creator == PresetCreator.flocify)
//         .toList();

//     return RefreshIndicator(
//       onRefresh: () => key?.read(presetListProvider.notifier).fetchPresets(),
//       color: AppColors.primary,
//       child: SingleChildScrollView(
//         physics: AlwaysScrollableScrollPhysics(),
//         padding: EdgeInsets.fromLTRB(
//           AppSpacing.md,
//           AppSpacing.md,
//           AppSpacing.md,
//           80,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (userPresets.isNotEmpty) ...[
//               _SectionHeader(
//                 title: 'Preset Saya',
//                 subtitle: '${userPresets.length} preset',
//                 icon: Icons.person_outline,
//               ),
//               SizedBox(height: AppSpacing.sm),
//               ...userPresets.map(
//                 (preset) => _PresetCard(
//                   preset: preset,
//                   onTap: () =>
//                       _showPresetEditor(context, existingPreset: preset),
//                 ),
//               ),
//               SizedBox(height: AppSpacing.lg),
//             ],
//             _SectionHeader(
//               title: 'Rekomendasi Flocify',
//               subtitle: '${flocifyPresets.length} preset tersedia',
//               icon: Icons.verified_outlined,
//             ),
//             SizedBox(height: AppSpacing.sm),
//             ...flocifyPresets.map(
//               (preset) => _PresetCard(
//                 preset: preset,
//                 onTap: () => _showPresetEditor(context, existingPreset: preset),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFAB(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
//       child: FloatingActionButton.extended(
//         onPressed: () => _showPresetEditor(context),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         icon: Icon(Icons.add, size: 20),
//         label: Text(
//           'Buat Preset Baru',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.2,
//           ),
//         ),
//       ),
//     );
//   }
// }

// extension on Key? {
//   read(Refreshable<PresetListNotifier> notifier) {}
// }

// // =========================================================================
// // --- UI COMPONENTS ---
// // =========================================================================

// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;

//   const _SectionHeader({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: AppColors.primaryLight,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: AppColors.primary, size: 20),
//           ),
//           SizedBox(width: AppSpacing.sm),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.textPrimary,
//                     letterSpacing: -0.3,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: AppColors.textMuted,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PresetCard extends ConsumerWidget {
//   final Preset preset;
//   final VoidCallback onTap;

//   const _PresetCard({required this.preset, required this.onTap});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isUserCreated = preset.creator == PresetCreator.user;
//     final parameterCount = preset.parameters.length;

//     return Container(
//       margin: EdgeInsets.only(bottom: AppSpacing.sm),
//       child: Material(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         elevation: 2,
//         shadowColor: Colors.black.withOpacity(0.04),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: EdgeInsets.all(AppSpacing.md),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     _buildPresetIcon(preset.commodity),
//                     SizedBox(width: AppSpacing.sm),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             preset.name,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.textPrimary,
//                               letterSpacing: -0.2,
//                             ),
//                           ),
//                           SizedBox(height: 2),
//                           Text(
//                             preset.commodity,
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: AppColors.textSecondary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     _CreatorBadge(isUserCreated: isUserCreated),
//                     SizedBox(width: AppSpacing.xs),
//                     _buildMenuButton(context, ref),
//                   ],
//                 ),
//                 if (preset.description != null) ...[
//                   SizedBox(height: AppSpacing.sm),
//                   Text(
//                     preset.description!,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: AppColors.textMuted,
//                       height: 1.4,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//                 SizedBox(height: AppSpacing.sm),
//                 _buildParameterSummary(parameterCount),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPresetIcon(String commodity) {
//     IconData icon;
//     Color backgroundColor;
//     Color iconColor;

//     switch (commodity.toLowerCase()) {
//       case 'lele':
//         icon = Icons.water;
//         backgroundColor = Color(0xFFEFF6FF);
//         iconColor = Color(0xFF2563EB);
//         break;
//       case 'udang vaname':
//         icon = Icons.waves;
//         backgroundColor = Color(0xFFF0FDF4);
//         iconColor = Color(0xFF059669);
//         break;
//       case 'nila':
//         icon = Icons.pool;
//         backgroundColor = Color(0xFFFFF7ED);
//         iconColor = Color(0xFFF59E0B);
//         break;
//       default:
//         icon = Icons.science_outlined;
//         backgroundColor = AppColors.primaryLight;
//         iconColor = AppColors.primary;
//     }

//     return Container(
//       width: 48,
//       height: 48,
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Icon(icon, color: iconColor, size: 24),
//     );
//   }

//   Widget _buildParameterSummary(int count) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: AppSpacing.sm,
//         vertical: AppSpacing.xs,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.background,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.border, width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.tune, size: 14, color: AppColors.textMuted),
//           SizedBox(width: 4),
//           Text(
//             '$count parameter',
//             style: TextStyle(
//               fontSize: 12,
//               color: AppColors.textMuted,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuButton(BuildContext context, WidgetRef ref) {
//     return PopupMenuButton<String>(
//       onSelected: (value) {
//         if (value == 'edit') onTap();
//         if (value == 'delete') _showDeleteDialog(context, ref);
//       },
//       itemBuilder: (context) => [
//         PopupMenuItem(
//           value: 'edit',
//           child: Row(
//             children: [
//               Icon(
//                 Icons.edit_outlined,
//                 size: 18,
//                 color: AppColors.textSecondary,
//               ),
//               SizedBox(width: AppSpacing.sm),
//               Text('Edit Preset'),
//             ],
//           ),
//         ),
//         if (preset.creator == PresetCreator.user)
//           PopupMenuItem(
//             value: 'delete',
//             child: Row(
//               children: [
//                 Icon(Icons.delete_outline, size: 18, color: AppColors.error),
//                 SizedBox(width: AppSpacing.sm),
//                 Text('Hapus', style: TextStyle(color: AppColors.error)),
//               ],
//             ),
//           ),
//       ],
//       icon: Icon(Icons.more_vert, color: AppColors.textMuted, size: 20),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     );
//   }

//   void _showDeleteDialog(BuildContext context, WidgetRef ref) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Text(
//           'Hapus Preset?',
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//         content: Text(
//           'Preset "${preset.name}" akan dihapus secara permanen. Tindakan ini tidak dapat dibatalkan.',
//           style: TextStyle(height: 1.4),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Batal'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ref.read(presetListProvider.notifier).deletePreset(preset.id);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Preset "${preset.name}" berhasil dihapus'),
//                   backgroundColor: AppColors.success,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.error,
//               foregroundColor: Colors.white,
//             ),
//             child: Text('Hapus'),
//           ),
//         ],
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
//       padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
//       decoration: BoxDecoration(
//         color: isUserCreated
//             ? AppColors.success.withOpacity(0.1)
//             : AppColors.primary.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(
//           color: isUserCreated
//               ? AppColors.success.withOpacity(0.3)
//               : AppColors.primary.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Text(
//         isUserCreated ? 'Saya' : 'Flocify',
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w700,
//           color: isUserCreated ? AppColors.success : AppColors.primary,
//           letterSpacing: 0.3,
//         ),
//       ),
//     );
//   }
// }

// // =========================================================================
// // --- EMPTY & ERROR STATES ---
// // =========================================================================

// class _EmptyState extends StatelessWidget {
//   final VoidCallback onAdd;

//   const _EmptyState({required this.onAdd});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(AppSpacing.xl),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryLight,
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: Icon(
//                 Icons.science_outlined,
//                 size: 48,
//                 color: AppColors.primary,
//               ),
//             ),
//             SizedBox(height: AppSpacing.lg),
//             Text(
//               'Belum Ada Preset',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.textPrimary,
//                 letterSpacing: -0.5,
//               ),
//             ),
//             SizedBox(height: AppSpacing.sm),
//             Text(
//               'Buat preset pertama untuk menyimpan pengaturan parameter kualitas air yang ideal',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: AppColors.textMuted,
//                 height: 1.5,
//               ),
//             ),
//             SizedBox(height: AppSpacing.xl),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: onAdd,
//                 icon: Icon(Icons.add),
//                 label: Text('Buat Preset Pertama'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   textStyle: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
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
//         padding: EdgeInsets.all(AppSpacing.xl),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: AppColors.error.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: Icon(
//                 Icons.cloud_off_outlined,
//                 size: 48,
//                 color: AppColors.error,
//               ),
//             ),
//             SizedBox(height: AppSpacing.lg),
//             Text(
//               'Terjadi Kesalahan',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             SizedBox(height: AppSpacing.sm),
//             Text(
//               'Tidak dapat memuat data preset. Periksa koneksi internet dan coba lagi.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: AppColors.textMuted,
//                 height: 1.5,
//               ),
//             ),
//             SizedBox(height: AppSpacing.xl),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: onRetry,
//                 icon: Icon(Icons.refresh),
//                 label: Text('Coba Lagi'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
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
// // --- PRESET EDITOR SCREEN (Simplified version) ---
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

//   void _savePreset() {
//     if (!_formKey.currentState!.validate()) return;

//     final newPreset = Preset(
//       id: widget.preset?.id ?? _uuid.v4(),
//       name: _nameController.text.trim(),
//       commodity: _commodityController.text.trim(),
//       description: _descriptionController.text.trim().isEmpty
//           ? null
//           : _descriptionController.text.trim(),
//       creator: PresetCreator.user,
//       parameters: _parameters,
//     );

//     if (_isEditing) {
//       ref.read(presetListProvider.notifier).updatePreset(newPreset);
//     } else {
//       ref.read(presetListProvider.notifier).addPreset(newPreset);
//     }

//     Navigator.of(context).pop();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Preset "${newPreset.name}" berhasil disimpan'),
//         backgroundColor: AppColors.success,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.surface,
//         elevation: 0,
//         title: Text(
//           _isEditing ? 'Edit Preset' : 'Buat Preset Baru',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.only(right: AppSpacing.sm),
//             child: TextButton(
//               onPressed: _savePreset,
//               child: Text(
//                 'Simpan',
//                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Container(height: 1, color: AppColors.border),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(AppSpacing.md),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildBasicInfoSection(),
//               SizedBox(height: AppSpacing.lg),
//               _buildParametersSection(),
//               SizedBox(height: AppSpacing.xl),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBasicInfoSection() {
//     return Container(
//       padding: EdgeInsets.all(AppSpacing.md),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryLight,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   Icons.info_outline,
//                   color: AppColors.primary,
//                   size: 18,
//                 ),
//               ),
//               SizedBox(width: AppSpacing.sm),
//               Text(
//                 'Informasi Dasar',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: AppSpacing.md),
//           _buildTextField(
//             controller: _nameController,
//             label: 'Nama Preset',
//             hint: 'Contoh: Lele Kolam Terpal',
//             icon: Icons.label_outline,
//             required: true,
//           ),
//           SizedBox(height: AppSpacing.md),
//           _buildTextField(
//             controller: _commodityController,
//             label: 'Komoditas',
//             hint: 'Contoh: Lele',
//             icon: Icons.pets_outlined,
//             required: true,
//           ),
//           SizedBox(height: AppSpacing.md),
//           _buildTextField(
//             controller: _descriptionController,
//             label: 'Deskripsi (Opsional)',
//             hint: 'Deskripsi singkat tentang preset ini',
//             icon: Icons.description_outlined,
//             maxLines: 3,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildParametersSection() {
//     return Container(
//       padding: EdgeInsets.all(AppSpacing.md),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryLight,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(Icons.tune, color: AppColors.primary, size: 18),
//               ),
//               SizedBox(width: AppSpacing.sm),
//               Expanded(
//                 child: Text(
//                   'Parameter Kualitas Air',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: AppSpacing.sm,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: AppColors.background,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: AppColors.border),
//                 ),
//                 child: Text(
//                   '${_parameters.length} parameter',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textMuted,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: AppSpacing.md),
//           if (_parameters.isEmpty)
//             _buildEmptyParametersState()
//           else
//             ..._buildParameterCards(),
//           SizedBox(height: AppSpacing.md),
//           _buildAddParameterButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyParametersState() {
//     return Container(
//       padding: EdgeInsets.all(AppSpacing.lg),
//       decoration: BoxDecoration(
//         color: AppColors.background,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border, style: BorderStyle.solid),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.science_outlined, size: 48, color: AppColors.textMuted),
//           SizedBox(height: AppSpacing.sm),
//           Text(
//             'Belum ada parameter',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textSecondary,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             'Tambahkan parameter kualitas air',
//             style: TextStyle(fontSize: 13, color: AppColors.textMuted),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildParameterCards() {
//     return _parameters.asMap().entries.map((entry) {
//       final index = entry.key;
//       final param = entry.value;

//       return Container(
//         margin: EdgeInsets.only(bottom: AppSpacing.sm),
//         padding: EdgeInsets.all(AppSpacing.md),
//         decoration: BoxDecoration(
//           color: AppColors.background,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: AppColors.border),
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     value: param.name.isEmpty ? null : param.name,
//                     decoration: InputDecoration(
//                       labelText: 'Parameter',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: AppSpacing.sm,
//                         vertical: AppSpacing.sm,
//                       ),
//                     ),
//                     items: ['pH', 'Suhu', 'Amonia', 'Oksigen', 'Salinitas']
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         _updateParameter(index, param.copyWith(name: value));
//                       }
//                     },
//                   ),
//                 ),
//                 SizedBox(width: AppSpacing.sm),
//                 IconButton(
//                   onPressed: () => _removeParameter(param.id),
//                   icon: Icon(Icons.delete_outline, color: AppColors.error),
//                   style: IconButton.styleFrom(
//                     backgroundColor: AppColors.error.withOpacity(0.1),
//                     foregroundColor: AppColors.error,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSpacing.sm),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildNumericField(
//                     label: 'Nilai Min',
//                     initialValue: param.min,
//                     onChanged: (val) =>
//                         _updateParameter(index, param.copyWith(min: val)),
//                   ),
//                 ),
//                 SizedBox(width: AppSpacing.sm),
//                 Expanded(
//                   child: _buildNumericField(
//                     label: 'Nilai Max',
//                     initialValue: param.max,
//                     onChanged: (val) =>
//                         _updateParameter(index, param.copyWith(max: val)),
//                   ),
//                 ),
//                 SizedBox(width: AppSpacing.sm),
//                 Expanded(
//                   child: _buildUnitField(
//                     initialValue: param.unit,
//                     onChanged: (val) =>
//                         _updateParameter(index, param.copyWith(unit: val)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }

//   Widget _buildAddParameterButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: OutlinedButton.icon(
//         onPressed: _addParameter,
//         icon: Icon(Icons.add, size: 18),
//         label: Text('Tambah Parameter'),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           side: BorderSide(color: AppColors.primary),
//           padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
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
//     bool required = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: Icon(icon, size: 20),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: AppColors.primary, width: 2),
//         ),
//         filled: true,
//         fillColor: AppColors.surface,
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: AppSpacing.md,
//           vertical: AppSpacing.sm,
//         ),
//       ),
//       validator: required
//           ? (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return '$label tidak boleh kosong';
//               }
//               return null;
//             }
//           : null,
//     );
//   }

//   Widget _buildNumericField({
//     required String label,
//     required double initialValue,
//     required ValueChanged<double> onChanged,
//   }) {
//     return TextFormField(
//       initialValue: initialValue == 0 ? '' : initialValue.toString(),
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: AppSpacing.sm,
//           vertical: AppSpacing.sm,
//         ),
//       ),
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       onChanged: (value) => onChanged(double.tryParse(value) ?? 0),
//     );
//   }

//   Widget _buildUnitField({
//     required String initialValue,
//     required ValueChanged<String> onChanged,
//   }) {
//     return TextFormField(
//       initialValue: initialValue,
//       decoration: InputDecoration(
//         labelText: 'Satuan',
//         hintText: '°C, mg/L',
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: AppSpacing.sm,
//           vertical: AppSpacing.sm,
//         ),
//       ),
//       onChanged: onChanged,
//     );
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
// }
