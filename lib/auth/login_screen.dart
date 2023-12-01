// login_screen.dart
import 'dart:convert';

import 'package:pengaduan/auth/register_screen.dart';
import 'package:pengaduan/home_page.dart';
import 'package:pengaduan/menus_page.dart';
import 'package:pengaduan/widget/input_field.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pengaduan/networks/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void loginUser() async {
    final data = {
      'email': email.text.toString(),
      'password': password.text.toString(),
    };

    final result = await API().postRequest(route: '/login', data: data);
    final response = jsonDecode(result.body);

    if (response != null) {
      if (response['status'] == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setInt('masyarakat_id', response['user']['id']);
        await preferences.setString('nama', response['user']['nama']);
        await preferences.setString('email', response['user']['email']);
        await preferences.setString('no_telp', response['user']['no_telp']);
        await preferences.setString('nik', response['user']['nik']);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message']),
            ),
          );
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MenusPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message'] ??
                  'Unknown Error', // Tambahkan default value jika response['message'] null
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
        print(response['message']);
      }
    } else {
      print('Error: Response is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/keluhan.png',
                  width: 200, // Sesuaikan dengan ukuran yang Anda inginkan
                  height: 200,
                ),
                SizedBox(height: 12),
                Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Silahkan Login',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 50),
                InputField(
                  controller: email,
                  hintText: 'Masukkan Email anda',
                ),
                SizedBox(height: 20),
                InputField(
                  controller: password,
                  hintText: 'Masukkan Password anda',
                  isObscure: true,
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    loginUser();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum Daftar?'),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      child: Text(
                        ' Daftar Sekarang',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
