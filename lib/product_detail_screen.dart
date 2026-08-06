import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // IMPORT THIS PACKAGE

class ProductDetailScreen extends StatelessWidget {
  final Map<String, String> product;

  const ProductDetailScreen({super.key, required this.product});

  // Function to build and safely open the WhatsApp chat link
  Future<void> _openWhatsApp() async {
    // 1. Replace with your actual business phone number (include country code, NO spaces/plus signs)
    const String phoneNumber = "1234567890";

    // 2. Dynamic message containing the user's item selection
    final String message =
        "Hello, I am interested in buying the *${product['title']}* priced at ${product['price']}.";

    // 3. Construct the official universal WhatsApp API link
    final Uri whatsappUrl = Uri.parse(
      "https://wa.me{Uri.encodeComponent(message)}",
    );

    // 4. Safely verify and open the link in the device's default browser/app handler
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch WhatsApp URL link layout.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['title'] ?? 'Product Details'),
        backgroundColor: const Color.fromARGB(255, 115, 178, 196),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color.fromARGB(255, 245, 245, 245),
              height: 300,
              width: double.infinity,
              child: Image.asset(product['image']!, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title']!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product['price']!,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Your other description details continue here...
                ],
              ),
            ),
          ],
        ),
      ),

      // NEW: Add this property directly to the Scaffold widget
      // It sits perfectly fixed in the bottom right corner automatically.
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366), // Official WhatsApp Green
        foregroundColor: Colors.white,
        shape: const CircleBorder(), // Keeps it perfectly round
        onPressed: _openWhatsApp,
        child: const Icon(Icons.phone_android),
      ),
    );
  }
}
