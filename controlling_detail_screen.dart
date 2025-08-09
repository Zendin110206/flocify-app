import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ControllingDetailScreen extends StatefulWidget {
  const ControllingDetailScreen({super.key});

  @override
  State<ControllingDetailScreen> createState() =>
      _ControllingDetailScreenState();
}

class _ControllingDetailScreenState extends State<ControllingDetailScreen> {
  static const Color _primaryBlue = Color(0xFF395886);

  String _selectedPart = 'pakan';

  // Data model
  final Map<String, _ResourceData> _resourceData = {
    'pakan': _ResourceData(
      title: 'Resource',
      used: 7,
      max: 10,
      unit: 'Kg',
      history: [
        _HistoryItem(value: '7 Kg', dateTime: '20 Juli 2025, 15:30'),
        _HistoryItem(value: '6 Kg', dateTime: '20 Juli 2025, 12:20'),
      ],
    ),
    'ph': _ResourceData(
      title: 'Resource',
      used: 4,
      max: 10,
      unit: 'Kg',
      history: [
        _HistoryItem(value: '4 Kg', dateTime: '20 Juli 2025, 15:35'),
        _HistoryItem(value: '3 Kg', dateTime: '20 Juli 2025, 12:15'),
      ],
    ),
    'amonia': _ResourceData(
      title: 'Resource',
      used: 8,
      max: 10,
      unit: 'Kg',
      history: [
        _HistoryItem(value: '8 Kg', dateTime: '20 Juli 2025, 15:40'),
        _HistoryItem(value: '7 Kg', dateTime: '20 Juli 2025, 12:10'),
      ],
    ),
    'suhu': _ResourceData(
      title: 'Resource',
      used: 5,
      max: 12,
      unit: 'Kg',
      history: [
        _HistoryItem(value: '5 Kg', dateTime: '20 Juli 2025, 15:45'),
        _HistoryItem(value: '5 Kg', dateTime: '20 Juli 2025, 12:05'),
      ],
    ),
  };

  // State animasi
  double _previousPercent = 0.0;
  double _previousUsed = 0.0;

  // Settings state
  bool _isAuto = false;
  final List<int> _doseOptions = [2, 3, 4, 5];
  int _doseIndex = 0; // 0 -> 2x, 1 -> 3x, ...
  int _weight = 250;
  String _weightUnit = 'gram';
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final initial = _resourceData[_selectedPart]!;
    _previousPercent = initial.percent;
    _previousUsed = initial.used;
    _weightController = TextEditingController(text: '$_weight');
  }

  void _prepareAnimationBeforeSwitch() {
    final current = _resourceData[_selectedPart]!;
    _previousPercent = current.percent;
    _previousUsed = current.used;
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _resourceData[_selectedPart]!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 298,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF638ECB), Color(0x008AAEE0)],
                stops: [0.1528, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildResourceIndicator(
                    title: active.title,
                    percent: active.percent,
                    used: active.used,
                    maxValue: active.max,
                    unit: active.unit,
                  ),
                ),
                const SizedBox(height: 24),
                _buildBottomContent(context, active.history),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Kembali',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContent(
    BuildContext context,
    List<_HistoryItem> historyData,
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
            const SizedBox(height: 24),
            _buildSettingsSection(context),
            const SizedBox(height: 32),
            _buildHistorySection(context, historyData),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.info_outline, size: 20, color: Colors.black),
            const SizedBox(width: 6),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            _buildModeToggle(),
          ],
        ),
        const SizedBox(height: 16),
        IgnorePointer(
          ignoring: _isAuto,
          child: Opacity(
            opacity: _isAuto ? 0.55 : 1.0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD5DEEF),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pemberian
                  const Text(
                    'Pemberian',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDoseSelector(),
                  const SizedBox(height: 20),
                  // Berat
                  const Text(
                    'Berat',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildWeightInput(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModeToggle() {
    return GestureDetector(
      onTap: () {
        setState(() => _isAuto = !_isAuto);
        if (_isAuto) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Mode otomatis aktif. Pengaturan dikunci oleh AI Flora.',
              ),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 130,
        height: 28,
        decoration: BoxDecoration(
          color: _isAuto ? _primaryBlue : const Color(0xFFB2B2B2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              _isAuto ? 'Auto' : 'Manual',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: _isAuto ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoseSelector() {
    const circleSize = 21.0;
    const connectorHeight = 4.0;
    const activeColor = Color(0xFF638ECB);
    const inactiveColor = Color(0xFFB2B2B2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Row: dot - connector - dot - connector - dot - connector - dot
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < _doseOptions.length; i++) ...[
              // Dot
              GestureDetector(
                onTap: () => setState(() => _doseIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: i <= _doseIndex ? activeColor : inactiveColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Connector segment between current dot and next dot
              if (i < _doseOptions.length - 1)
                Expanded(
                  child: Container(
                    height: connectorHeight,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: i < _doseIndex ? activeColor : inactiveColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        // Labels aligned under each dot using the same spacing pattern
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < _doseOptions.length; i++) ...[
              SizedBox(
                width: circleSize,
                child: const SizedBox.shrink(),
              ),
              if (i < _doseOptions.length - 1)
                const Expanded(child: SizedBox.shrink()),
            ],
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < _doseOptions.length; i++) ...[
              SizedBox(
                width: circleSize,
                child: Center(
                  child: Text(
                    '${_doseOptions[i]}x',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              if (i < _doseOptions.length - 1)
                const Expanded(child: SizedBox.shrink()),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildWeightInput() {
    final bool isFeed = _selectedPart == 'pakan';
    final String displayUnit = isFeed ? _weightUnit : 'mL';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Value box
        Container(
          width: 130,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _weightController,
            enabled: !_isAuto,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: '0',
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              final parsed = int.tryParse(value);
              setState(() {
                _weight = parsed ?? 0;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        // Unit chip
        GestureDetector(
          onTap: isFeed
              ? () {
                  setState(() {
                    _weightUnit = _weightUnit == 'gram' ? 'kg' : 'gram';
                  });
                }
              : null,
          child: Container(
            width: 67,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayUnit,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                if (isFeed) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Colors.black,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResourceIndicator({
    required String title,
    required double percent,
    required double used,
    required double maxValue,
    required String unit,
  }) {
    const double size = 214;
    const double strokeWidth = 16.0;

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
          width: size,
          height: size,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: _previousPercent, end: percent),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            builder: (context, animatedPercent, _) {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // background ring
                  CustomPaint(
                    size: const Size(size, size),
                    painter: _ResourceArcPainter(
                      progressPercent: animatedPercent,
                      progressColor: _primaryBlue,
                      backgroundColor: const Color(0xFFD9D9D9),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                  // center content
                  Container(
                    width: size - 32,
                    height: size - 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          '${(animatedPercent * 100).round()}%',
                          key: ValueKey((animatedPercent * 100).round()),
                          style: const TextStyle(
                            color: _primaryBlue,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // knob tepat di ujung progress
                  Builder(
                    builder: (context) {
                      const double knobSize = 18; // lebih besar
                      final double angleRad =
                          -pi / 2 + (2 * pi * animatedPercent);
                      final double r =
                          size / 2; // titik tengah ketebalan stroke
                      final double cx = (size / 2) + r * cos(angleRad);
                      final double cy = (size / 2) + r * sin(angleRad);
                      return Positioned(
                        left: cx - (knobSize / 2),
                        top: cy - (knobSize / 2),
                        child: Container(
                          width: knobSize,
                          height: knobSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: _primaryBlue, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        // Separator line + stats
        Column(
          children: [
            Opacity(
              opacity: 0.5,
              child: Container(height: 1, width: 254, color: Colors.black),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 254,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Used
                  _buildStat(
                    label: 'Used',
                    valueTweenBegin: _previousUsed,
                    valueTweenEnd: used,
                    unit: unit,
                  ),
                  // Vertical divider
                  Opacity(
                    opacity: 0.5,
                    child: Container(width: 1, height: 32, color: Colors.black),
                  ),
                  // Max
                  _buildStaticStat(label: 'Max', value: maxValue, unit: unit),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStat({
    required String label,
    required double valueTweenBegin,
    required double valueTweenEnd,
    required String unit,
  }) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: valueTweenBegin, end: valueTweenEnd),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, animated, _) => Text(
            '${animated.toStringAsFixed(animated % 1 == 0 ? 0 : 0)} $unit',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStaticStat({
    required String label,
    required double value,
    required String unit,
  }) {
    return Column(
      children: [
        Text(
          '${value.toStringAsFixed(value % 1 == 0 ? 0 : 0)} $unit',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
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
              partKey: 'pakan',
              label: 'Pakan',
              isSelected: _selectedPart == 'pakan',
              onTap: () {
                _prepareAnimationBeforeSwitch();
                setState(() => _selectedPart = 'pakan');
              },
            ),
            _buildPartItem(
              partKey: 'ph',
              label: '3d part pH',
              isSelected: _selectedPart == 'ph',
              onTap: () {
                _prepareAnimationBeforeSwitch();
                setState(() => _selectedPart = 'ph');
              },
            ),
            _buildPartItem(
              partKey: 'amonia',
              label: '3d part Amonia',
              isSelected: _selectedPart == 'amonia',
              onTap: () {
                _prepareAnimationBeforeSwitch();
                setState(() => _selectedPart = 'amonia');
              },
            ),
            _buildPartItem(
              partKey: 'suhu',
              label: '3d part Suhu',
              isSelected: _selectedPart == 'suhu',
              onTap: () {
                _prepareAnimationBeforeSwitch();
                setState(() => _selectedPart = 'suhu');
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
          splashColor: _primaryBlue.withOpacity(0.2),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? _primaryBlue : Colors.transparent,
              border: isSelected
                  ? null
                  : Border.all(color: const Color(0xFFD5DEEF), width: 5),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _primaryBlue.withOpacity(0.3),
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

  Widget _buildHistorySection(BuildContext context, List<_HistoryItem> data) {
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
          const Icon(Icons.tune, color: _primaryBlue, size: 32),
        ],
      ),
    );
  }
}

class _HistoryItem {
  final String value;
  final String dateTime;
  _HistoryItem({required this.value, required this.dateTime});
}

class _ResourceData {
  final String title;
  final double used;
  final double max;
  final String unit;
  final List<_HistoryItem> history;

  const _ResourceData({
    required this.title,
    required this.used,
    required this.max,
    required this.unit,
    required this.history,
  });

  double get percent => max == 0 ? 0.0 : (used / max).clamp(0.0, 1.0);
}

class _ResourceArcPainter extends CustomPainter {
  final double progressPercent; // 0..1
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _ResourceArcPainter({
    required this.progressPercent,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // background full circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // progress arc starting at top (-90 degrees)
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2; // -90 deg
    final sweepAngle = 2 * pi * progressPercent;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
