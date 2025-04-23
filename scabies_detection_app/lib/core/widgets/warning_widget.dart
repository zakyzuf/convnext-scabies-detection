import 'package:flutter/material.dart';
import 'package:scabies_detection_app/core/constants/colors.dart';
import 'package:scabies_detection_app/core/constants/font_size.dart';

Widget warningWidget(
  final String description,
) {
  return Container(
    padding: const EdgeInsets.all(8),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: AppColors.warning50,
    ),
    child: Center(
      child: Text(
        description,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppFontSize.caption,
          color: AppColors.warning500,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
