import 'dart:io';

class HistoryModel {
  final String id;
  final File imageFile;
  final String description;
  final DateTime dateTime;

  HistoryModel({
    required this.id,
    required this.imageFile,
    required this.description,
    required this.dateTime,
  });
}
