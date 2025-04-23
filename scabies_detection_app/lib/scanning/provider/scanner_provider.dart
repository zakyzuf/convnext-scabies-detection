import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:scabies_detection_app/history/models/model/history_model.dart';
import 'package:scabies_detection_app/history/provider/history_provider.dart';
import 'package:scabies_detection_app/scanning/models/model/scanning_response_model.dart';
import 'package:scabies_detection_app/scanning/models/service/scanning_service.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class ScannerProvider with ChangeNotifier {
  // Index untuk Halaman
  int currentIndex = 0;

  // Data Sementara
  bool isCropped = false;

  // Fungsi untuk resize gambar
  Future<File> resizeImage(File file) async {
    var image = decodeImage(file.readAsBytesSync());

    // Resize gambar ke 224x224
    var resizedImage = copyResize(image!, width: 224, height: 224);

    // Menyimpan gambar yang sudah diresize ke direktori yang sama
    File resizedFile = File(file.path)
      ..writeAsBytesSync(encodeJpg(resizedImage));

    return resizedFile;
  }

  // Set Status Crop Image done or not
  void cropImage() {
    isCropped = !isCropped;
    notifyListeners();
  }

  // Service
  final scanningService = ScanningService();

// Compresser image
  Future<File> compressImage(File croppedFile) async {
    var fileFromImage = File(croppedFile.path);
    var basename = path.basenameWithoutExtension(fileFromImage.path);
    var pathString =
        fileFromImage.path.split(path.basename(fileFromImage.path))[0];

    var pathStringWithExtension = "$pathString${basename}_image.jpg";

    int maxFileSizeInBytes = 1000000; // 2 MB
    int currentFileSize = await croppedFile.length();
    int quality = 90;

    File compressedFiles;

    compressedFiles = croppedFile;

    while (currentFileSize > maxFileSizeInBytes) {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        croppedFile.absolute.path,
        pathStringWithExtension,
        quality: quality,
      );

      currentFileSize = await compressedFile!.length();
      quality -= 10; // Decrease quality by 10 each iteration (adjust as needed)

      compressedFiles = File(compressedFile.path);
    }

    return compressedFiles;
  }

  Future<void> addImage(
    BuildContext context,
    File fileUpload,
    String description,
  ) async {
    HistoryModel historyModel = HistoryModel(
      id: UniqueKey().toString(),
      imageFile: fileUpload,
      description: description,
      dateTime: DateTime.now(),
    );

    Provider.of<HistoryProvider>(context, listen: false)
        .historyList
        .add(historyModel);

    notifyListeners();
  }

  Future<String> checkScabies(
    BuildContext context,
    File fileUpload,
  ) async {
    try {
      // Compress
      final fileAfterCompress = await compressImage(fileUpload);

      ScanningResponseModel result =
          await scanningService.checkScabiesAI(fileAfterCompress.path);

      // ScanningResponseModel result =
      //     await scanningService.checkScabiesAI(fileUpload.path);

      return result.predictedLabel;
    } catch (e) {
      return e.toString();
    }
  }

  // Fungsi fungsi untuk validasi inputan
  String? validatePertanyaan(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return 'Field tidak boleh kosong.';
    }

    return null; // validasi berhasil
  }
}
