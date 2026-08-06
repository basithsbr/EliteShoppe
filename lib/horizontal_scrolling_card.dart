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
            if (index < 4) {
              return Container(
                width: 160, // Fixed width prevents cards from crushing together
                margin: const EdgeInsets.only(right: 2),
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
            } else {
              return Container(
                width: 100, // Fixed width prevents cards from crushing together
                height: 100,
                padding: const EdgeInsets.only(
                  // bottom: 10,
                  // right: 10,
                  // left: 10,
                  // top: 10,
                ),
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apps_outlined,
                              size: 30,
                              color: Colors.grey.shade400,
                            ),
                            Text(
                              "More",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
