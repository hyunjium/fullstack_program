import 'dart:io';
import 'dart:convert';
import 'package:excel/excel.dart';

Future<Map<int, List<dynamic>>> processExcelFile(String filePath) async {
  try {
    var file = File(filePath);
    var bytes = await file.readAsBytes();
    var excel = Excel.decodeBytes(bytes);

    // Assume the first sheet is being processed
    var sheet = excel.tables.keys.first;
    var rows = excel.tables[sheet]!.rows;

    // Convert rows to a Map
    var result = <int, List<dynamic>>{};

    for (var row in rows) {
      var rowList = row.map((cell) => cell?.value).toList();
      if (rowList.isNotEmpty) {
        var key = int.tryParse(rowList[0]?.toString() ?? '');
        var value = rowList.sublist(1);
        if (key != null) {
          result[key] = value;
        }
      }
    }

    return result;
  } catch (e) {
    print("Error processing Excel file: $e");
    return {};
  }
}

void main() async {
  var excelFilePath = 'apple.xlsx';
  var storeDb = await processExcelFile(excelFilePath);

  int usernumber = 0;
  var userinfoDb = {};
  var loginInfo = <dynamic, dynamic>{};
  var searchwordDb = {};

  var server = await HttpServer.bind(
    InternetAddress.loopbackIPv4, // ip address
    4040, // port number
  );

  printHttpServerActivated(server);

  await for (HttpRequest request in server) {
    if (request.uri.path.contains('/api/') == true) {
      printHttpRequestInfo(request);
      try {
        switch (request.uri.path) {
          case '/api/0001': // Read
            readMenuInfo(storeDb, request, searchwordDb);
            break;
          case '/api/0002': // Create
            createId(userinfoDb, request, usernumber, searchwordDb);
            break;
          case '/api/0003': // Read
            login(userinfoDb, loginInfo, request, searchwordDb);
            break;
          case '/api/0004': // Read
            readUserInfo(userinfoDb, request);
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
  print('\$ Server activated in $ip:$port \n');
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

void printAndSendHttpResponse(var request, var content) async {
  request.response
    ..headers.contentType = ContentType('text', 'plain', charset: "utf-8")
    ..statusCode = HttpStatus.ok
    ..write(content);
  await request.response.close();
}

void readMenuInfo(var storeDb, var request, var searchwordDb) async {
  var content = await utf8.decoder.bind(request).join();
  var searchInfo = jsonDecode(content) as List;
  List recentSearch = [];
  if (searchwordDb[searchInfo[0]] != null){
    recentSearch.add(searchwordDb[searchInfo[0]]);
  }

  print("> Find the word '${searchInfo[1]}' in it");
  if (searchwordDb[searchInfo[0]] == null){
    searchwordDb[searchInfo[0]] = searchInfo[1];
  } else {
    searchwordDb[searchInfo[0]].add(searchInfo[1]);
  }

  Map<int, List<dynamic>> findMenu = {};
  storeDb.forEach((key, value) {
      if (value.isNotEmpty && value[0].toString().contains(searchInfo[1])) {
        findMenu[key] = [value[0], value[1], double.parse(value[2].toStringAsFixed(1)), value[3], double.parse(value[5].toStringAsFixed(1))];
      }});
  
    print("> Found \n $findMenu");
    print("> Send to Client \n");

    var sendtoClient;
    if (recentSearch.isEmpty) {
      sendtoClient = "$findMenu";
    } else {
      sendtoClient = "$findMenu \n $recentSearch";
    }

    printAndSendHttpResponse(request, sendtoClient);
  }


void createId(var userinfoDb, var request, int usernumber, var searchwordDb) async {
  var content = await utf8.decoder.bind(request).join();
  var transaction = jsonDecode(content) as List;

  print("> user_info \n $content");

  if (userinfoDb.isEmpty) {
    usernumber++;
    userinfoDb[usernumber] = transaction;
    content = "Success < $transaction created >";
  } else {
    userinfoDb.forEach((key, value) {
      if (value.isNotEmpty && value[0] == transaction[0]) {
        content = "Fail < ${transaction[0]} already exists >";
      } else {
        usernumber++;
        userinfoDb[usernumber] = transaction;
        searchwordDb[usernumber] = null;
        content = "Success < $transaction created >";
      }
    });
  }
  print("> Saved user_info $userinfoDb \n");
  printAndSendHttpResponse(request, content);
}


void login(var userinfoDb, var loginInfo, var request, var searchwordDb) async {
  var content = await utf8.decoder.bind(request).join();
  var transaction = jsonDecode(content) as List;

  print("> login_info \n $content \n");

    if (userinfoDb.isEmpty) {
      content = "Please create account";
    } else {
      userinfoDb.forEach((key, value) {
        if (value.isNotEmpty && value[0] == transaction[0]) {
          if(value.isNotEmpty && value[1] == transaction[1]) {
            if (searchwordDb[key] == null){
              content = "$key Login Success!";
            }else {
              content = "$key Login Success! \n ${searchwordDb[key]}";
            }
          }
          else {
            content = "Wrong PassWord!";
          }
        } else {
          content = "Please create account";
        }
      });
    }
  printAndSendHttpResponse(request, content);
}


void readUserInfo(var userinfoDb, var request) async {
  var content = await utf8.decoder.bind(request).join();
  var usertokenNum = jsonDecode(content) as int;

  print("> user_info \n ${userinfoDb[usertokenNum]}");
  var userInfo = userinfoDb[usertokenNum];
  print("> Send to Client \n");
  printAndSendHttpResponse(request, userInfo);
}