<<<<<<< HEAD
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());
=======
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

/*void main() => runApp(const MyApp());*/
>>>>>>> 6533089 (로그인까지 서버 통신)

final List<int> colorCodes = [100, 500, 100];
final List<double> heights = [113, 113, 113];

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<MyApp> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10, (i) => "아이템 $i");
  var items = <String>[];

  bool isDark = false;

<<<<<<< HEAD
  @override
  void initState() {
    items = duplicateItems;
    super.initState();
  }

  void filterSearchResults(String query) {
=======
/*  @override
  void initState() {
    items = duplicateItems;
    super.initState();
  }*/

/*  void filterSearchResults(String query) {
>>>>>>> 6533089 (로그인까지 서버 통신)
    setState(() {
      items = duplicateItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
<<<<<<< HEAD
  }

=======
  }*/
  late HttpClientRequest httpRequest;
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
/*      ..headers.set('Authorization', userToken)*/
      ..headers.contentLength = searchword.length
      ..write(searchword);
    httpResponse = await httpRequest.close();
    httpResponseContent = await utf8.decoder.bind(httpResponse).join();
    setState(() {
      items = httpResponseContent;
    });
  }




>>>>>>> 6533089 (로그인까지 서버 통신)
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(useMaterial3: true);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.star_rounded), onPressed: () {}),
          actions: [
            Align(
              alignment: const AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                child: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {},
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
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
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 115,
                      color: Colors.amber[100],
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                                alignment:
                                    const AlignmentDirectional(0.00, 0.00),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'https://picsum.photos/seed/547/600',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-1.00, 1.00),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 15, 0, 0),
                                    child: Text(items[index]),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 3, 0, 3),
                                    child: Text('kfc 4.9'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(
                              child: Align(
                            alignment: AlignmentDirectional(1.00, 0.00),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('5.0'),
                                  Text(
                                    '10개',
                                  )
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
