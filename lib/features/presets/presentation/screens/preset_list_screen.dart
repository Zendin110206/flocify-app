// lib/features/presets/presentation/screens/preset_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// Pastikan path impor ini sudah benar sesuai struktur proyek Anda
import 'package:proyek_flocify/features/presets/presentation/screens/preset_editor_screen.dart';
import 'package:proyek_flocify/features/presets/presentation/widgets/preset_card.dart';
import 'package:proyek_flocify/features/presets/presentation/widgets/section_header.dart';

const double _kAppBarHeight = 72.0;

// =========================================================================
// --- TEMA TERPUSAT (GABUNGAN TERBAIK DARI FILE A & B) ---
// =========================================================================

class AppColors {
  static const primary = Color(0xFF2563EB);
  static const primaryLight = Color(0xFFEFF6FF);
  static const success = Color(0xFF16A34A);
  static const successLight = Color(0xFFF0FDF4);
  static const warning = Color(0xFFEAB308);
  static const danger = Color(0xFFDC2626);
  static const background = Color(0xFFFAFAFA);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  // [FIXED] Menambahkan kembali textMuted yang hilang
  static const textMuted = Color(0xFF9CA3AF);
  static const textTertiary = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);
  static const shadow = Color(0x0A000000);

  static const Color appBarSurface = Color(0xFF638ECB);
  static const Color textOnDark = Colors.white;
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
}

// =========================================================================
// --- MODELS (Struktur Data) ---
// =========================================================================

enum PresetCreator { flocify, user }

class PresetParameter {
  final String id;
  final String name;
  final double min;
  final double max;
  final String unit;

  PresetParameter({
    required this.id,
    required this.name,
    required this.min,
    required this.max,
    required this.unit,
  });

  PresetParameter copyWith({
    String? id,
    String? name,
    double? min,
    double? max,
    String? unit,
  }) {
    return PresetParameter(
      id: id ?? this.id,
      name: name ?? this.name,
      min: min ?? this.min,
      max: max ?? this.max,
      unit: unit ?? this.unit,
    );
  }
}

class Preset {
  final String id;
  final String name;
  final String commodity;
  final PresetCreator creator;
  final String? description;
  final List<PresetParameter> parameters;

  const Preset({
    required this.id,
    required this.name,
    required this.commodity,
    required this.creator,
    this.description,
    this.parameters = const [],
  });
}

// =========================================================================
// --- REPOSITORY & STATE MANAGEMENT (LOGIKA LENGKAP) ---
// =========================================================================

class FakePresetRepository {
  final _uuid = const Uuid();
  final List<Preset> _presets = [
    Preset(
      id: 'flc_preset_1',
      name: 'Lele Pembesaran',
      commodity: 'Lele',
      creator: PresetCreator.flocify,
      description: 'Standar budidaya lele dari benih hingga panen',
      parameters: [
        PresetParameter(id: 'p1', name: 'pH', min: 6.5, max: 7.5, unit: ''),
        PresetParameter(id: 'p2', name: 'Suhu', min: 26, max: 30, unit: '°C'),
        PresetParameter(
          id: 'p3',
          name: 'Amonia',
          min: 0,
          max: 0.1,
          unit: 'mg/L',
        ),
      ],
    ),
    Preset(
      id: 'flc_preset_2',
      name: 'Udang Vaname',
      commodity: 'Udang Vaname',
      creator: PresetCreator.flocify,
      description: 'Optimal untuk sistem bioflok salinitas rendah',
      parameters: [
        PresetParameter(id: 'p4', name: 'pH', min: 7.8, max: 8.5, unit: ''),
        PresetParameter(id: 'p5', name: 'Suhu', min: 28, max: 32, unit: '°C'),
      ],
    ),
    Preset(
      id: 'user_preset_1',
      name: 'Nila Kolam Terpal',
      commodity: 'Nila',
      creator: PresetCreator.user,
      description: 'Kolam terpal di halaman belakang',
      parameters: [
        PresetParameter(id: 'p6', name: 'pH', min: 7.0, max: 8.0, unit: ''),
      ],
    ),
  ];

  Future<List<Preset>> getPresets() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_presets);
  }

  Future<void> addPreset(Preset preset) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final presetWithId = Preset(
      id: preset.id.startsWith('user_') ? preset.id : 'user_${_uuid.v4()}',
      name: preset.name,
      commodity: preset.commodity,
      creator: PresetCreator.user,
      description: preset.description,
      parameters: preset.parameters,
    );
    _presets.add(presetWithId);
  }

  Future<void> updatePreset(Preset preset) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _presets.indexWhere((p) => p.id == preset.id);
    if (index != -1) {
      _presets[index] = preset;
    }
  }

  Future<void> deletePreset(String presetId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _presets.removeWhere((p) => p.id == presetId);
  }
}

final presetRepositoryProvider = Provider<FakePresetRepository>((ref) {
  return FakePresetRepository();
});

class PresetListNotifier extends StateNotifier<AsyncValue<List<Preset>>> {
  final FakePresetRepository _repository;

  PresetListNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchPresets();
  }

  Future<void> fetchPresets() async {
    state = const AsyncValue.loading();
    try {
      final presets = await _repository.getPresets();
      state = AsyncValue.data(presets);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> addPreset(Preset preset) async {
    try {
      await _repository.addPreset(preset);
      await fetchPresets();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> updatePreset(Preset preset) async {
    try {
      await _repository.updatePreset(preset);
      await fetchPresets();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> deletePreset(String presetId) async {
    try {
      await _repository.deletePreset(presetId);
      await fetchPresets();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final presetListProvider =
    StateNotifierProvider.autoDispose<
      PresetListNotifier,
      AsyncValue<List<Preset>>
    >((ref) {
      final repository = ref.watch(presetRepositoryProvider);
      return PresetListNotifier(repository);
    });

// =========================================================================
// --- MAIN SCREEN ---
// =========================================================================

class PresetListScreen extends ConsumerWidget {
  const PresetListScreen({super.key});

  void _showPresetEditor(BuildContext context, {Preset? existingPreset}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        // NOTE: This assumes your PresetEditorScreen constructor is:
        // const PresetEditorScreen({super.key, this.preset});
        builder: (context) => PresetEditorScreen(preset: existingPreset),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetsAsyncValue = ref.watch(presetListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        bottom: true,
        child: presetsAsyncValue.when(
          loading: () => const _LoadingState(),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (presets) {
            if (presets.isEmpty) {
              return _EmptyState(onAdd: () => _showPresetEditor(context));
            }
            final userPresets = presets
                .where((p) => p.creator == PresetCreator.user)
                .toList();
            final flocifyPresets = presets
                .where((p) => p.creator == PresetCreator.flocify)
                .toList();

            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(presetListProvider.notifier).fetchPresets(),
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  80.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Preset Saya',
                      subtitle: userPresets.isEmpty
                          ? 'Belum ada preset'
                          : '${userPresets.length} preset',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (userPresets.isEmpty)
                      const _EmptyUserPresetCard()
                    else
                      ...userPresets.map(
                        (preset) => PresetCard(
                          preset: preset,
                          onTap: () => _showPresetEditor(
                            context,
                            existingPreset: preset,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    SectionHeader(
                      title: 'Rekomendasi Flocify',
                      subtitle: '${flocifyPresets.length} preset tersedia',
                      icon: Icons.verified_outlined,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...flocifyPresets.map(
                      (preset) => PresetCard(
                        preset: preset,
                        onTap: () =>
                            _showPresetEditor(context, existingPreset: preset),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: presetsAsyncValue.maybeWhen(
        data: (presets) {
          final bool isVisible = presets.isNotEmpty;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final slideAnimation = Tween<Offset>(
                begin: const Offset(0.0, 0.5),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slideAnimation, child: child),
              );
            },
            child: isVisible
                ? Container(
                    key: const ValueKey('fab_visible'),
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: FloatingActionButton.extended(
                      onPressed: () => _showPresetEditor(context),
                      backgroundColor: AppColors.appBarSurface,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        'Buat Preset Baru',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('fab_hidden')),
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    const int subtitleAlpha = 217;
    const int borderAlpha = 51;

    return AppBar(
      backgroundColor: AppColors.appBarSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: AppColors.textOnDark),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preset Budidaya',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textOnDark,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Kelola pengaturan kualitas air',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textOnDark.withAlpha(subtitleAlpha),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      toolbarHeight: _kAppBarHeight,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: AppColors.textOnDark.withAlpha(borderAlpha),
          height: 1.0,
        ),
      ),
    );
  }
}

// =========================================================================
// --- WIDGET-WIDGET PENDUKUNG ---
// =========================================================================

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    // // [FIXED] Menggunakan MediaQuery untuk menggantikan 'window' yang usang
    // final double bottomInset = MediaQuery.of(context).viewPadding.bottom;
    // final double delta = (_kAppBarHeight - bottomInset) / 2;

    return Center(
      child: Transform.translate(
        offset: Offset(0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Memuat preset...',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.science_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Belum Ada Preset',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Buat preset pertama untuk menyimpan pengaturan parameter kualitas air yang ideal',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Buat Preset Pertama'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyUserPresetCard extends StatelessWidget {
  const _EmptyUserPresetCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        // [FIXED] Menggunakan withAlpha untuk menggantikan withOpacity
        color: AppColors.primaryLight.withAlpha((255 * 0.5).round()),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.primary.withAlpha((255 * 0.2).round()),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 28),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Preset Anda masih kosong',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tekan tombol "Buat Preset Baru" di bawah untuk memulai.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
