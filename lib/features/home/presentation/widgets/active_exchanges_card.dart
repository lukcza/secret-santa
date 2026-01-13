import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';

class ActiveExchangesCard extends StatelessWidget {
  const ActiveExchangesCard({super.key, required this.countActiveExchanges});
  final int countActiveExchanges;
  @override
  Widget build(BuildContext context) {
    var drawingTimeValue = '0';
    var drawingTimeUnit = context.loc.days;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned(
                right: -20,
                top: -20,
                child: Transform.rotate(
                  angle: -0.5,
                  child: Icon(
                    Icons.ac_unit,
                    size: 30,
                    color: Colors.grey.withOpacity(0.1),
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
                        Icons.star_border_outlined,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    Text(context.loc.season.toUpperCase() + ' ${DateTime.now().year}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${countActiveExchanges} ${context.loc.activeExchanges}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            context.loc.noActiveExchanges + ' ' + drawingTimeValue + ' ' + drawingTimeUnit,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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
