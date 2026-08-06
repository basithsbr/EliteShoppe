import 'package:booktrip_app/horizontal_scrolling_card.dart';
import 'package:flutter/material.dart';
import 'package:booktrip_app/imageplay_card.dart';

class HomeScreen extends StatelessWidget {
  final String deviceType;

  const HomeScreen({super.key, required this.deviceType});
  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      '/assets/eye_glass_1.jpeg',
      '/assets/eye_glass_2.jpeg',
      '/assets/eye_glass_3.jpeg',
      '/assets/eye_glass_4.jpeg',
      '/assets/eye_glass_5.jpeg',
      '/assets/videos/eye_glass_vid1.mp4',
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                width: double.infinity,

                color: Colors.white,
                child: Text(
                  'New Updates',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              HorizontalScrollingCard(deviceType: deviceType, items: null),
            ],
          ),

          const SizedBox(height: 10),
          Card(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  color: Colors.white,
                  child: Text(
                    'Top Selling',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 1),
                Container(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    color: const Color.fromARGB(255, 245, 245, 245),
                    // padding: EdgeInsets.all(10),
                    // height: 200,
                    // color: Colors.amber,
                    width: double.infinity,
                    child: ProductCarousel(imgList: imgList),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
