// To parse this JSON data, do
//
//     final aiRoadChecker = aiRoadCheckerFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

ScanningResponseModel aiRoadCheckerFromJson(String str) =>
    ScanningResponseModel.fromJson(json.decode(str));

String aiRoadCheckerToJson(ScanningResponseModel data) =>
    json.encode(data.toJson());

class ScanningResponseModel {
  String predictedLabel;
  double confidence;

  ScanningResponseModel({
    required this.predictedLabel,
    required this.confidence,
  });

  factory ScanningResponseModel.fromJson(Map<String, dynamic> json) =>
      ScanningResponseModel(
        predictedLabel: json["predicted_label"],
        confidence: json["confidence"],
      );

  Map<String, dynamic> toJson() => {
        "predicted_label": predictedLabel,
        "confidence": confidence,
      };
}
