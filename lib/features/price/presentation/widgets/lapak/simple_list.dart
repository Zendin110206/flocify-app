// lib/widgets/lapak/simple_list.dart
import 'package:flutter/material.dart';

import 'package:proyek_flocify/features/price/presentation/screens/lapak_screen.dart'
    show LapakData;
import 'package:proyek_flocify/features/price/presentation/widgets/lapak/simple_item_card.dart';

class LapakSimpleList extends StatelessWidget {
  final List<LapakData> items;

  const LapakSimpleList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: items.length,
      itemBuilder: (context, index) => LapakSimpleItemCard(item: items[index]),
    );
  }
}
