import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'after_first_page.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                        '로그인',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: AlignmentDirectional(-1.00, 0.00),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(25, 65, 0, 0),
                      child: Text(
                        '아이디',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 18),
                      controller: idController,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: '아이디를 입력해주세요',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorText: idErrorText,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-1.00, 0.00),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 30, 0, 0),
                      child: Text(
                        labelText,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 18),
                      controller: passwordController,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: '비밀번호를 입력해주세요',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorText: pwErrorText,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0.00, 1.00),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          150, 200, 150, 0),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUPPage()));
                        },
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 25),
                            padding: const EdgeInsets.all(
                                7) // Adjust the height as needed
                            ),
                        child: const Text(
                          '회원가입',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(25, 10, 25, 30),
                    child: ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3C326),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 25),
                          padding: const EdgeInsets.all(
                              10) // Adjust the height as needed
                          ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
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
