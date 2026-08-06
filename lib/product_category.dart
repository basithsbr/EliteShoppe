import 'package:flutter/material.dart';

class ProductCategory extends StatelessWidget {
  final String deviceType;
  final Function(String) callBackProductWrapper;

  ProductCategory({
    super.key,
    required this.deviceType,
    required this.callBackProductWrapper,
  });
  final List<Map<String, String>> products = [
    {'title': 'School Bag', 'image': 'assets/bag2.png'},
    {'title': 'Wrist Watch', 'image': 'assets/bag1.jpg'},
    {'title': 'Ladies Bag', 'image': 'assets/bag2.png'},
    {'title': 'Wallets', 'image': 'assets/bag1.jpg'},
    {'title': 'Cosmetics', 'image': 'assets/bag2.png'},
    {'title': 'Kids wear', 'image': 'assets/bag1.jpg'},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child: _productListSummary(deviceType: deviceType)),
        Expanded(child: _cardcontents(deviceType: deviceType)),
      ],
    );
  }

  Widget _productListSummary({required String deviceType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: const Color.fromARGB(255, 240, 241, 243),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          // color: Colors.amber,
          child: Text(
            "Categories",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            textAlign: TextAlign.left,
          ),
        ),

        SizedBox(height: 15),
      ],
    );
  }

  Widget _cardcontents({required String deviceType}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: deviceType == "Mobile"
            ? 2
            : deviceType == "Tablet"
            ? 2
            : 4,
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final item = products[index];

        // Wrap the Card inside an InkWell to detect tap interactions
        return InkWell(
          onTap: () => callBackProductWrapper("product_search"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                // flex: 3,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 3,
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide.none, // Explicitly removes the outline
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // Keeps rounded corners
                  ),
                  child: Column(
                    // height: 300,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          // height: 10,
                          // color: Colors.amber,
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.fitHeight,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        // You can set a fixed width per item or let it auto-size based on text length
                        // padding: const EdgeInsets.only(
                        //   top: 0,
                        //   bottom: 25,
                        //   left: 10,
                        //   right: 10,
                        // ),

                        // alignment: Alignment.center,
                        // color: Colors.blueGrey,
                        child: Text(
                          item['title']!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
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
