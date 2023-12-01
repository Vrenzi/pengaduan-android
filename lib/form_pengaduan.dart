import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'menus_page.dart'; // Update with the correct import

class FormPengaduanPage extends StatefulWidget {
  final String? nik;
  final String? userName;

  FormPengaduanPage({required this.nik, required this.userName});

  @override
  _FormPengaduanPageState createState() => _FormPengaduanPageState();
}

class _FormPengaduanPageState extends State<FormPengaduanPage> {
  TextEditingController pengaduanController = TextEditingController();
  String selectedCategory = 'sosial';
  PlatformFile? pickedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  Future<void> _submitPengaduan() async {
    try {
      String apiUrl = "http://10.107.233.68:8000/api/pengaduan";

      Map<String, dynamic> pengaduanData = {
        'nik': widget.nik,
        'name': widget.userName,
        'isi_laporan': pengaduanController.text,
        'kategori': selectedCategory,
      };

      Map<String, String> pengaduanDataString = pengaduanData.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      if (pickedFile != null) {
        http.MultipartRequest request =
            http.MultipartRequest('POST', Uri.parse(apiUrl))
              ..fields.addAll(pengaduanDataString)
              ..files.add(
                await http.MultipartFile.fromPath(
                  'foto',
                  pickedFile!.path!,
                  contentType: MediaType('application', 'octet-stream'),
                ),
              );

        var response = await request.send();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80.0,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Pengaduan Submitted!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenusPage(),
                        ),
                      );
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to submit pengaduan. Please try again."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please choose a photo."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error submitting pengaduan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildChoosePhotoButton() {
    return ElevatedButton(
      onPressed: () {
        _pickFile();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue, // Set the text color to white
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text('Choose Photo'),
    );
  }

  Widget _buildCancelOrChangeButton() {
    if (pickedFile != null) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            pickedFile = null; // Menghapus file yang dipilih
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red, // Set the text color to white
        ),
        child: Text('Cancel Photo'),
      );
    } else {
      return Container(); // Jika tidak ada foto yang dipilih, tampilkan kontainer kosong
    }
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _submitPengaduan();
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // Set the background color to blue
        onPrimary: Colors.white, // Set the text color to white
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text('Submit Pengaduan'),
    );
  }

  Widget _buildPhotoPreview() {
    if (pickedFile != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Photo Preview:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Image.file(
              File(pickedFile!.path!),
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    } else {
      return Container(); // Empty container if no photo selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pengaduan', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Masukkan Pengaduan Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: pengaduanController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tuliskan pengaduan Anda...',
                  prefixIcon: Icon(Icons.file_copy_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kategori:'),
                  DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: ['sosial', 'infrastruktur'].map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Upload Foto:'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _pickFile();
                    },
                    child: Text('Choose Photo'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  _buildCancelOrChangeButton(), // Tombol Batal/Ganti
                ],
              ),
              // Display the picked file if available
              if (pickedFile != null)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 12,
                  child: Text(
                    'File: ${pickedFile!.name}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

              _buildPhotoPreview(),
              SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.green[300],
    );
  }
}
