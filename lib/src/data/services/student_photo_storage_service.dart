import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StudentPhotoStorageService {
  final FirebaseStorage storage;
  final ImagePicker imagePicker;

  StudentPhotoStorageService({
    FirebaseStorage? storage,
    ImagePicker? imagePicker,
  })  : storage = storage ?? FirebaseStorage.instance,
        imagePicker = imagePicker ?? ImagePicker();

  Future<XFile?> pickPhoto() => imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

  Future<String> uploadPhoto({
    required String studentId,
    required XFile image,
  }) async {
    final bytes = await image.readAsBytes();
    if (bytes.isEmpty) {
      throw const FormatException('A imagem selecionada está vazia.');
    }
    if (bytes.length > 5 * 1024 * 1024) {
      throw const FormatException('A foto deve ter no máximo 5 MB.');
    }

    final contentType = _contentType(image);
    if (contentType == null || !contentType.startsWith('image/')) {
      throw const FormatException('O formato da imagem não é compatível.');
    }

    final reference = storage.ref('people/$studentId/profile');
    await reference.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );
    return reference.getDownloadURL();
  }

  String? _contentType(XFile image) {
    final extension = image.name.split('.').last.toLowerCase();
    const contentTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'webp': 'image/webp',
      'gif': 'image/gif',
      'bmp': 'image/bmp',
      'heic': 'image/heic',
      'heif': 'image/heif',
    };
    return contentTypes[extension] ?? image.mimeType;
  }
}
