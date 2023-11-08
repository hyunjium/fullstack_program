import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';

Future main() async {
  final file = File('total_table.xlsx'); // 엑셀 파일 경로

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
        switch (request.method) {
          case 'GET': // Read
            readDB(excel, request);
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
  print('\$ Server activated in ${ip}:${port}');
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

void readDB(var excel, var request) async {
  String key = request.uri.pathSegments.last;
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
        Map keyrow = {
          rowData.first.toString(): rowData.skip(1).join(', ')
        };
        print(keyrow);

        if(keyrow.containsKey(key)) {
          print('$key: ${keyrow[key]}');
          data[key] = keyrow[key];
        } else {
          print('$key not found in the map');
        }
      }
    }
    print(data);

    print("\$ Send Excel");
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