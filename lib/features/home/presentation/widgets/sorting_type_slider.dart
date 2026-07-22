import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class SortingTypeSlider extends StatefulWidget {
  const SortingTypeSlider({super.key, this.onCategorySelected});

  final ValueChanged<int>? onCategorySelected;

  @override
  State<SortingTypeSlider> createState() => _SortingTypeSliderState();
}

class _SortingTypeSliderState extends State<SortingTypeSlider> {
  int selectedIndex = 0;
  final List<GlobalKey> _itemKeys = [];

  void _scrollToItem(int index) {
    if (index >= 0 && index < _itemKeys.length) {
      final keyContext = _itemKeys[index].currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5, // Centers the selected option in the list view
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      context.loc.allGroup,
      context.loc.drawingSoon,
      context.loc.completed,
    ];

    // Ensure we have a key for each item
    if (_itemKeys.length != categories.length) {
      _itemKeys.clear();
      _itemKeys.addAll(List.generate(categories.length, (_) => GlobalKey()));
    }

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            key: _itemKeys[index],
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onCategorySelected?.call(index);
              _scrollToItem(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2E7D32) : const Color(0xFF112217),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : Colors.white.withOpacity(0.08),
                  width: 1.5,
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}