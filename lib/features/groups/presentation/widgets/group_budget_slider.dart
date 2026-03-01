import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secret_santa/features/groups/presentation/widgets/currency%20_chooser.dart';

class GroupBudgetSlider extends StatefulWidget {
  GroupBudgetSlider({
    super.key,
    required this.minLimitText,
    required this.maxLimitText,
    required this.budget,
    required this.onChanged,
    required this.budgetText,
  });
  String budgetText;
  String minLimitText;
  String maxLimitText;
  late double budget;
  final ValueChanged<double> onChanged;
  @override
  State<GroupBudgetSlider> createState() => _GroupBudgetSliderState();
}

class _GroupBudgetSliderState extends State<GroupBudgetSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.attach_money,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Text(
                    widget.budgetText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.budget.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: CurrencyChooser()),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.minLimitText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 12,
                  elevation: 1,
                ),
                thumbColor: Theme.of(context).colorScheme.tertiary,
                overlayColor: Theme.of(
                  context,
                ).colorScheme.tertiary.withOpacity(0.2),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
              ),
              child: Slider(
                value: widget.budget,
                min: 0,
                max: 1000,
                onChanged: (double value) {
                  setState(() {
                    widget.budget = value;
                  });
                  widget.onChanged(value);
                },
              ),
            ),
            Text(
              widget.maxLimitText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
