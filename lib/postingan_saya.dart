import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/edit_post.dart';

class PostinganSayaScreen extends StatefulWidget {
  final String data;
  PostinganSayaScreen({required this.data, super.key});

  @override
  _PostinganSayaScreenState createState() => _PostinganSayaScreenState();
}

class _PostinganSayaScreenState extends State<PostinganSayaScreen> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userEmail = userDoc['email'];
        });
      }
    }
  }

  Stream<QuerySnapshot> _getUserPosts() {
    if (userEmail == null) {
      return Stream
          .empty(); // Return empty stream if userEmail is not retrieved yet
    }

    return FirebaseFirestore.instance
        .collection('informasi')
        .where('userEmail', isEqualTo: userEmail)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(8, 3, 51, 1),
        title: const Text(
          'POSTINGAN SAYA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF080333)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _getUserPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada postingan.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }

              final posts = snapshot.data!.docs;

              return ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  var post = posts[index];
                  String judul = post['judul'] ?? 'Tanpa Judul';
                  String status = post['status'] ?? 'Unknown';

                  return PostinganCard(
                    judul: judul,
                    status: status,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              KelolaPostinganScreen(data: post),
                        ),
                      );
                    },
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

class PostinganCard extends StatelessWidget {
  final String judul;
  final String status;
  final VoidCallback onTap;

  PostinganCard(
      {required this.judul, required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                judul,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            InkWell(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Kelola Postingan',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KelolaPostinganScreen extends StatelessWidget {
  final DocumentSnapshot data;
  KelolaPostinganScreen({required this.data});

  // Fungsi untuk mengubah status post di Firestore
  Future<void> deletePost() async {
    try {
      await FirebaseFirestore.instance
          .collection('informasi')
          .doc(data.id)
          .delete();
      print('Post deleted successfully');
    } catch (e) {
      print('Failed to delete post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('informasi')
            .doc(data.id)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Dokumen tidak ditemukan.'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(color: Color.fromRGBO(8, 3, 51, 1)),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(data['judul'] ?? 'Judul tidak ditemukan',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 16),
                        Text(
                            data['teksInformasi'] ??
                                'Keterangan tidak ditemukan',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(8, 3, 51, 1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Hapus Postingan'),
                          content: const Text(
                              'Apakah Anda yakin ingin hapus postingan ini?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await deletePost();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PostinganSayaScreen(data: 'Data')),
                                );
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child:
                      Text('HAPUS POST', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditInfoScreen(data: 'data'),
                      ),
                    );
                  },
                  child:
                      Text('EDIT POST', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
