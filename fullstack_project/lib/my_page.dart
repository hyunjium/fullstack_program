import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'after_first_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int userToken = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? idErrorText;
  String? pwErrorText;
  String labelText = "비밀번호";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 30),
                    // Adjust the vertical offset as needed
                    child: const Align(
                      alignment: AlignmentDirectional(0.00, -1.00),
                      child: Text(
                        '마이페이지',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      idErrorText = null;
      pwErrorText = null;
    });
    // Get values from the controllers
    String id = idController.text;
    String password = passwordController.text;

    // Create a map with user information
    Map<String, dynamic> userinfo = {
      'id': id,
      'password': password,
    };

    // Encode the map to JSON
    String content = jsonEncode(userinfo);

    // Define server details
    var serverIp = InternetAddress.loopbackIPv4.host;
    var serverPort = 8080;
    var serverPath = "/api/0003";

    try {
      var response = await http.post(
        Uri.parse('http://10.0.2.2:$serverPort$serverPath'),
/*        Uri.parse('http://$serverIp:$serverPort$serverPath'),*/
        headers: {'Content-Type': 'application/json'},
        body: content,
      );

      if (response.statusCode == 200) {
        var content = response.body;
        var tokenHeader = response.headers['authorization'];
        if (tokenHeader != null && tokenHeader.isNotEmpty) {
          userToken = int.parse(tokenHeader[0]);
        } else {
          setState(() {
            labelText = '실패';
          });
        }
        if (content.toString() == 'Wrong ID') {
          setState(() {
            idErrorText = '존재하지 않는 아이디입니다';
          });
        } else if (content.toString() == 'Wrong PassWord!') {
          setState(() {
            pwErrorText = '비밀번호가 일치하지 않습니다';
          });
        } else {
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AfterFirstPage(userToken: userToken)));
          });
        }
      }
    } catch (error) {
      setState(() {
        labelText = 'Error: $error';
      });
    }
  }
}
