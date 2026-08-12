import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class EditableImage {
  final PlatformFile file;
  String title;
  String description;
  String price;
  String brand;
  String category;
  bool isCompleted;

  EditableImage({
    required this.file,
    required this.title,
    this.description = '',
    this.price = '',
    this.brand = '',
    this.category = '',
    this.isCompleted = false,
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
              (file) => EditableImage(
                file: file,
                title: file.name,
                brand: "",
                category: "",
                description: "",
                price: "",
                isCompleted: false,
              ),
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
                  onDelete: () => _removeImage(index),
                  onUpdate:
                      (title, description, price, brand, category, isDone) =>
                          setState(() {
                            _selectedImages[index].title = title;
                            _selectedImages[index].description = description;
                            _selectedImages[index].price = price;
                            _selectedImages[index].brand = brand;
                            _selectedImages[index].category = category;
                            _selectedImages[index].isCompleted = isDone;
                          }),
                  changesDone: _selectedImages[index].isCompleted,
                  editableImage: _selectedImages[index],
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

class ImageCardItem extends StatefulWidget {
  final VoidCallback onDelete;
  final bool changesDone;
  final EditableImage editableImage;
  final Function(
    String title,
    String description,
    String price,
    String brand,
    String category,
    bool isDone,
  )
  onUpdate;

  const ImageCardItem({
    super.key,
    required this.onDelete,
    required this.onUpdate,
    required this.changesDone,
    required this.editableImage,
  });
  @override
  State<ImageCardItem> createState() => _ImageCardItemState();
}

class _ImageCardItemState extends State<ImageCardItem> {
  bool _localChangesDone = false;
  String _currentTitle = '';
  String _currentPrice = '';
  String _currentBrand = '';
  String _currentCategory = '';
  String _currentDesc = '';

  @override
  void initState() {
    super.initState();
    // Initialize text defaults from the incoming file structure
    _currentTitle = widget.editableImage.file.name;
    _currentPrice = widget.editableImage.price;
    _currentBrand = widget.editableImage.brand;
    _currentCategory = widget.editableImage.category;
    _currentDesc = widget.editableImage.description;
    _localChangesDone = widget
        .editableImage
        .isCompleted; // Reset local changes on new card creation
  }

  @override
  Widget build(BuildContext context) {
    // Round size to Megabytes for UI display

    final double sizeInMb = widget.editableImage.file.size / (1024 * 1024);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // Ensures image corners align to card shape
      child: InkWell(
        onTap: () => {_showEditDialog(context)},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. The Image Area
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(
                    widget.editableImage.file.bytes!,
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
                        onPressed: widget.onDelete,
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
                        widget.editableImage.file.name,
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
                    backgroundColor: !_localChangesDone
                        ? Colors.redAccent
                        : Colors.green,
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
      text: _currentTitle,
    );
    final TextEditingController priceController = TextEditingController(
      text: _currentPrice,
    );
    final TextEditingController brandController = TextEditingController(
      text: _currentBrand,
    );
    final TextEditingController categoryController = TextEditingController(
      text: _currentCategory,
    );
    final TextEditingController prodDescController = TextEditingController(
      text: _currentDesc,
    );

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
                setState(() {
                  _currentTitle = titleController.text;
                  _currentPrice = priceController.text;
                  _currentBrand = brandController.text;
                  _currentCategory = categoryController.text;
                  _currentDesc = prodDescController.text;
                  _localChangesDone =
                      true; // Instantly flips badge color to green
                });

                widget.onUpdate(
                  titleController.text,
                  prodDescController.text,
                  priceController.text,
                  brandController.text,
                  categoryController.text,
                  true,
                );

                Navigator.pop(
                  context,
                ); // Closes the modal pop-up overlay window
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }
}
