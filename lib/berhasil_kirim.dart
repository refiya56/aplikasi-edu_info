import 'package:flutter/material.dart';
import 'package:myapp/beranda_user.dart';
import 'package:myapp/beranda_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BerhasilKirimScreen extends StatelessWidget {
  final String data;
  BerhasilKirimScreen({required this.data, super.key});

  Future<void> navigateToHome(BuildContext context) async {
    // Ambil email pengguna yang terautentikasi
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Ambil data pengguna dari Firestore
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userSnapshot.data();
      final userName = userData?['name'] ?? 'Pengguna';

      // Cek apakah pengguna adalah admin atau user biasa
      final userRole = userData?['role'] ?? 'user';
      if (userRole == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BerandaAdminScreen(data: userName),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BerandaUserScreen(data: userName),
          ),
        );
      }
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
                      'Postingan Anda Berhasil Terkirim',
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => navigateToHome(context),
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
