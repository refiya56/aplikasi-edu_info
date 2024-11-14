import 'package:flutter/material.dart';
import 'package:myapp/baca_edukasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BacaBeritaScreen extends StatelessWidget {
  final String data;
  BacaBeritaScreen({required this.data, Key? key}) : super(key: key);

  Stream<QuerySnapshot> _getApprovedPosts() {
    return FirebaseFirestore.instance
        .collection('informasi')
        .where('status', isEqualTo: 'approved')
        .where('kategori', isEqualTo: 'Berita')
        //.orderBy('tanggalUnggah', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2331), // Dark blue background
        title: Image.asset('asset/images/logo.png', width: 80, height: 80),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF080333)),
        child: Column(
          children: [
            Container(
              color: const Color(0xFF1C2331), // Dark blue background
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color(0xFFFE9900),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: const Text(
                          'BERITA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BacaEdukasiScreen(
                                        data: 'Baca Edukasi',
                                      )),
                            );
                          },
                          child: Text(
                            'EDUKASI',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getApprovedPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada berita.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  final newsDocs = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(0.0),
                    itemCount: newsDocs.length,
                    itemBuilder: (context, index) {
                      var beritaData =
                          newsDocs[index].data() as Map<String, dynamic>;
                      String title = beritaData['judul'] ?? 'Tanpa Judul';
                      String imagePath = beritaData['image'] ??
                          'asset/images/default_image.png';

                      return CardWidget(
                        title: title,
                        imagePath: imagePath,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailBeritaScreen(data: newsDocs[index]),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  CardWidget(
      {Key? key,
      required this.title,
      required this.imagePath,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300], // Light grey background
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.grey[400], // Slightly darker grey
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100,
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Color(0xFF1C2331), // Dark blue background
              ),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppColors {
  static const Color customColor = Color.fromRGBO(8, 3, 51, 1);
}

class DetailBeritaScreen extends StatelessWidget {
  final DocumentSnapshot data; // Unique document ID for the berita.

  DetailBeritaScreen({required this.data, Key? key}) : super(key: key);

  Future<DocumentSnapshot<Map<String, dynamic>>> getBeritaDetailById() {
    return FirebaseFirestore.instance
        .collection('informasi')
        .doc(data.id)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customColor,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getBeritaDetailById(),
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

          // Retrieve data from the document
          var beritaData = snapshot.data!.data()!;
          String title = beritaData['judul'] ?? 'Tanpa Judul';
          String description =
              beritaData['teksInformasi'] ?? 'Tidak ada deskripsi';
          String contact = beritaData['nomorTelepon'] ?? 'Tidak ada kontak';
          String imagePath =
              beritaData['image'] ?? 'asset/images/default_image.png';

          return Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imagePath.isNotEmpty
                          ? NetworkImage(imagePath)
                          : AssetImage('asset/images/default_image.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone, color: Colors.green),
                          const SizedBox(width: 8.0),
                          Text(
                            'Hubungi Pembuat Berita: $contact',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
