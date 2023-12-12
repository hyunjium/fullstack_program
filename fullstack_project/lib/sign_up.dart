import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fullstack_project/main.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';

class SignUPPage extends StatefulWidget {
  const SignUPPage({Key? key}) : super(key: key);

  @override
  State<SignUPPage> createState() => _SignUPPageState();
}

class _SignUPPageState extends State<SignUPPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? idErrorText;
  String? nicknameErrorText;
  String? numberErrorText;
  String labelText = "전화번호";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.house_rounded),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FirstPage()));
            },
            color: const Color(0xFF775B00),
            iconSize: 38,
          ),
        ),
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 0),
                    // Adjust the vertical offset as needed
                    child: const Align(
                      alignment: AlignmentDirectional(0.00, -1.00),
                      child: Text(
                        '회원가입',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: AlignmentDirectional(-1.00, 0.00),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(25, 35, 0, 0),
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
                  const Align(
                    alignment: AlignmentDirectional(-1.00, 0.00),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(25, 30, 0, 0),
                      child: Text(
                        '비밀번호',
                        style: TextStyle(fontSize: 18),
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
                      ),
                    ),
                  ),
                  const Align(
                    alignment: AlignmentDirectional(-1.00, 0.00),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(25, 30, 0, 0),
                      child: Text(
                        '닉네임',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 18),
                      controller: nicknameController,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: '닉네임을 입력해주세요',
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
                        errorText: nicknameErrorText,
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
                      controller: phoneNumberController,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: '전화번호를 입력해주세요',
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
                        errorText: numberErrorText,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0.00, 1.00),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(25, 50, 25, 30),
                      child: ElevatedButton(
                        onPressed: () {
                          signUp();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3C326),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 25),
                            padding: const EdgeInsets.all(
                                10) // Adjust the height as needed
                            ),
                        child: const Text(
                          '회원가입',
                          style: TextStyle(fontSize: 18),
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

  Future<void> signUp() async {
    setState(() {
      idErrorText = null;
      nicknameErrorText = null;
      numberErrorText = null;
    });
    // Get values from the controllers
    String id = idController.text;
    String password = passwordController.text;
    String nickname = nicknameController.text;
    String phoneNumber = phoneNumberController.text;

    // Create a map with user information
    Map<String, dynamic> userinfo = {
      'id': id,
      'password': password,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
    };

    // Encode the map to JSON
    String content = jsonEncode(userinfo);

    // Define server details
    var serverIp = InternetAddress.loopbackIPv4.host;
    var serverPort = 8080;
    var serverPath = "/api/0002";

    try {
      var response = await http.post(
/*        Uri.parse('http://10.0.2.2:$serverPort$serverPath'),*/
        Uri.parse('http://$serverIp:$serverPort$serverPath'),
        headers: {'Content-Type': 'application/json'},
        body: content,
      );

      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);
        if (content.toString() == 'existing_id') {
          setState(() {
            idErrorText = '이미 존재하는 아이디입니다';
          });
        } else if (content.toString() == 'existing_nickname') {
          setState(() {
            nicknameErrorText = '이미 존재하는 닉네임입니다';
          });
        } else if (content.toString() == 'existing_number') {
          setState(() {
            numberErrorText = '이미 존재하는 전화번호입니다';
          });
        } else {
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          });
        }
      } else {
        setState(() {
          labelText = '실패';
        });
      }
    } catch (error) {
      setState(() {
        labelText = 'Error: $error';
      });
    }
  }
}
