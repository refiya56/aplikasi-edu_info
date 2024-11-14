import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'profil.dart';
import 'edit_profil.dart';
import 'first_page.dart';
import 'entry_login.dart';
import 'registrasi.dart';
import 'berhasil_masuk.dart';
import 'berhasil_kirim.dart';
import 'beranda_user.dart';
import 'unggah_info.dart';
import 'baca_berita.dart';
import 'baca_edukasi.dart';
import 'detail_berita.dart';
import 'detail_edukasi.dart';
import 'laporkan_postingan.dart';
import 'postingan_saya.dart';
import 'beranda_admin.dart';
import 'kotak_masuk.dart';
import 'blokir.dart';
import 'gagal_masuk.dart';
import 'logout.dart';
import 'hapus_postingan.dart';
import 'berhasil_simpan_profil.dart';
import 'berhasil_registrasi.dart';
import 'blokir_akun.dart';
import 'admin_unggah.dart';
import 'edit_post.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 125, 2, 2)),
        useMaterial3: true,
      ),
      home: FirstPageScreen(
        data: '',
      ),
    );
  }
}
