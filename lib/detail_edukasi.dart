import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppColors {
  static const Color customColor = Color.fromRGBO(8, 3, 51, 1);
}
class DetailEdukasiScreen extends StatelessWidget {
  final String data;

  DetailEdukasiScreen({required this.data, Key? key}) : super(key: key);

  Future<DocumentSnapshot<Map<String, dynamic>>> getBeritaDetailByData(
      String documentId) {
    return FirebaseFirestore.instance
        .collection('informasi')
        .doc(documentId)
        .get();
  }

  // Method to show the report dialog
  void showReportDialog(BuildContext context) {
    TextEditingController reportController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Laporkan Postingan'),
          content: TextField(
            controller: reportController,
            decoration: const InputDecoration(
              hintText: 'Alasan laporan',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (reportController.text.isNotEmpty) {
                  saveReport(reportController.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Laporan berhasil dikirim')),
                  );
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  // Method to save report to Firebase
  Future<void> saveReport(String reason) async {
    await FirebaseFirestore.instance.collection('reports').add({
      'postId': data,
      'reason': reason,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(8, 3, 51, 1),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getBeritaDetailByData(data),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Detail berita tidak ditemukan.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var beritaData = snapshot.data!.data()!;
          String title = beritaData['judul'] ?? 'Tanpa Judul';
          String description =
              beritaData['teksInformasi'] ?? 'Tidak ada deskripsi';
          String contact = beritaData['nomorTelepon'] ?? 'Tidak ada kontak';
          String imagePath =
              beritaData['image'] ?? 'asset/images/default_image.png';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: imagePath.isNotEmpty
                            ? NetworkImage(imagePath)
                            : const AssetImage('asset/images/default_image.png')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 22.0),
                  Text(
                    description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, color: Colors.green),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Text(
                          'Hubungi Pembuat Berita: $contact',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () => showReportDialog(context),
                    child: const Text('Laporkan Postingan'),
                    style: ElevatedButton.styleFrom(iconColor: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
