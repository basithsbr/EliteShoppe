import 'package:flutter/material.dart';
import 'package:booktrip_app/imageplay_card.dart';
import 'package:booktrip_app/card_grid_small.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, String> selectedItem;
  final String deviceType;
  final VoidCallback onBackTap;
  const ProductDetails({
    super.key,
    required this.deviceType,
    required this.selectedItem,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/eye_glass_1.jpg',
      'assets/eye_glass_2.jpg',
      'assets/eye_glass_3.jpg',
      'assets/eye_glass_4.jpg',
      'assets/eye_glass_5.jpg',
      'assets/videos/eye_glass_vid1.mp4',
    ];

    final List<String> sizes = ["S", "M", "L", "XL", "XXL", "XXXL"];
    // final List<String> sizes = ["S", "M", "L", "XL"];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Container(
                  color: Colors.blue.shade100, // Background color

                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    // Adds space around the icon
                    onPressed:
                        onBackTap, // Add your function trigger handle here
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    selectedItem['title']!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            // crossAxisAlignment: CrossAxisAlignment.start,
            padding: const EdgeInsets.all(0),
            child: Container(
              color: const Color.fromARGB(255, 245, 245, 245),
              // padding: EdgeInsets.all(10),
              // height: 200,
              // color: Colors.amber,
              width: double.infinity,
              child: ProductCarousel(imgList: imgList),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(0),
            // height: double.infinity,
            child: Card(
              color: Colors.white,
              elevation: 3,
              shadowColor: Colors.white, // Disables the shadow line artifact
              surfaceTintColor: Colors
                  .transparent, // Prevents Material 3 from overlaying a tint border
              shape: RoundedRectangleBorder(
                // side: BorderSide.none,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Container(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(25),
                      // height: 50,
                      alignment: Alignment.center,
                      child: const Text("Size"),
                    ),
                    // const VerticalDivider(thickness: 0.5, width: 0.5),
                    // SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Wrap(
                          spacing:
                              10, // Horizontal space between the size pills
                          runSpacing: 10,
                          children: List.generate(sizes.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ), // Adds spacing between items
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      233,
                                      232,
                                      232,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                // height: 50,
                                child: IntrinsicWidth(
                                  child: Center(
                                    child: Text(
                                      sizes[index],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          CardGridSmall(deviceType: deviceType, item: selectedItem),
          Align(
            alignment: Alignment.centerLeft,

            child: Card(
              color: Colors.white,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    // color: Colors.,
                    child: Text(
                      "Product Description",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(left: 40, bottom: 20),
                    child: Text(
                      "Light weight sunglass with clear cut view with perfect focus",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.only(
                left: 10,
                top: 10,
                right: 10,
                bottom: 10,
              ),

              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
