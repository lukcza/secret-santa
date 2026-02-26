import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class ActiveExchangesCard extends StatelessWidget {
  const ActiveExchangesCard({super.key, required this.countActiveExchanges});
  final int countActiveExchanges;
  @override
  Widget build(BuildContext context) {
    //TODO: get real value for drawing time and unit
    var drawingTimeValue = '0';
    var drawingTimeUnit = context.loc.days;
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
                right: -35,
                top: -30,
                child: Transform.rotate(
                  angle: -0.5,
                  child: Icon(
                    Icons.ac_unit,
                    size: 150,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(context.loc.season.toUpperCase() + ' ${DateTime.now().year}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${countActiveExchanges} ${context.loc.activeExchanges}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          drawingTimeValue != 0 ? context.loc.drawingIn + ' ' + drawingTimeValue + ' ' + drawingTimeUnit + '.' : '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}