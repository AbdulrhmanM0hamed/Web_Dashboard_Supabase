import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data';
class ImagePickerService {
  static final _supabase = Supabase.instance.client;
  static final _imagePicker = ImagePicker();

  static const String _productBucket = 'product-images';
  static const String _categoryBucket = 'categorier-images';

  static Future<String?> pickImage({bool isProduct = false}) async {
    try {
      if (kIsWeb) {
        final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
        input.click();

        await input.onChange.first;
        if (input.files?.isEmpty ?? true) return null;

        final html.File file = input.files![0];
        final String fileName =  DateTime.now().toIso8601String().replaceAll(':', '-') + '.jpg';
        final String bucketName = isProduct ? _productBucket : _categoryBucket;

        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        
        final bytes = await reader.onLoad.first.then((_) => reader.result as List<int>);

        await _supabase.storage.from(bucketName).uploadBinary(
          fileName,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

        final String imageUrl = _supabase.storage.from(bucketName).getPublicUrl(fileName);
        print('Image URL generated: $imageUrl'); // للتتبع
        return imageUrl;
      } else {
        // Mobile implementation
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
        if (image == null) return null;

        final String fileName = DateTime.now().toIso8601String().replaceAll(':', '-') + '.jpg';
        final String bucketName = isProduct ? _productBucket : _categoryBucket;
        print('Using bucket: $bucketName'); // للتتبع

        final File file = File(image.path);
        final bytes = await file.readAsBytes();
        
        await _supabase.storage.from(bucketName).uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

        final String imageUrl = _supabase.storage.from(bucketName).getPublicUrl(fileName);
        print('Image URL generated: $imageUrl'); // للتتبع
        return imageUrl;
      }
    } catch (e, stackTrace) {
      print('Error in pickImage:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      rethrow; // Re-throw to handle in UI
    }
  }

  /// حذف صورة من التخزين
  static Future<void> deleteImage(String imageUrl, {bool isProduct = false}) async {
    try {
      final String bucketName = isProduct ? _productBucket : _categoryBucket;
      final Uri uri = Uri.parse(imageUrl);
      final String fileName = path.basename(uri.path);
      
      await _supabase.storage.from(bucketName).remove([fileName]);
      print('Image deleted successfully: $fileName');
    } catch (e) {
      print('Error deleting image: $e');
      rethrow;
    }
  }
}
