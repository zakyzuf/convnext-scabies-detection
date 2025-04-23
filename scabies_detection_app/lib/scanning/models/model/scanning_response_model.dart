// To parse this JSON data, do
//
//     final aiRoadChecker = aiRoadCheckerFromJson(jsonString);

import 'dart:convert';

ScanningResponseModel aiRoadCheckerFromJson(String str) =>
    ScanningResponseModel.fromJson(json.decode(str));

String aiRoadCheckerToJson(ScanningResponseModel data) =>
    json.encode(data.toJson());

class ScanningResponseModel {
  String predictedLabel;

  ScanningResponseModel({
    required this.predictedLabel,
  });

  factory ScanningResponseModel.fromJson(Map<String, dynamic> json) =>
      ScanningResponseModel(
        predictedLabel: json["predicted_label"],
      );

  Map<String, dynamic> toJson() => {
        "predicted_label": predictedLabel,
      };
}
