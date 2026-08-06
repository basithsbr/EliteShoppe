import 'package:booktrip_app/product_details.dart';
import 'package:booktrip_app/product_search.dart';
import 'package:flutter/material.dart';
import 'package:booktrip_app/product_category.dart';

class ProductWrapper extends StatefulWidget {
  final String deviceType;

  const ProductWrapper({super.key, required this.deviceType});

  @override
  State<ProductWrapper> createState() => _ProductWrapperState();
}

class _ProductWrapperState extends State<ProductWrapper> {
  // FIX 1: Keep track of the inner product search state here
  String screenName = "product_category";
  late Map<String, String> selectedItem;

  @override
  void initState() {
    super.initState();
    screenName = "product_category";
  }

  @override
  Widget build(BuildContext context) {
    if (screenName == "product_category") {
      return ProductCategory(
        deviceType: widget.deviceType,
        callBackProductWrapper: (screen) {
          setState(() {
            screenName = screen; // Show search on card tap
          });
        },
      );
    }
    if (screenName == "product_search") {
      return ProductSearch(
        deviceType: widget.deviceType,
        callBackProductWrapper: (screen, item) {
          setState(() {
            screenName = screen; // Show search on card tap
            selectedItem = item;
          });
        },
      );
    }
    if (screenName == "product_details") {
      return ProductDetails(
        deviceType: widget.deviceType,
        selectedItem: selectedItem,
        onBackTap: () {
          setState(() {
            screenName = "product_search"; // Show search on card tap
          });
        },
      );
    }
    return Column();
  }
}
