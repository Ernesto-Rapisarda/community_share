import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  Future<String?> uploadImage(XFile file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child('profile_images/${DateTime.now().toString()}');
    TaskSnapshot storageTaskSnapshot = await storageReference.putFile(File(file.path));
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<XFile?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    return _file;
  }

  Future<String?> uploadPdf(File pdfFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child('pdf_uploads/${DateTime.now().toString()}.pdf');
    TaskSnapshot storageTaskSnapshot = await storageReference.putFile(pdfFile);
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<File?> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }


}
