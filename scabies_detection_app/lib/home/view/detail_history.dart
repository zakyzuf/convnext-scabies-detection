import 'package:flutter/material.dart';
import 'package:scabies_detection_app/core/constants/colors.dart';
import 'package:scabies_detection_app/history/models/services/history_service.dart';

class DetectionHistoryDetailScreen extends StatelessWidget {
  final String scabiesResult;
  final String imageUrl;
  final int id;
  final String confidence;

  DetectionHistoryDetailScreen({
    super.key,
    required this.scabiesResult,
    required this.imageUrl,
    required this.id,
    required this.confidence,
  });

  final HistoryService _historyService = HistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 40,
                  child: CircleAvatar(
                    backgroundColor: AppColors.brandColor.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 40,
                  child: CircleAvatar(
                    backgroundColor: AppColors.brandColor.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.zoom_in, color: Colors.white),
                      onPressed: () {
                        _showFullScreenImage(context, imageUrl);
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 125,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 35),
                        const Text(
                          'The Result is:',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          scabiesResult == 'SCABIES'
                              ? 'Scabies'
                              : 'Bukan Scabies',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.brandColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    scabiesResult == 'SCABIES'
                        ? 'Scabies merupakan penyakit kulit menular yang disebabkan oleh masuknya tungau kecil ke dalam lapisan kulit luar. Scabies dapat menyebabkan gatal intens dan ruam. Scabies dapat menyebabkan luka pada kulit dan komplikasi serius seperti septisemia (infeksi aliran darah), penyakit jantung, dan masalah ginjal.'
                        : 'Hasil deteksi menyatakan bukanlah Scabies. Namun, jika Anda mengalami masalah pada kulit, kami menyarankan untuk segera mencari bantuan dari tenaga medis.',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Confidence Score: $confidence%',
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: const Text(
                                  'Apakah Anda yakin ingin menghapus history ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Tutup dialog
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _historyService
                                        .deleteDetectionHistory(id); // Hapus
                                    Navigator.of(context).pop(); // Tutup dialog
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    'Hapus History',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Hapus History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showFullScreenImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
