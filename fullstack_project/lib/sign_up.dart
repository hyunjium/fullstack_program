import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

void main() => runApp(const SignUPPage());

class SignUPPage extends StatefulWidget {
  const SignUPPage({Key? key}) : super(key: key);

  @override
  _SignUPPageWidgetState createState() => _SignUPPageWidgetState();
}

class _SignUPPageWidgetState extends State<SignUPPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String labelText = "전화번호";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Align(
                alignment: AlignmentDirectional(0.00, -1.00),
                child: Text(
                  '회원가입',
                  textAlign: TextAlign.justify,
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 80, 0, 0),
                  child: Text(
                    '아이디',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                child: TextFormField(
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
                  ),
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                  child: Text(
                    '비밀번호',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                child: TextFormField(
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
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                  child: Text(
                    '닉네임',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                child: TextFormField(
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
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                  child: Text(
                    labelText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                child: TextFormField(
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
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.00, 1.00),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      signUp();
                    },
                    child: const Text('회원가입'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
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
        Uri.parse('http://10.0.2.2:$serverPort$serverPath'),
        headers: {'Content-Type': 'application/json'},
        body: content,
      );

      if (response.statusCode == 200) {
        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        });
      } else {
        setState(() {
          labelText = '실패';
        });
      }
    } catch (error) {
      setState(() {
        labelText = 'Error: $error';
      });
      // Handle errors
      print('Error: $error');
    }
  }
}