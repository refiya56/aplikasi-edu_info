import 'package:flutter/material.dart';
import 'package:myapp/beranda_user.dart';
import 'package:myapp/beranda_admin.dart';

class BerhasilMasukScreen extends StatelessWidget {
  final String data; // Nama pengguna
  final String role; // Tipe pengguna

  BerhasilMasukScreen({required this.data, required this.role, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF080333)),
        child: Center(
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
                      'Login Anda Berhasil!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10), // Menambahkan sedikit jarak
                    Text(
                      'Selamat datang, $data!', // Menyapa pengguna dengan nama
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Pengecekan berdasarkan tipe pengguna
                  if (role == 'admin') {
                    // Jika admin, arahkan ke halaman beranda admin
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BerandaAdminScreen(data: data),
                      ),
                    );
                  } else {
                    // Jika user, arahkan ke halaman beranda user
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BerandaUserScreen(data: data),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'Masuk',
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
