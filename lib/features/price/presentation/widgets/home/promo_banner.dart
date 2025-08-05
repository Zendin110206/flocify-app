// E:\flutter_projects\buat_coba_coba_tuh_disini\coba_coba_aja\lib\widgets\price\promo_banner.dart

import 'package:flutter/material.dart';
import 'dart:async';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<PromoData> _promos = [
    PromoData(
      title: 'Diskon 20%',
      subtitle: 'Bibit Lele Unggulan',
      description: 'Dapatkan bibit lele berkualitas dengan harga terbaik',
      gradientColors: [const Color(0xFF56CCF2), const Color(0xFF2F80ED)],
      icon: '🐟',
      actionText: 'Beli Sekarang',
    ),
    PromoData(
      title: 'Gratis Ongkir',
      subtitle: 'Pakan Udang Premium',
      description: 'Pembelian minimal Rp 500.000',
      gradientColors: [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)],
      icon: '🦐',
      actionText: 'Lihat Produk',
    ),
    PromoData(
      title: 'Cashback 15%',
      subtitle: 'Obat Ikan Herbal',
      description: 'Berlaku untuk semua jenis obat ikan',
      gradientColors: [const Color(0xFFA8E6CF), const Color(0xFF26A69A)],
      icon: '💊',
      actionText: 'Dapatkan Cashback',
    ),
    PromoData(
      title: 'Bundle Hemat',
      subtitle: 'Paket Lengkap Budidaya',
      description: 'Hemat 30% untuk paket komplit',
      gradientColors: [const Color(0xFFFFD93D), const Color(0xFFFF6B35)],
      icon: '📦',
      actionText: 'Lihat Paket',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _promos.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onPromoTap(int index) {
    // Handle promo tap - navigate to product page or show details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka ${_promos[index].title}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _promos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onPromoTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(
                      horizontal: _currentPage == index ? 6 : 8,
                      vertical: _currentPage == index ? 0 : 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _promos[index].gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Background pattern
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withAlpha(
                                  (0.1 * 255).round(),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -40,
                            bottom: -40,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withAlpha(
                                  (0.1 * 255).round(),
                                ),
                              ),
                            ),
                          ),

                          // Content
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  // ==== BAGIAN YANG DIPERBAIKI DIMULAI DI SINI ====
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(
                                              (0.2 * 255).round(),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            _promos[index].title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _promos[index].subtitle,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _promos[index].description,
                                          style: TextStyle(
                                            color: Colors.white.withAlpha(
                                              (0.9 * 255).round(),
                                            ),
                                            fontSize: 13,
                                            height: 1.3,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            child: Text(
                                              _promos[index].actionText,
                                              style: TextStyle(
                                                color: _promos[index]
                                                    .gradientColors[1],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // ==== BAGIAN YANG DIPERBAIKI SELESAI DI SINI ====
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(
                                        (0.2 * 255).round(),
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.white.withAlpha(
                                          (0.3 * 255).round(),
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _promos[index].icon,
                                        style: const TextStyle(fontSize: 26),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Shine effect
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withAlpha((0.1 * 255).round()),
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.white.withAlpha(
                                      (0.05 * 255).round(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Enhanced page indicators with modern design
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _promos.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? _promos[index].gradientColors[0]
                            : Colors.grey.withAlpha((0.3 * 255).round()),
                        boxShadow: _currentPage == index
                            ? [
                                BoxShadow(
                                  color: _promos[index].gradientColors[0]
                                      .withAlpha((0.3 * 255).round()),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PromoData {
  final String title;
  final String subtitle;
  final String description;
  final List<Color> gradientColors;
  final String icon;
  final String actionText;

  PromoData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradientColors,
    required this.icon,
    required this.actionText,
  });
}
