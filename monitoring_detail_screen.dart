// lib/features/cultivation/presentation/screens/detail/monitoring/monitoring_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

// Enum untuk merepresentasikan status parameter
enum ParameterStatus { optimal, alert, danger }

// Kelas untuk menampung data status yang sudah dihitung
class StatusInfo {
  final ParameterStatus status;
  final Color color;
  final String text;
  final IconData icon;

  StatusInfo(this.status, this.color, this.text, this.icon);
}

// Model untuk data history
class HistoryItem {
  final String value;
  final String dateTime;

  HistoryItem({required this.value, required this.dateTime});
}

// Model untuk merepresentasikan data parameter
class ParameterData {
  final String title;
  final double value;
  final String unit;
  final double minOptimal;
  final double maxOptimal;
  final double absoluteMin;
  final double absoluteMax;
  final List<HistoryItem> history;

  ParameterData({
    required this.title,
    required this.value,
    required this.unit,
    required this.minOptimal,
    required this.maxOptimal,
    required this.absoluteMin,
    required this.absoluteMax,
    required this.history,
  });
}

class MonitoringDetailScreen extends ConsumerStatefulWidget {
  final String pondId;

  const MonitoringDetailScreen({super.key, required this.pondId});

  @override
  ConsumerState<MonitoringDetailScreen> createState() =>
      _MonitoringDetailScreenState();
}

class _MonitoringDetailScreenState
    extends ConsumerState<MonitoringDetailScreen> {
  // State untuk melacak bagian mana yang sedang dipilih
  String _selectedPart = 'do'; // 'do', 'ph', 'amonia', 'suhu'

  // State tambahan untuk animasi transisi
  double _previousPercent = 0.0;
  double _previousValue = 0.0;
  Color _previousColor = const Color(0xFF638ECB);

  @override
  void initState() {
    super.initState();
    // Seed nilai awal untuk baseline animasi
    final initial = _parameterData[_selectedPart]!;
    _previousValue = initial.value;
    _previousPercent = _computePercent(
      initial.value,
      initial.absoluteMin,
      initial.absoluteMax,
    );
    _previousColor = _getStatusInfo(
      value: initial.value,
      minOptimal: initial.minOptimal,
      maxOptimal: initial.maxOptimal,
      absoluteMin: initial.absoluteMin,
      absoluteMax: initial.absoluteMax,
    ).color;
  }

  void _prepareAnimationBeforeSwitch() {
    final current = _parameterData[_selectedPart]!;
    _previousValue = current.value;
    _previousPercent = _computePercent(
      current.value,
      current.absoluteMin,
      current.absoluteMax,
    );
    _previousColor = _getStatusInfo(
      value: current.value,
      minOptimal: current.minOptimal,
      maxOptimal: current.maxOptimal,
      absoluteMin: current.absoluteMin,
      absoluteMax: current.absoluteMax,
    ).color;
  }

  // Data dummy untuk semua parameter
  final Map<String, ParameterData> _parameterData = {
    'do': ParameterData(
      title: "Oksigen (DO)",
      value: 3,
      unit: "mg/L",
      minOptimal: 4.0,
      maxOptimal: 8.0,
      absoluteMin: 2.0,
      absoluteMax: 10.0,
      history: [
        HistoryItem(value: "7 mg/L", dateTime: "20 Juli 2025, 15:30"),
        HistoryItem(value: "6.8 mg/L", dateTime: "20 Juli 2025, 12:30"),
        HistoryItem(value: "7 mg/L", dateTime: "20 Juli 2025, 15:30"),
        HistoryItem(value: "7 mg/L", dateTime: "20 Juli 2025, 15:30"),
        HistoryItem(value: "7 mg/L", dateTime: "20 Juli 2025, 15:30"),
        HistoryItem(value: "7 mg/L", dateTime: "20 Juli 2025, 15:30"),
      ],
    ),
    'ph': ParameterData(
      title: "pH",
      value: 6.5,
      unit: "pH",
      minOptimal: 6.0,
      maxOptimal: 8.0,
      absoluteMin: 4.0,
      absoluteMax: 10.0,
      history: [
        HistoryItem(value: "6.5 pH", dateTime: "20 Juli 2025, 15:35"),
        HistoryItem(value: "6.7 pH", dateTime: "20 Juli 2025, 12:35"),
      ],
    ),
    'amonia': ParameterData(
      title: "Amonia",
      value: 0.8,
      unit: "mg/L",
      minOptimal: 0.0,
      maxOptimal: 1.0,
      absoluteMin: 0.0,
      absoluteMax: 2.0,
      history: [
        HistoryItem(value: "0.8 mg/L", dateTime: "20 Juli 2025, 15:40"),
        HistoryItem(value: "0.5 mg/L", dateTime: "20 Juli 2025, 12:40"),
      ],
    ),
    'suhu': ParameterData(
      title: "Suhu",
      value: 28,
      unit: "°C",
      minOptimal: 26.0,
      maxOptimal: 30.0,
      absoluteMin: 20.0,
      absoluteMax: 35.0,
      history: [
        HistoryItem(value: "28 °C", dateTime: "20 Juli 2025, 15:45"),
        HistoryItem(value: "29 °C", dateTime: "20 Juli 2025, 12:45"),
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    // Ambil data yang relevan berdasarkan `_selectedPart`
    final activeData = _parameterData[_selectedPart]!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildGradientBackground(),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildCircularIndicator(
                    title: activeData.title,
                    value: activeData.value,
                    unit: activeData.unit,
                    minOptimal: activeData.minOptimal,
                    maxOptimal: activeData.maxOptimal,
                    absoluteMin: activeData.absoluteMin,
                    absoluteMax: activeData.absoluteMax,
                  ),
                ),
                const SizedBox(height: 24),
                _buildBottomContent(context, activeData.history),
              ],
            ),
          ),
          _buildBackButton(context),
        ],
      ),
    );
  }

  Widget _buildBottomContent(
    BuildContext context,
    List<HistoryItem> historyData,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSelectPartsSection(context),
            const SizedBox(height: 32),
            _buildHistorySection(context, historyData),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIndicator({
    required String title,
    required double value,
    required String unit,
    required double minOptimal,
    required double maxOptimal,
    required double absoluteMin,
    required double absoluteMax,
  }) {
    final statusInfo = _getStatusInfo(
      value: value,
      minOptimal: minOptimal,
      maxOptimal: maxOptimal,
      absoluteMin: absoluteMin,
      absoluteMax: absoluteMax,
    );
    final cleanPercent = _computePercent(value, absoluteMin, absoluteMax);
    const double strokeWidth = 20.0;

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 265,
          height: 265,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: _previousPercent, end: cleanPercent),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            builder: (context, animatedPercent, _) {
              return TweenAnimationBuilder<Color?>(
                tween: ColorTween(begin: _previousColor, end: statusInfo.color),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
                builder: (context, animatedColor, __) {
                  final Color progressColor = animatedColor ?? statusInfo.color;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(265, 265),
                        painter: _ArcPainter(
                          progressPercent: animatedPercent,
                          progressColor: progressColor,
                          backgroundColor: const Color(0xFFD9D9D9),
                          strokeWidth: strokeWidth,
                        ),
                      ),
                      Container(
                        width: 214,
                        height: 214,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xFF314765), Color(0xFF638ECB)],
                          ),
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                            child: Column(
                              key: ValueKey(_selectedPart),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: _previousValue,
                                    end: value,
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, animatedValue, ___) {
                                    return Text(
                                      animatedValue.toStringAsFixed(
                                        animatedValue % 1 == 0 ? 0 : 1,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 48,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  unit,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Row(
                                    key: ValueKey(statusInfo.status),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        statusInfo.text,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        statusInfo.icon,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 265 - strokeWidth,
                          height: 270 - strokeWidth,
                          child: Transform.rotate(
                            angle:
                                (pi / 180) * (-135 + (270 * animatedPercent)),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: FractionalTranslation(
                                translation: const Offset(0, -0.9),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: progressColor,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Kembali',
        ),
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      height: 298,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF638ECB), Color(0x008AAEE0)],
          stops: [0.1528, 1.0],
        ),
      ),
    );
  }

  Widget _buildSelectPartsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Parts',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPartItem(
              partKey: 'do',
              label: '3d part DO',
              isSelected: _selectedPart == 'do',
              onTap: () {
                _prepareAnimationBeforeSwitch();
                setState(() {
                  _selectedPart = 'do';
                });
              },
            ),
            _buildPartItem(
              partKey: 'ph',
              label: '3d part pH',
              isSelected: _selectedPart == 'ph',
              onTap: () {
                _prepareAnimationBeforeSwitch();
                setState(() {
                  _selectedPart = 'ph';
                });
              },
            ),
            _buildPartItem(
              partKey: 'amonia',
              label: '3d part Amonia',
              isSelected: _selectedPart == 'amonia',
              onTap: () {
                _prepareAnimationBeforeSwitch();
                setState(() {
                  _selectedPart = 'amonia';
                });
              },
            ),
            _buildPartItem(
              partKey: 'suhu',
              label: '3d part Suhu',
              isSelected: _selectedPart == 'suhu',
              onTap: () {
                _prepareAnimationBeforeSwitch();
                setState(() {
                  _selectedPart = 'suhu';
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPartItem({
    required String partKey,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.96,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          splashColor: const Color(0xFF395886).withOpacity(0.2),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF395886) : Colors.transparent,
              border: isSelected
                  ? null
                  : Border.all(color: const Color(0xFFD5DEEF), width: 5),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF395886).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Container(
                width: 49,
                height: 56,
                decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context, List<HistoryItem> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) {
            final offset =
                Tween<Offset>(
                  begin: const Offset(0.0, 0.05),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                );
            return FadeTransition(
              opacity: anim,
              child: SlideTransition(position: offset, child: child),
            );
          },
          child: Column(
            key: ValueKey(_selectedPart),
            children: data.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildHistoryListItem(
                  value: item.value,
                  date: item.dateTime,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryListItem({required String value, required String date}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFB1C9EF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Icon(Icons.waves, color: Color(0xFF395886), size: 32),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progressPercent;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _ArcPainter({
    required this.progressPercent,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    const startAngle = (135 * pi) / 180;
    const sweepAngle = (270 * pi) / 180;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * progressPercent,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// ===== Helper methods for animation & status =====
double _computePercent(double value, double absoluteMin, double absoluteMax) {
  final percent = (value - absoluteMin) / (absoluteMax - absoluteMin);
  return max(0.0, min(1.0, percent));
}

StatusInfo _getStatusInfo({
  required double value,
  required double minOptimal,
  required double maxOptimal,
  required double absoluteMin,
  required double absoluteMax,
}) {
  if (value >= minOptimal && value <= maxOptimal) {
    return StatusInfo(
      ParameterStatus.optimal,
      const Color(0xFF638ECB),
      "Good",
      Icons.check_circle,
    );
  } else if (value < absoluteMin || value > absoluteMax) {
    return StatusInfo(
      ParameterStatus.danger,
      Colors.red,
      "Danger",
      Icons.dangerous,
    );
  } else {
    return StatusInfo(
      ParameterStatus.alert,
      Colors.amber,
      "Alert",
      Icons.warning,
    );
  }
}

// extension removed; using instance method inside the State class instead
