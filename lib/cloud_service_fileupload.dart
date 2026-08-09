import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:cross_file/cross_file.dart';

class CloudinaryService {
  // ADD THESE SECURE OVERRIDES RIGHT AFTER:
  // 🛠️ ISOLATE DIO CONFIGURATION TO BYPASS CORS & XHR FAILS
  Dio dio = Dio();

  // Replace these with your actual Cloudinary Dashboard details
  final String cloudName = "hvuzvzcp";
  final String uploadPreset = "Elite_Shoppe";

  /// Uploads an image or video directly to Cloudinary from the mobile device.
  /// Returns a Map containing the public web URL and the public_id for deletion.
  Future<Map<String, dynamic>?> uploadMediaFile(dynamic fileInput) async {
    // 1. Extract file name safely across Web & Mobile platforms
    String fileName = fileInput.name;
    Uint8List fileBytes;
    print("Selected file: $fileName");
    print("Analyzing input file structure type... ${fileInput.runtimeType}");
    final String typeStr = fileInput.runtimeType.toString();

    try {
      // 2. Read the file into a memory raw byte stream (Safe for browsers!)
      if (fileInput is XFile) {
        fileName = fileInput.name;
        fileBytes = await fileInput.readAsBytes();
      }
      if (typeStr == 'PlatformFile' ||
          fileInput.toString().contains('PlatformFile')) {
        fileName = fileInput.name ?? "upload.jpg";
        // On Web, PlatformFile stores data directly in the .bytes property
        if (fileInput.bytes != null) {
          fileBytes = fileInput.bytes;
        } else {
          // If it's on Mobile, it might have a path instead of direct bytes
          throw Exception(
            "PlatformFile is missing bytes data. Ensure you set 'withData: true' in FilePicker!",
          );
        }
      }
      // Case 2: If input is a native Mobile File object (dart:io)
      else if (fileInput.toString().contains('File')) {
        fileName = fileInput.path.split('/').last;
        fileBytes = await fileInput.readAsBytes();
      }
      // Case 3: Fallback if it is already a pure raw Uint8List byte array
      else if (fileInput is Uint8List) {
        fileBytes = fileInput;
      }
      // Case 4: Absolute failure catch-all
      else {
        throw Exception("Unsupported input type passed to Cloudinary script.");
      }

      // 3. Construct FormData using bytes instead of file path pointers
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
        'upload_preset': uploadPreset,
      });

      // Determine endpoint type string based on extension
      String isVideo = fileName.endsWith('.mp4') || fileName.endsWith('.mov')
          ? 'video'
          : 'image';
      String endpointUrl = "https://cloudinary.com";

      // 4. Fire network request
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);

      // Explicitly reset headers to avoid sending unapproved browser meta frames
      dio.options.headers = {'Accept': '*/*'};
      Response response = await dio.post(endpointUrl, data: formData);

      if (response.statusCode == 200) {
        return {
          'secure_url': response.data['secure_url'],
          'public_id': response.data['public_id'],
        };
      }
      return null;
    } catch (e) {
      print("❌ Cross-Platform Cloudinary Connection Failed: $e");
      return null;
    }
  }
}
