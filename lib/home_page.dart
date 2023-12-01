import 'package:pengaduan/form_pengaduan.dart';

import 'package:pengaduan/helper/constant.dart';
import 'package:pengaduan/helper/pengaduan_box.dart';
import 'package:pengaduan/screens/profilepage/account.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences preferences;
  List Pengaduans = [
    ["Ajukan Keluhan", "assets/images/complaint.png"],
    ["Ajukan complaint", "assets/images/complaint.png"],
  ];
  String? userName;

  late int userId;
  String? NIK;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    preferences = await SharedPreferences.getInstance();
    final storedUserId = preferences.getInt('masyarakat_id');
    print(storedUserId);
    final storedName = preferences.getString('nama');
    final storedNik = preferences.getString('nik');

    if (storedUserId != null && storedName != null) {
      if (mounted) {
        setState(() {
          userId = storedUserId;
          userName = storedName;
          NIK = storedNik;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.abc,
                    size: 45,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.notifications,
                    size: 45,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Home,",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    userName ?? "PENGGUNA",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Divider(
                color: Colors.grey[400],
                thickness: 1,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Pilihan Pengaduan",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.grey[800]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Hanya menampilkan item "Complaint"
                GestureDetector(
                  onTap: () {
                    // Navigate to the second page when the second box is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPengaduanPage(
                          nik: NIK,
                          userName: userName,
                        ),
                      ),
                    );
                  },
                  child: PengaduanBox(
                    title: Pengaduans[0]
                        [0], // Menggunakan indeks 0 untuk "Complaint"
                    imagePath: Pengaduans[0][1],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
