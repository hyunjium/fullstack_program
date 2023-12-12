import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'after_first_page.dart';

class StarPage extends StatefulWidget {
  final int userToken;

  StarPage({Key? key, required this.userToken}) : super(key: key);

  @override
  State<StarPage> createState() => _StarPageState();
}

class _StarPageState extends State<StarPage> {
  int userToken = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> menuName = <String>[];
  List<String> storeName = <String>[];
  List<String> menuStar = <String>[];
  List<String> reviewNum = <String>[];
  List<String> image = <String>[];
  List<String> token = <String>[];

  @override
  void initState() {
    starResults();
    super.initState();
  }

  Future<void> starResults() async {
    var serverIp = InternetAddress.loopbackIPv4.host;
    var serverPort = 8080;
    var serverPath = "/api/0009";
    try {
      var response = await http.get(
/*          Uri.parse('http://10.0.2.2:$serverPort$serverPath'),*/
          Uri.parse('http://$serverIp:$serverPort$serverPath'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': widget.userToken.toString()
          });

      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);

        String cleanedString = content.substring(2, content.length - 1);
        List<String> mapStrings = cleanedString.split('{');
        Map<String, List<dynamic>> resultMap = {};

        for (String mapString in mapStrings) {
          // Split each string by ": " to separate key and value
          List<String> parts = mapString.split(": ");

          // Extract key
          String key = parts[0].trim();

          // Extract value and remove unnecessary characters
          String valueString =
              mapString.substring(parts[0].length + 3, mapString.length - 1);
          List<dynamic> value = valueString.split(', ').map((element) {
            if (element.startsWith("https")) {
              return element.trim();
            } else if (element.contains(RegExp(r'[0-9]'))) {
              return double.parse(element.trim());
            } else {
              return element.trim();
            }
          }).toList();

          // Add key-value pair to the result map
          resultMap[key] = value;
        }

        setState(() {
          token = resultMap.keys.map((list) => list.toString()).toList();
          menuName =
              resultMap.values.map((list) => list[0].toString()).toList();
          storeName = resultMap.values
              .map((list) => "${list[1] + " "}${list[5]}")
              .toList();
          menuStar = resultMap.values
              .map(
                  (list) => double.parse(list[2].toStringAsFixed(1)).toString())
              .toList();
          reviewNum = resultMap.values
              .map((list) => list[3].toInt().toString())
              .toList();
          image = resultMap.values
              .map((list) => list[6].toString().replaceAll(' ', ''))
              .toList();
          image = image.map((imageUrl) => imageUrl.split(']')[0]).toList();
        });
      }
    } catch (error) {
      setState(() {
        Fluttertoast.showToast(
            msg: 'Error: $error',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color(0xFF775B00),
            textColor: Colors.white,
            fontSize: 16.0);
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
      }
    } catch (error) {
      setState(() {});
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
            icon: const Icon(Icons.house_rounded),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AfterFirstPage(userToken: widget.userToken)));
            },
            color: const Color(0xFF775B00),
            iconSize: 38,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                child: Text(
                  '즐겨찾기',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                          ],
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.star_rounded,
                              ),
                              color: const Color(0xFFF3C326),
                            ),
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
                                ),
                              ),
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
                                    child: Text(
                                      storeName[index],
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
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
                              ),
                            )
                          ],
                        ),
                      ),
                    );
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
