import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/edit_profil.dart';

class BerhasilProfilScreen extends StatelessWidget {
  final String data;

  BerhasilProfilScreen({
    required this.data,
    super.key,
  });

  Future<void> saveProfileChanges(String data) async {
    try {
      // Dapatkan pengguna saat ini
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in.");
      }

      // Update dokumen pengguna di Firestore
      String documentId = user.uid; // Menggunakan uid sebagai document ID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .update({'data': data});

      print("Profile changes saved successfully.");
    } catch (e) {
      print("Error saving profile changes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Berhasil Menyimpan Perubahan',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await saveProfileChanges(data);

                  // Navigasi kembali ke EditProfilScreen dan kirimkan data
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilScreen(data: data),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'Selesai',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
