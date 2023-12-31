import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_page.dart';
import 'search.dart';

void main() => runApp(const FirstPage());

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageAppState();
}

class _FirstPageAppState extends State<FirstPage> {
  final dropdownList = ['메뉴', '가게'];
  String? _selectedDropdown;
  final int userToken = 0;

  TextEditingController editingController = TextEditingController();

  bool isDark = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDropdown = dropdownList[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(useMaterial3: true);

    return MaterialApp(
        theme: themeData,
        home: Builder(
            builder: (context) => Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.star_rounded),
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "즐겨찾기는 로그인 후에 이용 가능합니다",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: const Color(0xFF775B00),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    color: const Color(0xFF775B00),
                    iconSize: 38,
                  ),
                  actions: [
                    Align(
                      alignment: const AlignmentDirectional(0.00, 0.00),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF775B00),
                              foregroundColor: Colors.white),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 80),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/sidestar.PNG',
                            width: 350,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15, 0, 15, 15),
                          child: TextField(
                            controller: editingController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              int selectedValue;
                              if (_selectedDropdown == '메뉴') {
                                selectedValue = 1;
                              } else {
                                selectedValue = 2;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyApp(
                                    initialValue: value,
                                    userToken: userToken,
                                    selectedValue: selectedValue,
                                  ),
                                ),
                              );
                            },
                            decoration: InputDecoration(
                              labelText: "검색어를 입력하세요",
                              hintText: "검색어를 입력하세요",
                              suffixIcon: const Icon(Icons.search),
                              // Search icon is now the suffixIcon
                              prefixIcon: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
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
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(15, 10, 15, 15),
                          child: Text(
                            "즐겨찾기는 로그인 후에 이용 가능합니다",
                            style: TextStyle(
                              fontSize: 15.0, // Adjust the font size as needed
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
