import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/entry_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/beranda_admin.dart';
import 'package:myapp/beranda_user.dart';

class FirstPageScreen extends StatefulWidget {
  final String data;
  FirstPageScreen({required this.data, Key? key}) : super(key: key);

  @override
  _FirstPageScreenState createState() => _FirstPageScreenState();
}

class _FirstPageScreenState extends State<FirstPageScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // Method to check user authentication and navigate accordingly
  Future<void> _checkAuthentication() async {
    // Show splash screen for 3 seconds
    await Future.delayed(Duration(seconds: 3));

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, check their role
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        // Check if the user has a role field
        String role = userDoc.get('role');
        if (role == 'admin') {
          // Navigate to Admin Home Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BerandaAdminScreen(
                      data: '',
                    )),
          );
        } else {
          // Navigate to User Home Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BerandaUserScreen(
                      data: '',
                    )),
          );
        }
      } else {
        // User document doesn't exist, navigate to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EntryLoginScreen(
                    data: '',
                  )),
        );
      }
    } else {
      // User is not logged in, navigate to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EntryLoginScreen(
                  data: '',
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Color.fromRGBO(8, 3, 51, 1)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              Image.asset(
                'asset/images/logo.png',
                height: 200,
                width: 200,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Menyediakan Informasi dan Edukasi Terlengkap',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
