import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/berhasil_masuk.dart';
import 'package:myapp/registrasi.dart';
import 'package:myapp/beranda_user.dart'; // Pastikan untuk mengimpor beranda_user.dart

class LoginScreen extends StatelessWidget {
  final String data;

  LoginScreen({required this.data, super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kontroller untuk input email dan password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi login dan cek tipe pengguna
  Future<void> _loginUser(BuildContext context) async {
    try {
      // Autentikasi email dan password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Ambil data user dari Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Arahkan ke beranda berdasarkan tipe pengguna
      if (userDoc.exists) {
        String userType =
            userDoc['role']; // Pastikan ini sesuai dengan field di Firestore
        String userName = userDoc['name']; // Ambil nama pengguna dari Firestore

        if (userType == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BerhasilMasukScreen(
                    data: userName, role: userType)), // Kirim nama dan role
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BerandaUserScreen(data: userName)), // Kirim nama pengguna
          );
        }
      }
    } catch (e) {
      print('Login failed: $e');
      // Tampilkan dialog atau snackbar untuk kesalahan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Silakan periksa email dan password Anda.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Color.fromRGBO(8, 3, 51, 1)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  color: Colors.black,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 14),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'E-Mail',
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 14),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () =>
                              _loginUser(context), // Memanggil fungsi login
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          child: const Text(
                            'LOG-IN',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Jika belum mempunyai akun',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RegistrasiScreen(data: 'Masuk Registrasi'),
                              ),
                            );
                          },
                          child: const Text(
                            'Silahkan Registrasi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.yellow,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
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
