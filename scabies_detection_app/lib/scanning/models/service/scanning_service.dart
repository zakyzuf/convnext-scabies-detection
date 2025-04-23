import 'package:dio/dio.dart';
import 'package:scabies_detection_app/scanning/models/model/scanning_response_model.dart';

class ScanningService {
  // Dio Untuk get tanpa interceptor
  final Dio dio = Dio(
    BaseOptions(
      // baseUrl: 'http://34.16.43.45/',
      // baseUrl: 'http://3.238.228.56/',
      baseUrl: 'http://193.203.160.153/',
    ),
  );

  Future<ScanningResponseModel> checkScabiesAI(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(filePath),
      });

      final response = await dio.post(
        "predict-first",
        data: formData,
      );

      final res = ScanningResponseModel.fromJson(response.data);
      return res;
    } on DioException catch (e) {
      throw Exception(e.toString());
    }
  }
}
