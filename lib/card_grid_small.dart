import 'package:flutter/material.dart';

class CardGridSmall extends StatelessWidget {
  final String deviceType;
  final Map<String, String> item;
  const CardGridSmall({
    super.key,
    required this.deviceType,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> productDetails = {
      "Price": "100",
      "Brand": "Tusker",
      "Model": "EliteGen",
      "Category": "Unisex",
    };
    final entries = productDetails.entries.toList();
    return GridView.builder(
      shrinkWrap:
          true, // FIX 2: Allows GridView to live inside a vertical scroll view
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: deviceType == "Mobile"
            ? 2
            : deviceType == "Tablet"
            ? 2
            : 4,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 1.0,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context, index) {
        final entry = entries[index];
        // Wrap the Card inside an InkWell to detect tap interactions
        return Card(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                // You can set a fixed width per item or let it auto-size based on text length
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 0,
                  left: 10,
                  right: 0,
                ),

                alignment: Alignment.topLeft,
                // color: Colors.blueGrey,
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                // You can set a fixed width per item or let it auto-size based on text length
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  left: 40,
                  right: 0,
                ),

                alignment: Alignment.topLeft,
                // color: Colors.blueGrey,
                child: Text(
                  entry.value,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
