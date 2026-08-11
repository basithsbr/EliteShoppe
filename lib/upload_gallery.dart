import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class EditableImage {
  final PlatformFile file;
  String title;
  String description;

  EditableImage({
    required this.file,
    required this.title,
    this.description = '',
  });
}

class WebCardGalleryScreen extends StatefulWidget {
  const WebCardGalleryScreen({super.key});

  @override
  State<WebCardGalleryScreen> createState() => _WebCardGalleryScreenState();
}

class _WebCardGalleryScreenState extends State<WebCardGalleryScreen> {
  final List<EditableImage> _selectedImages = [];
  bool _isPicking = false;

  Future<void> _pickDeviceImages() async {
    setState(() => _isPicking = true);

    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: true, // Allows selecting 200+ images at once
        withData: true, // Loads bytes directly into browser memory
      );

      if (result != null) {
        setState(() {
          // Combines newly picked images with existing ones
          _selectedImages.addAll(
            result.files.map(
              (file) => EditableImage(file: file, title: file.name),
            ),
          );
        });
      }
    } catch (e) {
      if (kDebugMode) print("Error picking files: $e");
    } finally {
      setState(() => _isPicking = false);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Gallery"),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        elevation: 2,
        actions: [
          if (_selectedImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  "${_selectedImages.length} Images Loaded",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      body: _selectedImages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isPicking ? null : _pickDeviceImages,
                    icon: const Icon(Icons.add_to_photos),
                    label: Text(
                      _isPicking
                          ? "Opening Device Gallery..."
                          : "Select Images",
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),

              // GridView.builder lazy loads cards to protect browser RAM
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                final file = _selectedImages[index].file;
                return ImageCardItem(
                  file: file,
                  onDelete: () => _removeImage(index),
                  onUpdate: (title, description, price, brand, category) =>
                      print("Updated Image: $title, Description: $description"),
                );
              },
            ),
      floatingActionButton: _selectedImages.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _pickDeviceImages,
              tooltip: 'Add More Images',
              child: const Icon(Icons.add),
            ),
    );
  }
}

class ImageCardItem extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback onDelete;
  final Function(
    String title,
    String description,
    String price,
    String brand,
    String category,
  )
  onUpdate;

  const ImageCardItem({
    super.key,
    required this.file,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    // Round size to Megabytes for UI display
    final double sizeInMb = file.size / (1024 * 1024);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // Ensures image corners align to card shape
      child: InkWell(
        onTap: () => _showEditDialog(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. The Image Area
            SizedBox(
              height: 220,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(
                    file.bytes!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                  // Delete button overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 16,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: onDelete,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 2. Card Metadata Text details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${sizeInMb.toStringAsFixed(2)} MB",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 16,
                    child: Icon(Icons.done, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    // Controllers track what the user types inside the fields
    final TextEditingController titleController = TextEditingController(
      text: file.name,
    );
    final TextEditingController priceController = TextEditingController();
    final TextEditingController brandController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController prodDescController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Edit Image Details"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Prevents modal from taking full screen height
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Image Title",

                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: "Price",

                    prefixIcon: Icon(Icons.description),
                    hintText: "Enter details about this image...",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: brandController,

                  decoration: const InputDecoration(
                    labelText: "Brand",

                    prefixIcon: Icon(Icons.description),
                    hintText: "Enter details about this image...",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,

                  decoration: const InputDecoration(
                    labelText: "Category",

                    prefixIcon: Icon(Icons.description),
                    hintText: "Enter details about this image...",
                  ),
                ),
                const SizedBox(height: 16), // Input Field 2: Description
                TextField(
                  controller: prodDescController,
                  maxLines: 3, // Allows multiline notes typing
                  decoration: const InputDecoration(
                    labelText: "Description / Notes",

                    prefixIcon: Icon(Icons.description),
                    hintText: "Enter details about this image...",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            // Save Button
            ElevatedButton(
              onPressed: () {
                onUpdate(
                  titleController.text,
                  prodDescController.text,
                  priceController.text,
                  brandController.text,
                  categoryController.text,
                );

                Navigator.pop(
                  context,
                ); // Closes the modal pop-up overlay window
              },
              child: const Text("Save Changes"),
            ),
          ],
        );
      },
    );
  }
}
