import 'package:flutter/material.dart';
import 'package:booktrip_app/videoplay_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductCarousel extends StatefulWidget {
  final List<String> _imgList;
  const ProductCarousel({super.key, required this._imgList});

  @override
  State<ProductCarousel> createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  // Track the active index for the dot indicators
  int _currentIndex = 0;

  // Mock list of e-commerce product image URLs

  @override
  Widget build(BuildContext context) {
    List<String> imgList = widget._imgList;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. The Main Carousel Slider
        CarouselSlider.builder(
          itemCount: imgList.length,
          itemBuilder: (context, index, realIndex) {
            final url = imgList[index];

            final isVideoUrl =
                url.toLowerCase().endsWith('.mp4') ||
                url.toLowerCase().endsWith('.mov');
            if (isVideoUrl) {
              return VideoPlayerCard(videoUrl: url);
            } else {
              return _buildImageCard(url);
            }
          },
          options: CarouselOptions(
            height: 350.0,

            // autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 4),
            viewportFraction: 0.90,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 12),

        // 2. Interactive Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return AnimatedContainer(
              // padding: const EdgeInsets.all(20),
              duration: const Duration(milliseconds: 200),
              width: _currentIndex == entry.key ? 18.0 : 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: _currentIndex == entry.key
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper method to build each individual product slide
  Widget _buildImageCard(String imageUrl) {
    return Container(
      // color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      // height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          // height: 400,
          // Built-in loading placeholder performance fix
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey.shade100,
              child: const Center(child: CircularProgressIndicator.adaptive()),
            );
          },
        ),
      ),
    );
  }
}
