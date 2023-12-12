import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

import 'my_page.dart';
import 'star_page.dart';

class MyApp extends StatefulWidget {
  final String initialValue;
  final int userToken;
  final TextEditingController editingController = TextEditingController();
  final int selectedValue;

  MyApp(
      {Key? key,
      required this.initialValue,
      required this.userToken,
      required this.selectedValue})
      : super(key: key) {
    editingController.text = initialValue;
  }

  @override
  State<MyApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<MyApp> {
  final dropdownList = ['메뉴', '가게'];
  String? _selectedDropdown;
  final dropdownList2 = ['별점순', '리뷰순'];
  String? _selectedDropdown2;
  List<bool> isStarredList = <bool>[];
  TextEditingController editingController = TextEditingController();

  String labeltext = "";

  List<String> menuName = <String>[];
  List<String> storeName = <String>[];
  List<String> menuStar = <String>[];
  List<String> reviewNum = <String>[];
  List<String> image = <String>[];
  List<String> token = <String>[];

  bool isDark = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDropdown = dropdownList[0];
      if (widget.selectedValue == 2) {
        _selectedDropdown = dropdownList[1];
      }
      _selectedDropdown2 = dropdownList2[0];
    });
    filterSearchResults(widget.editingController.text);
  }

  Future<void> filterSearchResults(String query) async {
    String wordToSearch = query;
    var serverIp = InternetAddress.loopbackIPv4.host;
    var serverPort = 8080;
    var serverPath = "/api/0001";
    if (_selectedDropdown2 == "별점순") {
      if (widget.selectedValue == 2) {
        serverPath = "/api/0005";
      }
      if (_selectedDropdown == "가게") {
        serverPath = "/api/0005";
      } else {
        serverPath = "/api/0001";
      }
    } else {
      if (widget.selectedValue == 2) {
        serverPath = "/api/0011";
      }
      if (_selectedDropdown == "가게") {
        serverPath = "/api/0011";
      } else {
        serverPath = "/api/0010";
      }
    }

    try {
      var response = await http.post(
/*        Uri.parse('http://10.0.2.2:$serverPort$serverPath'),*/
        Uri.parse('http://$serverIp:$serverPort$serverPath'),
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
          isStarredList = List.filled(menuName.length, false);
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
/*        Uri.parse('http://10.0.2.2:$serverPort$serverPath'),*/
        Uri.parse('http://$serverIp:$serverPort$serverPath'),
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

  Future<void> onStarClick(var token, var click) async {
    var serverIp = InternetAddress.loopbackIPv4.host;
    var serverPort = 8080;
    var serverPath = "/api/0008";
    try {
      var response = await http.post(
/*        Uri.parse('http://10.0.2.2:$serverPort$serverPath'),*/
        Uri.parse('http://$serverIp:$serverPort$serverPath'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': widget.userToken.toString(),
          'tf': click.toString()
        },
        body: jsonEncode(token),
      );
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StarPage(userToken: widget.userToken)));
            },
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
                            builder: (context) =>
                                MyPage(userToken: widget.userToken)));
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
                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                child: TextField(
                  onSubmitted: (value) {
                    filterSearchResults(value);
                  },
                  controller: widget.editingController,
                  decoration: InputDecoration(
                      hintText: "검색어를 입력하세요",
                      suffixIcon: const Icon(Icons.search),
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButton(
                          value: _selectedDropdown,
                          items: dropdownList
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDropdown = value! as String;
                            });
                            // Handle dropdown value change
                          },
                        ),
                      ),
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButton(
                    value: _selectedDropdown2,
                    items: dropdownList2
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDropdown2 = value! as String;
                      });
                      // Handle dropdown value change
                    },
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
                              ]),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    // Toggle the starred status for this item
                                    isStarredList[index] =
                                        !isStarredList[index];
                                    onStarClick(
                                        token[index], isStarredList[index]);
                                  });
                                },
                                icon: Icon(
                                  Icons.star_rounded,
                                  color: isStarredList[index]
                                      ? const Color(0xFFF3C326)
                                      : Colors.grey,
                                ),
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
