import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class DecisionCard extends StatelessWidget {
  const DecisionCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
    this.cardType = true,
  });
  final String title;
  final String description;
  final String buttonText;
  final bool cardType;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 180,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 40),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        image:
                            cardType
                                ? AssetImage('assets/images/cardBGJoin.png')
                                : AssetImage('assets/images/cardBGCreate.png'),
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      
              Positioned(
                left: 12,
                top: 12,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      cardType
                          ? Theme.of(context).colorScheme.primary
                          : Colors.blueGrey,
                  child: Icon(
                    cardType ? Icons.key : Icons.card_giftcard,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 46,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      buttonText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cardType ? Color(0xFFF87171) : Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: onTap,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: cardType ? Color(0xFFF87171) : Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
