import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

import 'my_page.dart';

class MyApp extends StatefulWidget {
  final String initialValue;
  final int userToken;
  final TextEditingController editingController = TextEditingController();

  MyApp({Key? key, required this.initialValue, required this.userToken})
      : super(key: key) {
    editingController.text = initialValue;
  }

  @override
  State<MyApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<MyApp> {
  TextEditingController editingController = TextEditingController();

  String labeltext = "못들어감";

  List<String> menuName = <String>[];
  List<String> storeName = <String>[];
  List<String> menuStar = <String>[];
  List<String> reviewNum = <String>[];
  List<String> image = <String>[];
  List<String> token = <String>[];

  bool isDark = false;

  @override
  void initState() {
    filterSearchResults(widget.editingController.text);
    super.initState();
  }

  Future<void> filterSearchResults(String query) async {
    String wordToSearch = query;
    var serverIp = InternetAddress.loopbackIPv4.host;
    var serverPort = 8080;
    var serverPath = "/api/0001";
    try {
      var response = await http.post(
        Uri.parse('http://10.0.2.2:$serverPort$serverPath'),
/*        Uri.parse('http://$serverIp:$serverPort$serverPath'),*/

        headers: {
          'Content-Type': 'application/json',
          'Authorization': widget.userToken.toString()
        },
        body: jsonEncode(wordToSearch),
      );

      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);
        Map<dynamic, List<dynamic>> map = {};
        String menu = content.replaceAll('{', '').replaceAll('}', '');
        List<dynamic> keys = [];
        for (var i = 0; i < menu.length; i++) {
          // Check if the current character is ':'
          if (':' == menu[i] && 's' != menu[i - 1]) {
            String index = "";
            if (i < 10) {
              for (var m = 0; m < i; m++) {
                index += menu[m];
              }
              keys.add(index);
            } else {
              String im = "";
              for (var beforeNum = 8; beforeNum > 0; beforeNum--) {
                im += menu[i - beforeNum];
              }
              keys.add(im.split(',')[1]);
            }
          }
        }
        List<dynamic> values = [];
        List<dynamic> sp = menu.split('[');
        for (var j in sp) {
          for (var k = 0; k < j.length; k++) {
            if (']' == j[k]) {
              String info = j.substring(0, k);
              List<dynamic> value = info.split(',');
              values.add(value);
            }
          }
        }
        for (var num = 0; num < keys.length; num++) {
          map[keys[num]] = values[num];
        }
        setState(() {
          token = map.keys.map((list) => list.toString()).toList();
          menuName = map.values.map((list) => list[0].toString()).toList();
          storeName = map.values
              .map((list) => list[1].toString() + list[4].toString())
              .toList();
          menuStar = map.values.map((list) => list[2].toString()).toList();
          reviewNum = map.values.map((list) => list[3].toString()).toList();
          image = map.values
              .map((list) => list[5].toString().replaceAll(' ', ''))
              .toList();
        });
      }
    } catch (error) {
      setState(() {
        labeltext = 'Error: $error';
      });
    }
  }

  Future<void> onItemClick(var token) async {
    var serverIp = InternetAddress.loopbackIPv4.host;
    var serverPort = 8080;
    var serverPath = "/api/0007";
    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:$serverPort$serverPath'),
/*        Uri.parse('http://$serverIp:$serverPort$serverPath'),*/

        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.toString(),
        },
      );

      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);

        if (await canLaunchUrlString(content.toString())) {
          await launchUrlString(content.toString());
        } else {
          setState(() {
            labeltext = content.toString();
          });
        }
      }
    } catch (error) {
      setState(() {
        labeltext = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(useMaterial3: true);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.star_rounded),
            onPressed: () {},
            color: const Color(0xFF775B00),
            iconSize: 38,
          ),
          actions: [
            Align(
              alignment: const AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                child: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyPage(userToken: widget.userToken)));
                  },
                  color: const Color(0xFF775B00),
                  iconSize: 38,
                ),
              ),
            ),
          ],
          title: const Align(
            alignment: AlignmentDirectional(0.00, 0.00),
            child: Text("경희대학교 국제캠퍼스"),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
                child: TextField(
                  onSubmitted: (value) {
                    filterSearchResults(value);
                  },
                  controller: widget.editingController,
                  decoration: const InputDecoration(
                      hintText: "검색어를 입력하세요",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0)))),
                ),
              ),
              Align(
                child: Text(labeltext),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: menuName.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          onItemClick(token[index]);
                        },
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                )
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                    alignment:
                                        const AlignmentDirectional(0.00, 0.00),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: image[index] != 'null'
                                          ? Image.network(
                                              image[index],
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/emptyimage.png',
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            ),
                                    )),
                              ),
                              Align(
                                alignment:
                                    const AlignmentDirectional(-1.00, 1.00),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Text(
                                        menuName[index],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 0),
                                      child: Text(storeName[index],
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey)),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                alignment:
                                    const AlignmentDirectional(1.00, 0.00),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 15, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        menuStar[index],
                                        style: const TextStyle(
                                            fontSize: 22, color: Colors.grey),
                                      ),
                                      Text(
                                        '${reviewNum[index]}개',
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ));
                  },
                  separatorBuilder: (BuildContext, int index) =>
                      const Divider(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
