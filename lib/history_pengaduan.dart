import 'package:pengaduan/emptyhistory.dart';
import 'package:pengaduan/helper/constant.dart';
import 'package:pengaduan/history_pengaduan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PengaduanHistory extends StatefulWidget {
  const PengaduanHistory({Key? key}) : super(key: key);

  @override
  _PengaduanHistoryState createState() => _PengaduanHistoryState();
}

class _PengaduanHistoryState extends State<PengaduanHistory> {
  List<Map<String, dynamic>> pengaduan = [];

  @override
  void initState() {
    super.initState();
    getpengaduans();
  }

  Future<void> getpengaduans() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? nik = preferences.getString('nik');

    if (nik != null) {
      final response = await http.get(
        Uri.parse('$apiUrl/pengaduan/$nik'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('pengaduan')) {
          final List<dynamic> data = responseData['pengaduan'];

          if (mounted) {
            setState(() {
              pengaduan = List<Map<String, dynamic>>.from(data);
              pengaduan.forEach((pengaduan) {
                if (pengaduan['status'] == null ||
                    pengaduan['status'].isEmpty) {
                  pengaduan['status'] = '0';
                }
              });

              pengaduan.sort((a, b) {
                DateTime timestampA = DateTime.parse(a['created_at']);
                DateTime timestampB = DateTime.parse(b['created_at']);
                return timestampB.compareTo(timestampA);
              });
            });
          }
        }
      }
    }
  }

  Color getStatusColor(String? status) {
    if (status == 'baru') {
      return Colors.blue;
    } else if (status == 'diproses') {
      return Colors.orange;
    } else if (status == 'selesai') {
      return Colors.green;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaduan History'),
      ),
      body: pengaduan.isEmpty
          ? PengaduanEmpty()
          : ListView.builder(
              itemCount: pengaduan.length,
              itemBuilder: (context, index) {
                final pengaduans = pengaduan[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      // Tambahkan tindakan ketika kartu ditekan
                    },
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                '$apiUrl/image/${pengaduans['id']}',
                width: 200, // Adjust the width as needed
                height: 200, // Adjust the height as needed
                ),

                            ListTile(
                              title: Text(
                                pengaduans['nik'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text(
                               pengaduans['tgl_pengaduan'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: Text(
                              pengaduans['kategori'],
                              )
                            ),
                            ListTile(
                              title: Text(
                                // 'Menu: ${menuNames[pengaduan['menu_id']]}',
                                pengaduans['isi_laporan'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                           
                            
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              // color: getStatusColor(pengaduan['status']),
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(4),
                              ),
                            ),
                            child: Text(
                               pengaduans['status'],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            backgroundColor: Colors.green[300],
    );
  }
}
