// E:\flutter_projects\buat_coba_coba_tuh_disini\coba_coba_aja\lib\widgets\price\price_board_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Model data untuk setiap item harga
class PriceData {
  final String commodity;
  final String location;
  final String province;
  final String grade;
  final int currentPrice;
  final int previousPrice;
  final double change;

  PriceData(
    this.commodity,
    this.location,
    this.province,
    this.grade,
    this.currentPrice,
    this.previousPrice,
    this.change,
  );
}

/// Widget untuk menampilkan papan harga real-time dengan filter.
class PriceBoardSection extends StatefulWidget {
  const PriceBoardSection({super.key});

  @override
  State<PriceBoardSection> createState() => _PriceBoardSectionState();
}

class _PriceBoardSectionState extends State<PriceBoardSection>
    with TickerProviderStateMixin {
  late List<PriceData> _allPriceItems;
  late List<PriceData> _filteredPriceItems;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  String? _selectedCommodity;
  String? _selectedProvince;
  bool _showFilters = false;

  // Daftar komoditas dan provinsi untuk filter
  final List<String> _commodities = [
    'Semua',
    'Lele',
    'Nila',
    'Udang',
    'Gurame',
    'Patin',
    'Mas',
    'Bawal',
  ];
  final List<String> _provinces = [
    'Semua',
    'Jawa Barat',
    'Jawa Timur',
    'Jawa Tengah',
    'DKI Jakarta',
    'Banten',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _allPriceItems = _generateMockPrices();
    _filteredPriceItems = _allPriceItems;
    _selectedCommodity = 'Semua';
    _selectedProvince = 'Semua';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
    if (_showFilters) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredPriceItems = _allPriceItems.where((item) {
        bool commodityMatch =
            _selectedCommodity == 'Semua' ||
            item.commodity == _selectedCommodity;
        bool provinceMatch =
            _selectedProvince == 'Semua' || item.province == _selectedProvince;
        return commodityMatch && provinceMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'Update: ${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(DateTime.now())}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 6),
                        const SizedBox(width: 3),
                        Text(
                          'Live',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: _toggleFilters,
                  icon: Icon(
                    Icons.filter_list,
                    color: _showFilters ? Colors.blue[600] : Colors.grey[600],
                    size: 20,
                  ),
                  tooltip: 'Filter',
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _slideAnimation.value,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          'Komoditas',
                          _selectedCommodity,
                          _commodities,
                          (value) {
                            setState(() => _selectedCommodity = value);
                            _applyFilters();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFilterDropdown(
                          'Provinsi',
                          _selectedProvince,
                          _provinces,
                          (value) {
                            setState(() => _selectedProvince = value);
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Menampilkan ${_filteredPriceItems.length} dari ${_allPriceItems.length} data',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_filteredPriceItems.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 36, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak ada data yang sesuai dengan filter',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            // DIUBAH: Menggunakan Container dengan constraints
            Container(
              constraints: const BoxConstraints(
                maxHeight: 250, // Tinggi maksimal untuk sekitar 2 item
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap:
                    true, // Biarkan shrinkWrap agar container bisa lebih kecil jika item sedikit
                itemCount: _filteredPriceItems.length,
                itemBuilder: (context, index) {
                  final price = _filteredPriceItems[index];
                  return _buildPriceItem(price);
                },
              ),
            ),

          const Divider(height: 24, thickness: 1),
          Center(
            child: TextButton(
              onPressed: () {
                // TODO: Navigasi ke halaman detail
                print('Navigasi ke halaman detail...');
              },
              child: Text(
                'Lihat Detail Lengkap',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String title,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF292D32),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items: items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceItem(PriceData price) {
    final isPositiveTrend = price.change >= 0;
    final priceDifference = price.currentPrice - price.previousPrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price.commodity,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF292D32),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      price.location,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      price.grade,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp ${NumberFormat('#,###', 'id_ID').format(price.currentPrice)}/kg',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF292D32),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositiveTrend
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: isPositiveTrend ? Colors.green : Colors.red,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${isPositiveTrend ? '+' : ''}${price.change.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: isPositiveTrend ? Colors.green : Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.history, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Harga 1 minggu lalu: Rp ${NumberFormat('#,###', 'id_ID').format(price.previousPrice)}/kg',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: isPositiveTrend
                        ? Colors.green[100]
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '${isPositiveTrend ? '+' : ''}${NumberFormat('#,###', 'id_ID').format(priceDifference)}',
                    style: TextStyle(
                      color: isPositiveTrend
                          ? Colors.green[700]
                          : Colors.red[700],
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PriceData> _generateMockPrices() {
    return [
      PriceData(
        'Lele',
        'Bandung',
        'Jawa Barat',
        'Konsumsi (8-10/kg)',
        18500,
        18000,
        2.3,
      ),
      PriceData(
        'Nila',
        'Cirebon',
        'Jawa Barat',
        'Konsumsi (6-8/kg)',
        22000,
        22300,
        -1.2,
      ),
      PriceData(
        'Udang',
        'Sidoarjo',
        'Jawa Timur',
        'Grade A',
        85000,
        80500,
        5.7,
      ),
      PriceData(
        'Gurame',
        'Sukabumi',
        'Jawa Barat',
        'Konsumsi (4-6/kg)',
        45000,
        44600,
        0.8,
      ),
      PriceData(
        'Patin',
        'Semarang',
        'Jawa Tengah',
        'Konsumsi (8-10/kg)',
        16500,
        16600,
        -0.5,
      ),
      PriceData(
        'Mas',
        'Bogor',
        'Jawa Barat',
        'Konsumsi (6-8/kg)',
        28000,
        26500,
        5.7,
      ),
      PriceData('Bawal', 'Malang', 'Jawa Timur', 'Grade B', 32000, 33200, -3.6),
      PriceData(
        'Lele',
        'Bekasi',
        'Jawa Barat',
        'Konsumsi (10-12/kg)',
        19500,
        19000,
        2.6,
      ),
      PriceData('Nila', 'Surabaya', 'Jawa Timur', 'Grade A', 25000, 24200, 3.3),
      PriceData('Udang', 'Tangerang', 'Banten', 'Grade B', 78000, 82000, -4.9),
      PriceData(
        'Lele',
        'Depok',
        'Jawa Barat',
        'Konsumsi (8-10/kg)',
        18800,
        18200,
        3.3,
      ),
    ];
  }
}
