//lib/features/price/presentation/widgets/lapak/detail_list.dart
import 'package:flutter/material.dart';

import 'package:proyek_flocify/features/price/presentation/screens/lapak_screen.dart'
    show LapakData;
import 'package:proyek_flocify/features/price/presentation/widgets/lapak/detail_item_card.dart';

class LapakDetailList extends StatelessWidget {
  final List<LapakData> items;

  const LapakDetailList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: items.length,
      itemBuilder: (context, index) => LapakDetailItemCard(item: items[index]),
    );
  }
}
