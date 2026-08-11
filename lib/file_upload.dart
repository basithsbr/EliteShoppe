import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:booktrip_app/cloud_service_fileupload.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class FileUploadWidget extends StatefulWidget {
  const FileUploadWidget({super.key});

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  String? _fileName;
  PlatformFile? _pickedFile;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  // Step 1: Pick a file from the device
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.any,
        withData: true, // Crucial for web to read bytes directly
      );

      if (result != null) {
        setState(() {
          PlatformFile file = result.files.first;
          _pickedFile = result.files.first;
          _fileName = _pickedFile!.name;
          _uploadProgress = 0.0;
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  // Step 2: Simulate or execute the upload process
  Future<void> _uploadFile() async {
    if (_pickedFile == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Simulate network upload progress chunks
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _uploadProgress = i / 10;
      });
    }

    Map<String, dynamic>? status = await CloudinaryService().uploadMediaFile(
      _pickedFile,
    );

    setState(() {
      _isUploading = false;
      if (status == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to upload file!')));
      } else if (status.containsKey('error')) {
        // Cloudinary API returned an explicit error object
        String errorMessage = status['error']['message'] ?? 'Unknown API error';
        print("Cloudinary API Error: $errorMessage");
      } else if (status.containsKey('secure_url')) {
        // Successful upload
        String fileUrl = status['secure_url'];
        String publicId = status['public_id'];
        print("Upload Successful!");
        print("File URL: $fileUrl");
        print("Public ID: $publicId");
        _pickedFile = null;
        _fileName = null;
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to upload file!')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(0),
      child: Card(
        elevation: 4,
        color: Colors.white,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Upload Document',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Drop zone / Selection Area UI
              InkWell(
                onTap: _isUploading ? null : _pickFile,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _fileName ?? 'Tap to browse file',
                        style: TextStyle(
                          color: _fileName != null
                              ? Colors.black87
                              : Colors.grey.shade600,
                          fontWeight: _fileName != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Progress Bar (Visible during upload)
              if (_isUploading) ...[
                LinearProgressIndicator(value: _uploadProgress),
                const SizedBox(height: 8),
                Text(
                  'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(height: 16),
              ],

              // Action Button
              ElevatedButton.icon(
                onPressed: (_pickedFile == null || _isUploading)
                    ? null
                    : _uploadFile,
                style: ElevatedButton.styleFrom(
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    // Text color
                    // Change 12.0 to your desired radius
                  ),
                ),

                icon: const Icon(Icons.upload),
                label: Text(_isUploading ? 'Uploading...' : 'Start Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
