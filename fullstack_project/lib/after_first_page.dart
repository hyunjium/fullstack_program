import 'package:flutter/material.dart';

import 'my_page.dart';
import 'search.dart';
import 'star_page.dart';

class AfterFirstPage extends StatefulWidget {
  final int userToken;

  const AfterFirstPage({Key? key, required this.userToken}) : super(key: key);

  @override
  State<AfterFirstPage> createState() => _AfterFirstPageState();
}

class _AfterFirstPageState extends State<AfterFirstPage> {
  final dropdownList = ['메뉴', '가게'];
  String? _selectedDropdown;
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10, (i) => "아이템 $i");
  var items = <String>[];

  bool isDark = false;

  @override
  void initState() {
    items = duplicateItems;
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
                child: Text('경희대학교 국제캠퍼스'),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 80),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/sidestar.PNG',
                        width: 350, height: 150, fit: BoxFit.contain),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
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
                              userToken: widget.userToken,
                              selectedValue: selectedValue,
                            ),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                          labelText: "검색어를 입력하세요",
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
                ],
              ),
            ),
          ),
        ));
  }
}
