import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:scabies_detection_app/scanning/models/model/scanning_response_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanningService {
  final dio.Dio dioInstance = dio.Dio(
    dio.BaseOptions(
      baseUrl: 'http://193.203.160.153/',
    ),
  );

  Future<ScanningResponseModel> checkScabiesAI(String filePath) async {
    try {
      print('Mulai proses scanning AI');
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User belum login');
      print('User terautentikasi: ${user.id}');

      final formData = dio.FormData.fromMap({
        "image": await dio.MultipartFile.fromFile(filePath),
      });
      print('Form data berhasil dibuat');

      print('Mengirim request ke API prediksi...');

      final response = await dioInstance.post("predict-first", data: formData);
      print('Response diterima: ${response.statusCode}');

      final res = ScanningResponseModel.fromJson(response.data);
      print(
          'Hasil prediksi: ${res.predictedLabel} dengan confidence: ${res.confidence}');

      final resultBool = res.predictedLabel.toUpperCase() == "SCABIES";
      print('Hasil boolean: $resultBool');

      String formattedConfidence;
      double resConfidence = (res.confidence * 100);
      if (resConfidence > 99.99) {
        formattedConfidence = "99.99";
      } else {
        formattedConfidence = resConfidence.toStringAsFixed(2);
      }
      print('Confidence: $formattedConfidence');

      final storage = Supabase.instance.client.storage;
      print('Membaca file bytes...');

      final fileBytes = await File(filePath).readAsBytes();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${user.id}.jpg';
      print('Nama file di storage: $fileName');

      print('Mengupload gambar ke Supabase...');
      await storage.from('images').uploadBinary('scabies/$fileName', fileBytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'));
      print('Upload gambar berhasil');

      final imageUrl = storage.from('images').getPublicUrl('scabies/$fileName');
      print('Image URL: $imageUrl');

      final insertData = {
        'id_user': user.id,
        'result': resultBool,
        'confidence': formattedConfidence,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      };
      print('Data yang akan diinsert: $insertData');

      final supabase = Supabase.instance.client;
      print('Menjalankan insert ke tabel detection_history...');
      final response2 =
          await supabase.from('detection_history').insert(insertData);
      print('Insert berhasil dilakukan. Response: $response2');

      return res;
    } on dio.DioException catch (e) {
      print('Error DioException: ${e.toString()}');
      throw Exception(e.toString());
    } catch (e) {
      print('Error lainnya: ${e.toString()}');
      throw Exception(e.toString());
    }
  }
}
