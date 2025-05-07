import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:scabies_detection_app/history/models/services/history_service.dart';
import 'package:scabies_detection_app/home/view/detail_history.dart';
import 'package:scabies_detection_app/utils/navigation_helper.dart';
import 'package:scabies_detection_app/widget/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    if (index == 2) {
      navigatedWithOutTransition(context, '/profile');
    }
  }

  final HistoryService _historyService = HistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 55, 58, 255),
        foregroundColor: Colors.white,
        title: Text('Home Page'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyService.getUserDetectionHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return Center(child: Text('Belum ada data deteksi'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              // final imageUrl = item['image'];
              final imageUrl = item['image_url'];
              final confidence = item['confidence'];
              final result = item['result'] ? "Scabies" : "Non-Scabies";
              final date = DateTime.parse(item['created_at']);

              return ListTile(
                leading: Image.network(imageUrl,
                    width: 50, height: 50, fit: BoxFit.cover),
                title: Text(result),
                subtitle: Text('${date.day}-${date.month}-${date.year}'),
                trailing: Text('$confidence%'),
                onTap: () async {
                  // Penting: menambahkan await di sini
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetectionHistoryDetailScreen(
                        scabiesResult:
                            item['result'] ? 'SCABIES' : 'NON_SCABIES',
                        imageUrl: item['image_url'],
                        id: item['id'],
                        confidence: confidence.toString(),
                      ),
                    ),
                  );
                  if (result == true) {
                    setState(() {});
                  }
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
