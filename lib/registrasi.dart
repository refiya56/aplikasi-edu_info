import 'package:flutter/material.dart';
import 'package:myapp/berhasil_registrasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrasiScreen extends StatefulWidget {
  final String data;
  const RegistrasiScreen({required this.data, super.key});

  @override
  _RegistrasiScreenState createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Kontroller untuk field input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'user'; // Default role untuk pengguna biasa

  // Fungsi untuk mendaftarkan pengguna
  Future<void> _registerUser() async {
    try {
      // Mendaftarkan pengguna di Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final userId = userCredential.user!.uid;
      final userName = _nameController.text;

      // Simpan data pengguna ke Firestore
      await _firestore.collection('users').doc(userId).set({
        'name': userName,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'role': _selectedRole, // Menyimpan role user di Firestore
      });

      // Navigasi ke layar berhasil registrasi dengan nama pengguna dan peran
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BerhasilRegistrasiScreen(
            data: userName,
            role: _selectedRole,
          ),
        ),
      );
    } catch (e) {
      print('Error: $e');
      // Tambahkan notifikasi kesalahan jika diperlukan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Color(0xFF080333)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                            'REGISTRASI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 14),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nama',
                              labelStyle:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 14),
                          TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'No.Telp',
                              labelStyle:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 14),
                          TextField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Alamat',
                              labelStyle:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            style: TextStyle(color: Colors.white),
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
                          SizedBox(height: 14),

                          // Dropdown untuk memilih role
                          DropdownButton<String>(
                            value: _selectedRole,
                            items:
                                <String>['user', 'admin'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRole = newValue!;
                              });
                            },
                            dropdownColor: Colors.black,
                          ),

                          const SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            child: const Text(
                              'KONFIRMASI',
                              style: TextStyle(color: Colors.black),
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
      ),
    );
  }
}
