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

class UserNumber {
  var num;
  UserNumber(this.num);
}

void main() async {
  var excelFilePath = 'apple.xlsx';
  var storeDb = await processExcelFile(excelFilePath);

  var usernumber = UserNumber(0);
  var userinfoDb = {};
  var loginInfo = <dynamic, dynamic>{};
  var recentsearchDb = {};

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
            readMenuInfo(storeDb, request, recentsearchDb);
            break;
          case '/api/0002': // Create
            createId(userinfoDb, request, usernumber, recentsearchDb);
            break;
          case '/api/0003': // Read
            login(userinfoDb, loginInfo, request, recentsearchDb);
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

void readMenuInfo(var storeDb, var request, var recentsearchDb) async {
  var token = request.headers['authorization']![0];
  var content = await utf8.decoder.bind(request).join();
  var searchWord = jsonDecode(content);

  print("> Find the word '$searchWord' in it");

  Map<int, List<dynamic>> findMenu = {};
  storeDb.forEach((key, value) {
      if (value.isNotEmpty && value[0].toString().contains(searchWord)) {
        findMenu[key] = [value[0], value[1], double.parse(value[2].toStringAsFixed(1)), value[3], double.parse(value[5].toStringAsFixed(1))];
      }});
  
    print("> Found \n $findMenu");
    print("> Send to Client \n");

    var sendtoClient;
    if (recentsearchDb[token] == null) {
      sendtoClient = "$findMenu";
      recentsearchDb[token] = searchWord;
    } else {
      sendtoClient = "$findMenu \n ${recentsearchDb[token]}";
      recentsearchDb[token].add(searchWord);
    }
    
    printAndSendHttpResponse(request, sendtoClient);
  }


void createId(var userinfoDb, var request, UserNumber usernumber, var recentsearchDb) async {
  var content = await utf8.decoder.bind(request).join();
  var transaction = jsonDecode(content) as List;

  print("> user_info \n $content");
  bool make = true;

  if (userinfoDb.isEmpty) {
    usernumber.num++;
    int nownum = usernumber.num;
    userinfoDb[nownum] = transaction;
    content = "Success < $transaction created >";
  } else {
    var keys = List.from(userinfoDb.keys);
    for (var key in keys) {
      var value = userinfoDb[key];
      if (value.isNotEmpty && value[0] == transaction[0]) {
        content = "Fail < ${transaction[0]} already exists >";
        make = false;
        break;
      } else {
        continue;
      }}
    if (make == true) {
      usernumber.num++;
      int nownum = usernumber.num;
      userinfoDb[nownum] = transaction;
      recentsearchDb[nownum] = null;
      content = "Success < $transaction created >";
    }
  }
  print("> Saved user_info $userinfoDb \n");
  printAndSendHttpResponse(request, content);
}


void login(var userinfoDb, var loginInfo, var request, var recentsearchDb) async {
  var content = await utf8.decoder.bind(request).join();
  var transaction = jsonDecode(content) as List;

  print("> login_info \n $content \n");
  var token;
  bool match = false;

    if (userinfoDb.isEmpty) {
      content = "Please create account";
    } else {
      var keys = List.from(userinfoDb.keys);
      for (var key in keys) {
      var value = userinfoDb[key];
      if (value.isNotEmpty && value[0] != transaction[0]) {
        continue;
        } else {
          match = true;
          token = key;
          if(value.isNotEmpty && value[1] == transaction[1]) {
            if (recentsearchDb[key] == null){
            content = "Login Success!";
            break;
            } else {
            content = "Login Success! \n ${recentsearchDb[key]}";
            break;
            }
          }
          else {
            content = "Wrong PassWord!";
            break;
          }
        }
        }
    }
      if (match == false) {
        token = 0;
        content = "Please create account";
      }

  request.response
    ..headers.contentType = ContentType('text', 'plain', charset: "utf-8")
    ..headers.set('Authorization', token)
    ..statusCode = HttpStatus.ok
    ..write(content);
  await request.response.close();
}


void readUserInfo(var userinfoDb, var request) async {
  var content = await utf8.decoder.bind(request).join();
  var usertokenNum = jsonDecode(content) as int;

  print("> user_info \n ${userinfoDb[usertokenNum]}");
  var userInfo = userinfoDb[usertokenNum];
  print("> Send to Client \n");
  printAndSendHttpResponse(request, userInfo);
}