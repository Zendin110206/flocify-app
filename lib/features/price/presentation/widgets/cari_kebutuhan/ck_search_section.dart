// lib/widgets/cari_kebutuhan/ck_search_section.dart
import 'package:flutter/material.dart';
import 'ck_colors.dart';

class CKSearchSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSearchChanged;

  final String categoryLabel;
  final String locationLabel;
  final String sortLabel;
  final bool urgentOnly;

  final VoidCallback onTapCategory;
  final VoidCallback onTapLocation;
  final VoidCallback onTapSort;
  final VoidCallback onToggleUrgent;

  const CKSearchSection({
    super.key,
    required this.controller,
    required this.onClearSearch,
    required this.onSearchChanged,
    required this.categoryLabel,
    required this.locationLabel,
    required this.sortLabel,
    required this.urgentOnly,
    required this.onTapCategory,
    required this.onTapLocation,
    required this.onTapSort,
    required this.onToggleUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CKColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        children: [
          _SearchBar(
            controller: controller,
            onChanged: onSearchChanged,
            onClear: onClearSearch,
          ),
          const SizedBox(height: 16),
          _ChipsRow(
            categoryLabel: categoryLabel,
            locationLabel: locationLabel,
            sortLabel: sortLabel,
            urgentOnly: urgentOnly,
            onTapCategory: onTapCategory,
            onTapLocation: onTapLocation,
            onTapSort: onTapSort,
            onToggleUrgent: onToggleUrgent,
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CKColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: CKColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Cari produk atau pembeli…',
                hintStyle: TextStyle(color: CKColors.textHint),
                border: InputBorder.none,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: CKColors.textHint),
              onPressed: onClear,
              tooltip: 'Bersihkan',
            ),
        ],
      ),
    );
  }
}

class _ChipsRow extends StatelessWidget {
  final String categoryLabel;
  final String locationLabel;
  final String sortLabel;
  final bool urgentOnly;
  final VoidCallback onTapCategory;
  final VoidCallback onTapLocation;
  final VoidCallback onTapSort;
  final VoidCallback onToggleUrgent;

  const _ChipsRow({
    required this.categoryLabel,
    required this.locationLabel,
    required this.sortLabel,
    required this.urgentOnly,
    required this.onTapCategory,
    required this.onTapLocation,
    required this.onTapSort,
    required this.onToggleUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            icon: Icons.category_outlined,
            label: categoryLabel,
            onTap: onTapCategory,
          ),
          const SizedBox(width: 12),
          _FilterChip(
            icon: Icons.location_on_outlined,
            label: locationLabel,
            onTap: onTapLocation,
          ),
          const SizedBox(width: 12),
          _FilterChip(
            icon: Icons.sort_outlined,
            label: sortLabel,
            onTap: onTapSort,
          ),
          const SizedBox(width: 12),
          _UrgentToggle(active: urgentOnly, onTap: onToggleUrgent),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CKColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: CKColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: CKColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: CKColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: CKColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UrgentToggle extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _UrgentToggle({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final border = active ? CKColors.urgent : CKColors.border;
    final bg = active ? CKColors.urgent.withOpacity(0.08) : CKColors.surface;
    final iconColor = active ? CKColors.urgent : CKColors.textSecondary;
    final textColor = active ? CKColors.urgent : CKColors.textPrimary;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.priority_high, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(
                'Urgent',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
