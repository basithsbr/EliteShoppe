import 'package:flutter/material.dart';

class HorizontalScrollingCard extends StatelessWidget {
  final List<Map<String, String>>? items;
  final String deviceType;

  const HorizontalScrollingCard({
    super.key,
    required this.deviceType,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enables horizontal swiping
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: List.generate(5, (index) {
            return Container(
              width: 160, // Fixed width prevents cards from crushing together
              margin: const EdgeInsets.only(right: 12),
              child: Card(
                color: Colors.white,
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mock Image Area
                    Container(
                      height: 150,
                      color: Colors.grey.shade200,
                      width: double.infinity,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Product Item $index",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
