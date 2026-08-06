import 'package:flutter/material.dart';

class ProductSearch extends StatefulWidget {
  final String deviceType;
  final Function(String screenName, Map<String, String> item)
  callBackProductWrapper;
  const ProductSearch({
    super.key,
    required this.deviceType,
    required this.callBackProductWrapper,
  });

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  bool _isFilterPanelOpen = false;
  String? _selectedValue = 'asc';
  final List<Map<String, String>> products = [
    {'title': 'School Bag', 'price': '1100', 'image': 'assets/bag2.png'},
    {'title': 'School Bag', 'price': '1000', 'image': 'assets/bag1.jpg'},
    {'title': 'School Bag', 'price': '100', 'image': 'assets/bag2.png'},
    {'title': 'School Bag', 'price': '100', 'image': 'assets/bag1.jpg'},
    {'title': 'School Bag', 'price': '100', 'image': 'assets/bag2.png'},
    {'title': 'School Bag', 'price': '1000', 'image': 'assets/bag1.jpg'},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Your layout components
        _filterDrawer(isMobile: widget.deviceType == "Mobile" ? true : false),

        if (_isFilterPanelOpen)
          _filterProducts(
            isMobile: widget.deviceType == "Mobile" ? true : false,
          ),

        // Expands comfortably to claim all remaining empty screen space
        Expanded(child: _cardcontents(deviceType: widget.deviceType)),
      ],
    );
  }

  Widget _buildAppDrawer({bool isPermanent = false}) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (!isPermanent)
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Navigation Menu',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        if (isPermanent) const SizedBox(height: 24.0),
        ListTile(
          leading: const Icon(Icons.dashboard_customize),
          title: const Text('System Core'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.layers),
          title: const Text('Integrations'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Access Control'),
          onTap: () {},
        ),
      ],
    );
  }

  // --- CONTENT BUILDER MODULE ---
  Widget _buildMainContent({required bool isMobile}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              isMobile
                  ? const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.black87,
                      ),
                    )
                  : Expanded(
                      flex: 1,
                      child: const Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
              isMobile
                  ? const SizedBox(height: 8.0)
                  : const SizedBox(width: 1.0),
              isMobile
                  ? _buildAdaptiveDropdown()
                  : Expanded(flex: 3, child: _buildAdaptiveDropdown()),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              isMobile
                  ? const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.black87,
                      ),
                    )
                  : Expanded(
                      flex: 1,
                      child: const Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.0,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
              isMobile
                  ? const SizedBox(height: 8.0)
                  : const SizedBox(width: 1.0),
              isMobile
                  ? _buildAdaptiveDropdown()
                  : Expanded(flex: 3, child: _buildAdaptiveDropdown()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterProducts({required bool isMobile}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: double.infinity, // Sets the fixed width
        // height: 350, // Sets the fixed height
        decoration: BoxDecoration(
          color: Colors
              .white, // Background color must go inside decoration if used
          borderRadius: BorderRadius.circular(
            4,
          ), // Optional: rounds the corners
          border: Border.all(
            color: const Color.fromARGB(255, 244, 236, 236),
            width: 2.0, // Border thickness line width
          ),
        ),
        child: Wrap(
          spacing: 10.0, // Horizontal space between the cards/items
          runSpacing: 0.0, // Vertical space between the wrapped rows
          alignment: WrapAlignment.start, // Align items to the left edge

          children: [
            _searchByProdId(isMobile: isMobile),
            _priceRangeMinMax(isMobile: isMobile),
            _orderByPrice(isMobile: isMobile),
            _submitButton(isMobile: isMobile),
          ],
        ),
      ),
    );
  }

  Widget _submitButton({required bool isMobile}) {
    return Container(
      width: 350, // Automatically fills the available horizontal width
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.end, // Left-aligns the text label
        children: [
          // 1. THE FIELD LABEL
          const SizedBox(
            height: 8,
          ), // Clean spacing gap between label and text box
          // 2. THE TEXT BOX FIELD
          SizedBox(
            width: 100.0, // Fixed width
            height: 50.0, // Fixed height

            child: Align(
              // alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Rounded corners
                    side: const BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.white, // Border color
                      width: 2.0, // Border thickness
                    ),
                  ),
                ),
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ),
          ),
          SizedBox(
            width: 100.0, // Fixed width
            height: 50.0, // Fixed height

            child: Align(
              // alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Rounded corners

                    side: const BorderSide(
                      color: Colors.white, // Border color
                      width: 2.0, // Border thickness
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isFilterPanelOpen = false;
                  });
                },
                child: const Text('Close'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderByPrice({required bool isMobile}) {
    return Container(
      width: 350, // Automatically fills the available horizontal width
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Left-aligns the text label
        children: [
          // 1. THE FIELD LABEL
          const Text(
            'Sort Pric',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(
            height: 8,
          ), // Clean spacing gap between label and text box
          // 2. THE TEXT BOX FIELD
          SizedBox(
            // color: Colors.amber,
            width: 150,
            // padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
            child: _buildAdaptiveDropdown(),
          ),
        ],
      ),
    );
  }

  Widget _priceRangeMinMax({required bool isMobile}) {
    return Container(
      width: 350, // Automatically fills the available horizontal width
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Left-aligns the text label
        children: [
          // 1. THE FIELD LABEL
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(
            height: 15,
          ), // Clean spacing gap between label and text box
          // 2. THE TEXT BOX FIELD
          SizedBox(
            height: 30, // Correctly forces strict height for the entire row row
            // width: 300, // Explicit fixed outer box width
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // MIN LABEL
                const Text(
                  'Min',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),

                // MIN TEXTBOX (Taller Height)
                Expanded(
                  child: SizedBox(
                    height:
                        52, // 2. Increased height for a slightly roomier box
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 14,
                      ), // Increased slightly to match taller height
                      textAlignVertical: TextAlignVertical
                          .center, // 3. Keeps text centered inside box

                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        isCollapsed: true,

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical:
                              8, // 🔥 INCREASED THIS to make the box taller
                        ), // Added a bit more side padding
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16), // Spacing bridge
                // MAX LABEL
                const Text(
                  'Max',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),

                // MAX TEXTBOX (Taller Height)
                Expanded(
                  child: SizedBox(
                    height: 62,
                    // 2. Match identical increased height here
                    child: TextField(
                      style: const TextStyle(fontSize: 14),
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Any',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical:
                              8, // 🔥 INCREASED THIS to make the box taller
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchByProdId({required bool isMobile}) {
    return Container(
      width: 350, // Automatically fills the available horizontal width
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Left-aligns the text label
        children: [
          // 1. THE FIELD LABEL
          const Text(
            'Product Id',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(
            height: 8,
          ), // Clean spacing gap between label and text box
          // 2. THE TEXT BOX FIELD
          SizedBox(
            height: 40,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor:
                    Colors.grey.shade50, // Subtle grey fill background color
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 14.0,
                ),

                // Style for the default outline border shape
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                // Style when the input field is inactive but enabled
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                // Style when the user actively taps inside the input field
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterDrawer({required bool isMobile}) {
    return SizedBox(
      // height: 200,
      width:
          double.infinity, // Correctly set flex directly on the Expanded widget
      child: Ink(
        decoration: BoxDecoration(
          // color: Colors.blue.shade50, // Soft blue background fill
          color: Colors.white,
        ),
        child: InkWell(
          // 1. Define your click action to show/hide your child panel
          onTap: () {
            setState(() {
              _isFilterPanelOpen = !_isFilterPanelOpen;
            });
          },

          // 2. Curve the corners of the splash ripple effect to match your layout
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Dynamic Icon swaps based on open state
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    color: Colors.blue.shade100,
                    child: Icon(
                      _isFilterPanelOpen
                          ? Icons.filter_list_off
                          : Icons.filter_list,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      _isFilterPanelOpen
                          ? '  Product filter'
                          : '  Product filter',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // const SizedBox(width: 8), // Small spacing anchor
              // Dynamic Text label swaps based on open state
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardcontents({required String deviceType}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: deviceType == "Mobile"
            ? 1
            : deviceType == "Tablet"
            ? 2
            : 4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 1.0,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final item = products[index];

        // Wrap the Card inside an InkWell to detect tap interactions
        return InkWell(
          onTap: () => widget.callBackProductWrapper("product_details", item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,

                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ), // Explicitly removes the outline
                  // Keeps rounded corners
                  child: Column(
                    // height: 300,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ClipRRect(
                          child: Image.asset(
                            item['image']!,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                // You can set a fixed width per item or let it auto-size based on text length
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 5,
                                  left: 10,
                                  right: 10,
                                ),

                                // alignment: Alignment.topLeft,
                                // color: Colors.blueGrey,
                                child: Text(
                                  "Top Style front bag",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              // mainAxisAlignment: MainAxisAlignment.end,
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 5,
                                  right: 10,
                                ),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Text(
                                      "Price ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "200",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "300",
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors
                                            .red, // Optional: Changes line color
                                        decorationThickness:
                                            4.0, // Optional: Makes the line thicker
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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

  // --- ADAPTIVE FORM ATOMS ---
  Widget _buildAdaptiveDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: "asc",
      hint: const Text('Choose...'),
      icon: const SizedBox.shrink(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.arrow_drop_down),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal:
              12.0, // Added horizontal padding so text doesn't touch the border
        ),
        // 1. Border configuration when the dropdown is inactive
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8.0,
          ), // Adjust corner roundness here

          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1.0,
          ), // Keeps color identical after selection
        ),
      ),
      items: <String>["asc", "desc"].map<DropdownMenuItem<String>>((
        String value,
      ) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() => _selectedValue = newValue);
      },
    );
  }

  // --- SCAFFOLD STRUCTURAL UTILITIES ---
  List<Widget> _buildAppBarActions() => [
    IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
    IconButton(
      icon: const Icon(Icons.account_circle_outlined),
      onPressed: () {},
    ),
    const SizedBox(width: 8.0),
  ];
}
