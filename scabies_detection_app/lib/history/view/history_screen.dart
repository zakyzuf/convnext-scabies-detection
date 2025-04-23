import 'package:flutter/material.dart';
import 'package:scabies_detection_app/history/widgets/history_widget.dart';
import 'package:scabies_detection_app/history/widgets/old_history_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Riwayat Hari Ini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                HistoryWidget(),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Riwayat Terdahulu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                OldHistoryWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
