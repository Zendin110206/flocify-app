// Path: lib/features/asset_management/tab/pond_creation/presentation/screens/create_pond_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_flocify/features/pond_creation/domain/models/pond_wizard_state.dart';
import 'package:proyek_flocify/features/pond_creation/presentation/widgets/step_1_commodity.dart';
import 'package:proyek_flocify/features/pond_creation/presentation/widgets/step_2_pool_type.dart';
import 'package:proyek_flocify/features/pond_creation/presentation/widgets/step_3_cultivation_plan.dart';
import 'package:proyek_flocify/features/pond_creation/presentation/widgets/step_4_final_details.dart';
import '../providers/create_pond_provider.dart';

// TODO: Tambahkan import untuk setiap halaman wizard

class CreatePondScreen extends ConsumerStatefulWidget {
  const CreatePondScreen({super.key});

  @override
  ConsumerState<CreatePondScreen> createState() => _CreatePondScreenState();
}

class _CreatePondScreenState extends ConsumerState<CreatePondScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Awasi state wizard dari provider
    final wizardState = ref.watch(createPondProvider);
    final wizardController = ref.read(createPondProvider.notifier);

    // Listener untuk mengubah halaman PageView saat state.currentStep berubah
    ref.listen<int>(createPondProvider.select((s) => s.currentStep), (
      prev,
      next,
    ) {
      if (_pageController.hasClients && _pageController.page?.round() != next) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withAlpha((0.05*255).round()),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tambah Kolam Baru',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        bottom: _buildProgressHeader(wizardState),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          // Nanti kita isi dengan widget-widget langkah wizard
          Step1Commodity(),
          Step2PoolType(),
          Step3CultivationPlan(),
          Step4FinalDetails(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(wizardState, wizardController),
    );
  }

  // Helper widget untuk Header Progress
  PreferredSize _buildProgressHeader(PondWizardState state) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Row(
              children: List.generate(state.totalSteps, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < state.totalSteps - 1 ? 8 : 0,
                    ),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= state.currentStep
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Langkah ${state.currentStep + 1} dari ${state.totalSteps}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  '${((state.currentStep + 1) / state.totalSteps * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk Bottom Navigation Bar
  Widget _buildBottomNavBar(
    PondWizardState state,
    CreatePondController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (state.currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Kembali'),
                ),
              ),
            if (state.currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: controller.canProceed()
                    ? (state.currentStep == state.totalSteps - 1
                          ? _finishWizard // Method untuk menyelesaikan
                          : controller.nextStep)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  state.currentStep == state.totalSteps - 1
                      ? 'Selesai'
                      : 'Lanjutkan',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _finishWizard() {
    final state = ref.read(createPondProvider);
    // TODO: Panggil repository untuk menyimpan data kolam ke backend
    print('FINISH WIZARD:');
    print('Nama: ${state.poolName}');
    print('Komoditas: ${state.selectedCommodity}');
    print('Jenis Kolam: ${state.selectedPoolType}');
    print('Rencana: ${state.selectedPlan}');
    print('Perangkat: ${state.selectedDevice}');

    // Tampilkan dialog sukses & kembali ke halaman aset
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kolam Berhasil Ditambahkan'),
        content: const Text('Data kolam baru Anda telah berhasil disimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context)
              ..pop()
              ..pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
