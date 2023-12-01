import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(const FirstPage());

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageAppState();
}

class _FirstPageAppState extends State<FirstPage> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10, (i) => "아이템 $i");
  var items = <String>[];

  bool isDark = false;

  @override
  void initState() {
    items = duplicateItems;
    super.initState();
  }

/*  void filterSearchResults(String query) {
    setState(() {
      items = duplicateItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }*/
 /* late HttpClientRequest httpRequest;
  late HttpClientResponse httpResponse;
  var httpResponseContent;
  var httpClient = HttpClient();
  var serverIp = InternetAddress.loopbackIPv4.host;
  var serverPort = 4040;
  int userToken = 1;
  void filterSearchResults(String query) async {
    var searchword = jsonEncode(query);
    var serverPath = "/api/0001";
    httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
      ..headers.contentType = ContentType.json
*//*      ..headers.set('Authorization', userToken)*//*
      ..headers.contentLength = searchword.length
      ..write(searchword);
    httpResponse = await httpRequest.close();
    httpResponseContent = await utf8.decoder.bind(httpResponse).join();
    setState(() {
      items = httpResponseContent;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(useMaterial3: true);

    return MaterialApp(
      theme: themeData,
        home: Builder(
        builder: (context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.star_rounded), onPressed: () {}),
          actions: [
            Align(
              alignment: const AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  child: const Text('로그인'),
                ),
              ),
            ),
          ],
          title: const Align(
            alignment: AlignmentDirectional(0.00, 0.00),
            child: Text('경희대학교 국제캠퍼스'),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/sidestar.PNG', width: 350, height: 200,
                fit: BoxFit.contain),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    duplicateItems;
                  },
                  controller: editingController,
                  decoration: const InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
            ],
          ),
        ),
      ),
        )
    );
  }
}