import 'package:flutter/material.dart';
import 'package:scabies_detection_app/core/constants/colors.dart';
import 'package:scabies_detection_app/history/provider/history_provider.dart';
import 'package:scabies_detection_app/history/widgets/item_widget/history_item_widget.dart';
import 'package:provider/provider.dart';

bool hasHistoryToShow = false;

class OldHistoryWidget extends StatelessWidget {
  const OldHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            historyProvider.historyList.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.05), // warna bayangan
                          spreadRadius: 0, // seberapa besar bayangan tersebar
                          blurRadius: 20, // tingkat kejelasan bayangan
                          offset: const Offset(4, 4), // posisi bayangan (x, y)
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Riwayat kosong.',
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      // Extract the DateTime from your history item
                      DateTime itemDate =
                          historyProvider.historyList[index].dateTime;

                      // Check if the item's date is not equal to today's date
                      if (!isSameDay(itemDate, DateTime.now())) {
                        hasHistoryToShow =
                            true; // Set the flag to true if at least one item should be displayed

                        return HistoryItemWidget(
                          file: historyProvider.historyList[index].imageFile,
                          id: 'Hasil Scan ${(index + 1)}',
                          scabiesResult:
                              historyProvider.historyList[index].description,
                        );
                      }

                      return const SizedBox
                          .shrink(); // Skip displaying items with the same date as today
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 8,
                    ),
                    itemCount: historyProvider.historyList.length,
                  ),
            historyProvider.historyList.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.05), // warna bayangan
                          spreadRadius: 0, // seberapa besar bayangan tersebar
                          blurRadius: 20, // tingkat kejelasan bayangan
                          offset: const Offset(4, 4), // posisi bayangan (x, y)
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Riwayat kosong.',
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
