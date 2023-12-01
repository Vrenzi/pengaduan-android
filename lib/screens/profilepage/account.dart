import 'package:pengaduan/auth/login_screen.dart';
import 'package:pengaduan/history_pengaduan.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  late SharedPreferences preferences;
  bool isLoading = true;
  String? userName;
  String? phoneNumber;
  String? nik;

  late int userId;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    preferences = await SharedPreferences.getInstance();
    final storedUserId = preferences.getInt('masyarakat_id');
    final storedName = preferences.getString('nama');
    final storedPhoneNumber = preferences.getString('email');
    final storedNIK = preferences.getString('no_telp');

    if (storedUserId != null && storedName != null) {
      if (mounted) {
        setState(() {
          isLoading = false;
          userId = storedUserId;
          userName = storedName;
          // Add the following lines to store additional information
          // Replace 'No Telepon' and 'NIK' with your actual SharedPreferences keys
          phoneNumber = storedPhoneNumber;
          nik = storedNIK;
        });
      }
    }
  }

  void handleProfileUpdated() {
    getUserData(); // Perbarui data profil saat profil diperbarui
  }

  void showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                doLogout(); // Panggil fungsi logout
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void doLogout() {
    preferences.clear();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Tambahkan baris ini
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Profile Box
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    // userImage ??
                                    'https://cdn-icons-png.flaticon.com/512/1144/1144760.png',
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          userName ?? 'User',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              8), // Spasi antara teks nama dan "Edit Profile"
                                      TextButton(
                                        onPressed: () {
                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(
                                          //     builder: (context) => EditProfile(
                                          //       userId: userId,
                                          //       onProfileUpdated:
                                          //           handleProfileUpdated,
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                        child: Text(
                                          'Edit Profile',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Informasi Profil
                          Container(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informasi Profil',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                // Nama
                                _buildInfoRow(
                                    'Nama', userName ?? 'Belum diatur'),
                                // Divider
                                Divider(color: Colors.grey),
                                const SizedBox(
                                  height: 10,
                                ),
                                // No Telepon
                                _buildInfoRow(
                                    'Email', phoneNumber ?? 'Belum diatur'),
                                // Divider
                                Divider(color: Colors.grey),
                                const SizedBox(
                                  height: 10,
                                ),
                                // NIK
                                _buildInfoRow('NIK', nik ?? 'Belum diatur'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                showLogoutConfirmationDialog();
                              },
                              child: Icon(
                                Icons.arrow_right,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'History Keluhan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PengaduanHistory(),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.arrow_right,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      backgroundColor: Colors.green[300],
    );
  }
}

Widget _buildInfoRow(String heading, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        heading,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(value),
    ],
  );
}
