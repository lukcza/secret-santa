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
      height: 70,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 5),
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: listOfSortingCategories.length,
        itemBuilder: (context, index) =>
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10,0, 10),
            child: ElevatedButton(
              onPressed: () => setState(() {
                selectedIndex = index;
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedIndex == index
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondaryFixed,
                shape: const StadiumBorder(),
                minimumSize: Size.zero
              ),
              child: Text(
                listOfSortingCategories[index],
                style: TextStyle(
                  fontSize: 15,
                  color: selectedIndex == index
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
                ),
            ),
          ),
      ),
      )
    );
  }
}