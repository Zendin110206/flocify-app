// lib/screens/home_screen.dart

import 'package:proyek_flocify/features/price/presentation/widgets/home/expert_consultation.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/home/featured_products.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/home/market_insights_section.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/home/price_board_section.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/home/price_header.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/home/promo_banner.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/home/quick_access_section.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/home/success_strories.dart';
import 'package:proyek_flocify/features/price/presentation/widgets/home/tips_berita_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  SystemUiOverlayStyle _statusBarStyle = SystemUiOverlayStyle.light;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double scrollOffset = 100.0;
    if (_scrollController.offset > scrollOffset &&
        _statusBarStyle != SystemUiOverlayStyle.dark) {
      setState(() {
        _statusBarStyle = SystemUiOverlayStyle.dark;
      });
    } else if (_scrollController.offset <= scrollOffset &&
        _statusBarStyle != SystemUiOverlayStyle.light) {
      setState(() {
        _statusBarStyle = SystemUiOverlayStyle.light;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F3FA),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(child: PriceHeader()),
            SliverToBoxAdapter(
              child: Padding(
                // --- PERBAIKAN DI SINI ---
                // Menambah padding bawah agar tidak tertutup navigasi sistem
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 64.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const QuickAccessSection(),
                    const SizedBox(height: 32),
                    const Text(
                      'Banner Promo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF292D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const PromoBanner(),
                    const SizedBox(height: 24),
                    const FeaturedProductsSection(),
                    const SizedBox(height: 32),
                    const Text(
                      'Papan Harga Real-Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF292D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const PriceBoardSection(),
                    const SizedBox(height: 32),
                    const MarketInsightsSection(),
                    const SizedBox(height: 32),
                    const SuccessStoriesSection(),
                    const SizedBox(height: 32),
                    const TipsSection(),
                    const SizedBox(height: 32),
                    const ExpertConsultationSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
