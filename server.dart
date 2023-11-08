import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

Future main() async {
  var db = <dynamic, dynamic>{};
  var login_info = <dynamic, dynamic>{};
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
            readMenuInfo(excel, request);
            break;
          case '/api/0002': // Create
            createId(db, request);
            break;
          case '/api/0003': // Read
            login(db, login_info, request);
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
    print("\> content-type   : ${request.headers.contentType}");
    print("\> content-length : ${request.headers.contentLength}");
  }
}

void printAndSendHttpResponse(var db, var request, var content) async {
  request.response
    ..headers.contentType = ContentType('text', 'plain', charset: "utf-8")
    ..statusCode = HttpStatus.ok
    ..write(content);
  await request.response.close();
}

void readMenuInfo(var excel, var request) async {
  final uri = request.requestedUri;
  String searchParam = uri.queryParameters['search'];
  print("> Find the word $searchParam in it");
  //String key = request.uri.pathSegments.last;
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

        if (rowData[0].toString().contains(searchParam)) {
          data[rowData[0]] = [rowData[1],rowData[2]];
          }
        }
      }
    print("> Found \n $data");

    print("\$ Send to Client \n");
    request.response
      ..headers.contentType = ContentType('text', 'plain', charset: "utf-8")
      ..statusCode = HttpStatus.ok
      ..write(data);
  } else {
    // Handle the case when 'excel' is null
    print("\$ 'excel' object is null.");
    request.response
      ..statusCode = HttpStatus.internalServerError
      ..write("Internal Server Error");
  }

  await request.response.close();
}


void createId(var db, var request) async {
  var content = await utf8.decoder.bind(request).join();
  var transaction = jsonDecode(content) as Map;
  var key, value;

  print("\> user_info \n $content");

  transaction.forEach((k, v) {
    key = k;
    value = v;
  });

  if (db.containsKey(key) == false) {
    db[key] = value;
    content = "Success < $transaction created >";
  } else {
    content = "Fail < $key already exist >";
  }
  print("\$ Saved user_info $db \n");
  printAndSendHttpResponse(db, request, content);
}


void login(var db, var login_info, var request) async {
  var content = await utf8.decoder.bind(request).join();
  var transaction = jsonDecode(content) as Map;
  var key, value;

  print("\> login_info \n $content \n");

  transaction.forEach((k, v) {
    key = k;
    value = v;
  });

  if (db.containsKey(key) == true){
    if(db[key][0] == value) {
      content = "Login Success! \n";
      login_info.clear();
      login_info[key] = db[key];
    }
    else{
      content = "Wrong PassWord! \n";
    }
  } else {
    content = "Please create account \n";
  }
  printAndSendHttpResponse(db, request, content);
}