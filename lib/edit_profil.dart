import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilScreen extends StatefulWidget {
  final String data;
  const EditProfilScreen({required this.data, Key? key}) : super(key: key);

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch current user data to pre-fill the form
  void fetchUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot usersDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      Map<String, dynamic>? userData = usersDoc.data() as Map<String, dynamic>?;

      setState(() {
        _nameController.text = userData?['name'] ?? '';
        _phoneController.text = userData?['phone'] ?? '';
        _addressController.text = userData?['address'] ?? '';
        _emailController.text = userData?['email'] ?? '';
        _passwordController.text = userData?['password'] ?? '';
      });
    }
  }

  // Update profile data in Firebase
  void _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).update({
          'name': _nameController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        });

        // Display snackbar and navigate back after profile update
        ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(content: Text('Profil berhasil diperbarui!')),
            )
            .closed
            .then((_) {
          Navigator.pop(context); // Return to previous screen after snackbar
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EDIT PROFIL', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C2331),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Color(0xFF080333)),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                            SizedBox(height: 14),
                            TextFormField(
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
                            TextFormField(
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
                            TextFormField(
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
                            TextFormField(
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
                            TextFormField(
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
                              onPressed: _updateProfile,
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
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when screen is closed
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
