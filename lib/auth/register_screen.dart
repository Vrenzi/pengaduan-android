import 'dart:convert';

import 'package:pengaduan/auth/login_screen.dart';
import 'package:pengaduan/networks/api.dart';
import 'package:pengaduan/helper/constant.dart';
import 'package:pengaduan/networks/api.dart';
import 'package:pengaduan/auth/login_screen.dart';
import 'package:pengaduan/widget/input_field.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nik = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController no_telp = TextEditingController();

  void registerUser() async {
    final data = {
      'nik': nik.text.toString(),
      'nama': nama.text.toString(),
      'email': email.text.toString(),
      'no_telp': no_telp.text.toString(),
      'password': password.text.toString(),
    };
    final result = await API().postRequest(route: '/register', data: data);
    final response = jsonDecode(result.body);
    if (response['status'] == 200) {  
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
      backgroundColor: Colors.green[300],
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Daftar Dulu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Lengkapi data diri kamu!',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 50),
              InputField(
                controller: nik,
                hintText: 'Masukkan NIK Anda',
              ),
              SizedBox(height: 20),

              InputField(
                controller: nama,
                hintText: 'Masukkan Nama Anda',
              ),
              SizedBox(height: 20),
              InputField(
                controller: email,
                hintText: 'Masukkan Email Anda',
              ),
              SizedBox(height: 20),
              InputField(
                  controller: no_telp, hintText: 'Masukkan No Telepon Anda'),

              SizedBox(height: 20),
              InputField(
                controller: password,
                hintText: 'Masukkan Password Anda',
                isObscure: true,
              ),
              SizedBox(height: 80),

              // Sign in button
              InkWell(
                onTap: () {
                  registerUser();
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
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )),
                  ),
                ),
              ),
              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sudah Punya Akun?'),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      ' Login Yuk',
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
      )),
    );
  }
}
