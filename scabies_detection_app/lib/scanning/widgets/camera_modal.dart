import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scabies_detection_app/core/constants/colors.dart';
import 'package:scabies_detection_app/core/constants/font_size.dart';
import 'package:scabies_detection_app/core/constants/font_weigth.dart';
import 'package:scabies_detection_app/scanning/provider/scanner_provider.dart';
import 'package:scabies_detection_app/scanning/view/scanner_result_screen.dart';
import 'package:provider/provider.dart';

Future<void> showCameraModal(BuildContext context) async {
  showModalBottomSheet(
    isDismissible: false,
    enableDrag: false,
    context: context,
    builder: (BuildContext context) {
      return Consumer<ScannerProvider>(
        builder: (context, scannerProvider, _) {
          return scannerProvider.isCropped
              ? Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.brandColor,
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Pilih Sumber Foto',
                                style: TextStyle(
                                  fontSize: AppFontSize.bodyMedium,
                                  fontWeight: AppFontWeight.bodySemiBold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  IconlyLight.close_square,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  // Aktifkan Crop Image
                                  scannerProvider.cropImage();

                                  final pickedFileCamera =
                                      await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                  );

                                  if (pickedFileCamera != null) {
                                    if (context.mounted) {
                                      CroppedFile? croppedFile =
                                          await ImageCropper().cropImage(
                                        sourcePath: pickedFileCamera.path,
                                        uiSettings: [
                                          AndroidUiSettings(
                                            toolbarTitle: 'Sesuaikan Gambar',
                                            toolbarColor: AppColors.brandColor,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio:
                                                CropAspectRatioPreset.square,
                                            lockAspectRatio: true,
                                            hideBottomControls: true,
                                            cropFrameColor: AppColors.error500,
                                          ),
                                          IOSUiSettings(
                                            title: 'Sesuaikan Gambar',
                                          ),
                                        ],
                                      );
                                      if (croppedFile != null) {
                                        if (context.mounted) {
                                          File fileUpload =
                                              File(croppedFile.path);

                                          final scabiesResult =
                                              await scannerProvider
                                                  .checkScabies(
                                                      context, fileUpload);

                                          if (context.mounted) {
                                            await scannerProvider.addImage(
                                              context,
                                              fileUpload,
                                              scabiesResult.predictedLabel,
                                            );
                                            if (context.mounted) {
                                              // Close modal first
                                              Navigator.pop(context);

                                              // Matikan Crop Image
                                              scannerProvider.cropImage();

                                              double resConfidence =
                                                  scabiesResult.confidence *
                                                      100;
                                              String formattedConfidence;

                                              if (resConfidence > 99.99) {
                                                formattedConfidence = "99.99";
                                              } else {
                                                formattedConfidence =
                                                    resConfidence
                                                        .toStringAsFixed(2);
                                              }

                                              await Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      ScannerResultScreen(
                                                    scabiesResult: scabiesResult
                                                        .predictedLabel,
                                                    file: fileUpload,
                                                    confidence: formattedConfidence,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      } else {
                                        if (context.mounted) {
                                          // Matikan Crop Image
                                          scannerProvider.cropImage();

                                          Navigator.pop(context);
                                        }
                                      }
                                    }
                                  } else {
                                    // Matikan Crop Image
                                    scannerProvider.cropImage();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: AppColors.primary100),
                                  ),
                                  child: const Column(
                                    children: [
                                      Icon(
                                        IconlyLight.category,
                                        size: 32,
                                        color: AppColors.brandColor,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Galeri Foto',
                                        style: TextStyle(
                                          fontSize: AppFontSize.bodyMedium,
                                          fontWeight:
                                              AppFontWeight.bodySemiBold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Pilih gambar dari galeri foto',
                                        style: TextStyle(
                                          fontSize: AppFontSize.caption,
                                          fontWeight:
                                              AppFontWeight.captionRegular,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // Aktifkan Crop Image
                                  scannerProvider.cropImage();

                                  final pickedFileCamera =
                                      await ImagePicker().pickImage(
                                    source: ImageSource.camera,
                                  );

                                  if (pickedFileCamera != null) {
                                    if (context.mounted) {
                                      CroppedFile? croppedFile =
                                          await ImageCropper().cropImage(
                                        sourcePath: pickedFileCamera.path,
                                        uiSettings: [
                                          AndroidUiSettings(
                                            toolbarTitle: 'Sesuaikan Gambar',
                                            toolbarColor: AppColors.brandColor,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio:
                                                CropAspectRatioPreset.square,
                                            lockAspectRatio: true,
                                            hideBottomControls: true,
                                            cropFrameColor: AppColors.error500,
                                          ),
                                          IOSUiSettings(
                                            title: 'Sesuaikan Gambar',
                                          ),
                                        ],
                                      );
                                      if (croppedFile != null) {
                                        if (context.mounted) {
                                          File fileUpload =
                                              File(croppedFile.path);

                                          final scabiesResult =
                                              await scannerProvider
                                                  .checkScabies(
                                                      context, fileUpload);

                                          if (context.mounted) {
                                            await scannerProvider.addImage(
                                              context,
                                              fileUpload,
                                              scabiesResult.predictedLabel,
                                            );

                                            if (context.mounted) {
                                              // Close the modal
                                              Navigator.pop(context);

                                              // Matikan Crop Image
                                              scannerProvider.cropImage();

                                              double resConfidence =
                                                  scabiesResult.confidence *
                                                      100;
                                              String formattedConfidence;

                                              if (resConfidence > 99.99) {
                                                formattedConfidence = "99.99";
                                              } else {
                                                formattedConfidence =
                                                    resConfidence
                                                        .toStringAsFixed(2);
                                              }
                                              // Navigate to results screen
                                              await Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      ScannerResultScreen(
                                                    scabiesResult: scabiesResult
                                                        .predictedLabel,
                                                    file: fileUpload,
                                                    confidence: formattedConfidence,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      } else {
                                        if (context.mounted) {
                                          // Matikan Crop Image
                                          scannerProvider.cropImage();

                                          Navigator.pop(context);
                                        }
                                      }
                                    }
                                  } else {
                                    // Matikan Crop Image
                                    scannerProvider.cropImage();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: AppColors.primary100),
                                  ),
                                  child: const Column(
                                    children: [
                                      Icon(
                                        IconlyLight.camera,
                                        size: 32,
                                        color: AppColors.brandColor,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Kamera',
                                        style: TextStyle(
                                          fontSize: AppFontSize.bodyMedium,
                                          fontWeight:
                                              AppFontWeight.bodySemiBold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Buka kamera untuk mengambil gambar',
                                        style: TextStyle(
                                          fontSize: AppFontSize.caption,
                                          fontWeight:
                                              AppFontWeight.captionRegular,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                      ],
                    ),
                  ),
                );
        },
      );
    },
  );
}
