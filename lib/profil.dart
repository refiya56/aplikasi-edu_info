import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/edit_profil.dart';
import 'package:myapp/entry_login.dart';

class ProfilScreen extends StatefulWidget {
  final String data;
  ProfilScreen({required this.data, super.key});

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  void _logout(BuildContext context) async {
    await _auth.signOut(); // Logout dari Firebase
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => EntryLoginScreen(data: widget.data)),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFIL', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C2331),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Color.fromRGBO(8, 3, 51, 1)),
        child: Center(
          child: userData == null
              ? CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            Colors.grey[300], // Background warna default
                        child: userData?['profileImageUrl'] != null
                            ? ClipOval(
                                child: Image.network(
                                  userData?['profileImageUrl'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey, // Warna icon profil
                              ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            buildProfileRow('Nama', userData?['name'] ?? ''),
                            buildProfileRow(
                                'No. Telp', userData?['phone'] ?? ''),
                            buildProfileRow(
                                'Alamat', userData?['address'] ?? ''),
                            buildProfileRow('E-Mail', userData?['email'] ?? ''),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilScreen(
                                    data: 'Edit Profil',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            child: const Text('EDIT PROFIL',
                                style: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Konfirmasi Logout'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin logout?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Tutup dialog
                                          _logout(
                                              context); // Panggil fungsi logout
                                        },
                                        child: const Text('Konfirmasi'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            child: const Text('LOG-OUT',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildProfileRow(String title, String value) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }
}
