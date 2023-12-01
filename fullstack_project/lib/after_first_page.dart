import 'package:flutter/material.dart';

void main() => runApp(const AfterFirstPage());

class AfterFirstPage extends StatefulWidget {
  const AfterFirstPage({Key? key}) : super(key: key);

  @override
  State<AfterFirstPage> createState() => _FirstPageAppState();
}

class _FirstPageAppState extends State<AfterFirstPage> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10, (i) => "아이템 $i");
  var items = <String>[];

  bool isDark = false;

  @override
  void initState() {
    items = duplicateItems;
    super.initState();
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
                  icon: const Icon(Icons.star_rounded), onPressed: () {}),
              actions: [
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                    child: IconButton(
                        icon: const Icon(Icons.person), onPressed: () {}),
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
                    child: Image.asset('assets/sidestar.PNG',
                        width: 350, height: 200, fit: BoxFit.contain),
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
        ));
  }
}
