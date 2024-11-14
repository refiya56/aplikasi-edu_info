import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KotakMasukScreen extends StatelessWidget {
  final String data;
  KotakMasukScreen({required this.data, super.key});

  Stream<QuerySnapshot> _getInboxRequests() {
    return FirebaseFirestore.instance
        .collection('informasi')
        .where('status',
            isEqualTo:
                'pending') // Sesuaikan dengan status 'pending' di Firebase
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Color(0xFF1C2331),
          toolbarHeight: 60,
          title: const Text(
            'KOTAK MASUK',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(color: Color.fromRGBO(8, 3, 51, 1)),
          child: StreamBuilder<QuerySnapshot>(
            stream: _getInboxRequests(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada pesan masuk.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              final requests = snapshot.data!.docs;

              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  var request = requests[index];
                  String namaPengirim = request['namaPengirim'] ?? 'Tanpa Nama';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.mail, color: Colors.white),
                        title: Text(
                          'Dari: $namaPengirim',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailInboxScreen(data: request),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class DetailInboxScreen extends StatelessWidget {
  final DocumentSnapshot data;
  DetailInboxScreen({required this.data});

  Future<void> updatePostStatus(String status) async {
    await FirebaseFirestore.instance
        .collection('informasi')
        .doc(data.id) // Gunakan ID dokumen untuk memperbarui status
        .update({'status': status});
  }

  @override
  Widget build(BuildContext context) {
    String judul = data['judul'] ?? 'Tanpa Judul';
    String konten = data['teksInformasi'] ?? 'Tidak ada konten';
    String namaPengirim = data['namaPengirim'] ?? 'Tanpa Nama';

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesan'),
        backgroundColor: const Color(0xFF1C2331),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dari: $namaPengirim',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Judul: $judul',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Konten:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              konten,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await updatePostStatus("approved");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Konfirmasi"),
                          content: Text("Postingan Berhasil Diunggah"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                                Navigator.of(context)
                                    .pop(); // Kembali ke kotak masuk
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text("Accept", style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await updatePostStatus("rejected");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Konfirmasi"),
                          content: Text("Postingan Ditolak"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                                Navigator.of(context)
                                    .pop(); // Kembali ke kotak masuk
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text("Reject", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
