import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  final int userToken;

  const MyPage({Key? key, required this.userToken}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String nickname = "";
  String id = "";
  String number = "";

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<void> getInfo() async {
    var serverIp = InternetAddress.loopbackIPv4.host;
    var serverPort = 8080;
    var serverPath = "/api/0004";
    try {
      var response = await http.get(
          Uri.parse('http://10.0.2.2:$serverPort$serverPath'),
/*        Uri.parse('http://$serverIp:$serverPort$serverPath'),*/

          headers: {
            'Content-Type': 'application/json',
            'Authorization': widget.userToken.toString()
          });

      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);
        setState(() {
          nickname = content[2];
          id = content[0];
          number = content[3];
        });
      }
    } catch (error) {
      setState(() {
        nickname = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(30, 40, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 40.0, color: Colors.black),
                  const SizedBox(width: 15.0),
                  Text(
                    nickname,
                    style: const TextStyle(fontSize: 23.0),
                  ),
                  const SizedBox(width: 30.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF775B00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the radius as needed
                      ),
                    ),
                    child: const Text(
                      '변경',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const Text('ID',
                      style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                  const SizedBox(width: 270.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF775B00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the radius as needed
                      ),
                    ),
                    child: const Text(
                      '변경',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Text(id, style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const Text('전화번호',
                      style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                  const SizedBox(width: 220.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF775B00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the radius as needed
                      ),
                    ),
                    child: const Text(
                      '변경',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Text(number, style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 240.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF775B00),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 25),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Adjust the radius as needed
                  ),
                ),
                child: const Text(
                  '비밀번호 변경',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF3C326),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 25),
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Adjust the radius as needed
                  ), // Adjust the height as needed
                ),
                child: const Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
