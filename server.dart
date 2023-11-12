import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

Future main() async {
  int usernumber = 0;
  var db = {};
  var loginInfo = <dynamic, dynamic>{};
  var searchword_db = {};
  final file = File('apple.xlsx'); // 엑셀 파일 경로

  var server = await HttpServer.bind(
    InternetAddress.loopbackIPv4, // ip address
    4040, // port number
  );

  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  printHttpServerActivated(server);

  await for (HttpRequest request in server) {
    if (request.uri.path.contains('/api/') == true) {
      printHttpRequestInfo(request);
      try {
        switch (request.uri.path) {
          case '/api/0001': // Read
            readMenuInfo(excel, request, searchword_db);
            break;
          case '/api/0002': // Create
            createId(db, request, usernumber, searchword_db);
            break;
          case '/api/0003': // Read
            login(db, loginInfo, request, searchword_db);
            break;
          default:
            print("\$ Unsupported http method");
        }
      } catch (err) {
        print("\$ Exception in http request processing");
      }
    } else {
      print("${request.method} {ERROR: Unsupported API}");
    }
  }
}

void printHttpServerActivated(HttpServer server) {
  var ip = server.address.address;
  var port = server.port;
  print('\$ Server activated in ${ip}:${port} \n');
}

void printHttpRequestInfo(HttpRequest request) async {
  var ip = request.connectionInfo!.remoteAddress.address;
  var port = request.connectionInfo!.remotePort;
  var method = request.method;
  var path = request.uri.path;
  print("\$ $method $path from $ip:$port");

  if (request.headers.contentLength != -1) {
    print("> content-type   : ${request.headers.contentType}");
    print("> content-length : ${request.headers.contentLength}");
  }
}

void printAndSendHttpResponse(var db, var request, var content) async {
  request.response
    ..headers.contentType = ContentType('text', 'plain', charset: "utf-8")
    ..statusCode = HttpStatus.ok
    ..write(content);
  await request.response.close();
}

void readMenuInfo(var excel, var request, var searchword_db) async {
  var content = await utf8.decoder.bind(request).join();
  var searchInfo = jsonDecode(content) as List;
  List recentSearch = [];
  if (searchword_db[searchInfo[0]] != null){
    recentSearch.add(searchword_db[searchInfo[0]]);
  }

  print("> Find the word '${searchInfo[1]}' in it");
  if (searchword_db[searchInfo[0]] == null){
    searchword_db[searchInfo[0]] = searchInfo[1];
  } else {
    searchword_db[searchInfo[0]].add(searchInfo[1]);
  }
  
  if (excel != null) {
    Map data = {};
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table]!;

      for (var row in sheet.rows) {
        List rowData = [];
        var cell;
        for (cell in row) {
          rowData.add(cell.value);
        }

        if (rowData[0].toString().contains(searchInfo[1])) {
          data[rowData[0]] = [rowData[1],rowData[2]];
          }
        }
      }
    print("> Found \n $data");
    recentSearch.add(data);

    print("\$ Send to Client \n");
    request.response
      ..headers.contentType = ContentType('text', 'plain', charset: "utf-8")
      ..statusCode = HttpStatus.ok
      ..write(recentSearch);
  } else {
    // Handle the case when 'excel' is null
    print("\$ 'excel' object is null.");
    request.response
      ..statusCode = HttpStatus.internalServerError
      ..write("Internal Server Error");
  }

  await request.response.close();
}


void createId(var db, var request, int usernumber, var searchword_db) async {
  var content = await utf8.decoder.bind(request).join();
  var transaction = jsonDecode(content) as List;

  print("> user_info \n $content");

  if (db.isEmpty) {
    usernumber++;
    db[usernumber] = transaction;
    content = "Success < $transaction created >";
  } else {
    db.forEach((key, value) {
      if (value.isNotEmpty && value[0] == transaction[0]) {
        content = "Fail < ${transaction[0]} already exists >";
      } else {
        usernumber++;
        db[usernumber] = transaction;
        searchword_db[usernumber] = null;
        content = "Success < $transaction created >";
      }
    });
  }
  print("\$ Saved user_info $db \n");
  printAndSendHttpResponse(db, request, content);
}


void login(var db, var loginInfo, var request, var searchword_db) async {
  var content = await utf8.decoder.bind(request).join();
  var transaction = jsonDecode(content) as List;

  print("> login_info \n $content \n");

    if (db.isEmpty) {
      content = "Please create account \n";
    } else {
      db.forEach((key, value) {
        if (value.isNotEmpty && value[0] == transaction[0]) {
          if(value.isNotEmpty && value[1] == transaction[1]) {
            if (searchword_db[key] == null){
              content = "$key Login Success! \n";
            }else {
              content = "$key Login Success! \n ${searchword_db[key]}";
            }
          }
          else {
            content = "Wrong PassWord! \n";
          }
        } else {
          content = "Please create account \n";
        }
      });
    }
  printAndSendHttpResponse(db, request, content);
}