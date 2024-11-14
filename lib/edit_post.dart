import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:myapp/berhasil_kirim.dart';
import 'dart:io';

class EditInfoScreen extends StatefulWidget {
  final String data;
  EditInfoScreen({required this.data, super.key});

  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController namaPengirimController = TextEditingController();
  final TextEditingController teksInfoController = TextEditingController();
  String? selectedCategory;
  String? fileURL;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        teleponController.text = userData['phone'] ?? '';
        namaPengirimController.text = userData['name'] ?? '';
      });
    }
  }

  Future<void> kirimDataKeFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String role = userData['role'] ?? 'user';
      String email = user.email ?? '';
      String status = role == 'admin' ? 'approved' : 'pending';

      CollectionReference informasi =
          FirebaseFirestore.instance.collection('informasi');

      // Create a data map and conditionally add fileURL if it exists
      Map<String, dynamic> data = {
        'judul': judulController.text,
        'nomorTelepon': teleponController.text,
        'namaPengirim': namaPengirimController.text,
        'teksInformasi': teksInfoController.text,
        'kategori': selectedCategory,
        'status': status,
        'tanggalUnggah': Timestamp.now(),
        'userEmail': email,
      };

      // Only add fileURL if it is not null
      if (fileURL != null) {
        data['fileURL'] = fileURL;
      }

      DocumentReference docRef = await informasi.add(data);

      await docRef.update({'id': docRef.id});
    }
  }

  Future<void> pilihDanUnggahFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      try {
        String fileName = file.name;
        Reference ref =
            FirebaseStorage.instance.ref().child('informasi/$fileName');
        await ref.putFile(File(file.path!));
        fileURL = await ref.getDownloadURL();
        setState(() {});
        print("File diunggah ke: $fileURL");
      } catch (e) {
        print("Terjadi kesalahan: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 60,
        title: const Text(
          'EDIT INFORMASI',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              TextField(
                controller: judulController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Judul Informasi',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              TextField(
                controller: teleponController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nomor Telepon',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              TextField(
                controller: namaPengirimController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nama Pengirim',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: teksInfoController,
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Teks Informasi',
                  labelStyle: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: pilihDanUnggahFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  'Unggah File',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Pilih Jenis Unggahan',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                dropdownColor: Colors.transparent,
                value: selectedCategory,
                hint: Text(
                  'Pilih Kategori',
                  style: TextStyle(color: Colors.white),
                ),
                items: ['Berita', 'Edukasi'].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                style: TextStyle(color: Colors.white),
                underline: Container(),
                iconEnabledColor: Colors.white,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedCategory != null) {
                      await kirimDataKeFirestore();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BerhasilKirimScreen(data: 'Postingan Saya'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Pilih kategori unggahan terlebih dahulu'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 15, 137, 207),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    'KIRIM',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
