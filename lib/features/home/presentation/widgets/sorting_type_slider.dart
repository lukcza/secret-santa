import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class SortingTypeSlider extends StatefulWidget {
  SortingTypeSlider({super.key});

  @override
  State<SortingTypeSlider> createState() => _SortingTypeSliderState();
}

class _SortingTypeSliderState extends State<SortingTypeSlider> {
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = 0;
  }
  @override
  Widget build(BuildContext context) {
  final listOfSortingCategories = [context.loc.allGroup, context.loc.drawingSoon, context.loc.completed];
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listOfSortingCategories.length,
        itemBuilder: (context, index) =>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => setState(() {
                selectedIndex = index;
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondaryFixed,
                shape: const StadiumBorder(),
              ),
              child: Text(listOfSortingCategories[index]),
            ),
          ),
      ),
    );
  }
}