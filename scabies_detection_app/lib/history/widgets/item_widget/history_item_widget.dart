import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:scabies_detection_app/core/constants/colors.dart';
import 'package:scabies_detection_app/history/view/history_detail.dart';

class HistoryItemWidget extends StatelessWidget {
  final File file;
  final String id;
  final String scabiesResult;
  
  const HistoryItemWidget({
    super.key,
    required this.file,
    required this.id,
    required this.scabiesResult,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
              builder: (context) => HistoryDetailScreen(
                  scabiesResult: scabiesResult,
                  file: file,)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // warna bayangan
              spreadRadius: 0, // seberapa besar bayangan tersebar
              blurRadius: 20, // tingkat kejelasan bayangan
              offset: const Offset(4, 4), // posisi bayangan (x, y)
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  25), // Half of the width/height for a perfect circle
              child: Container(
                width: 50.0,
                height: 50.0,
                color: AppColors.primary100,
                child: Image.file(file),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    id,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    scabiesResult == 'SCABIES' ? 'Scabies' : 'Bukan Scabies',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.graySecondColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Icon(
              IconlyLight.arrow_right_circle,
              color: AppColors.brandColor,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
