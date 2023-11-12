import 'dart:io';
import 'dart:convert';

Future main() async {
  var serverIp = InternetAddress.loopbackIPv4.host;
  var serverPort = 4040;
  var serverPath;

  var httpClient = HttpClient();
  var httpResponseContent;

  HttpClientRequest httpRequest;
  HttpClientResponse httpResponse;

  var content;
  List userinfo =[];
  int userToken;

// Create : POST id
  print("|-> Create ID by POST");
  print("Enter ID: ");
  final userId = stdin.readLineSync();
  userinfo.add(userId);
  print("Enter PassWord: ");
  final userPw = stdin.readLineSync();
  userinfo.add(userPw);
  print("Enter NickName: ");
  final userNn = stdin.readLineSync();
  userinfo.add(userNn);
  print("Enter PhoneNumber: ");
  final userPn = stdin.readLineSync();
  userinfo.add(userPn);

  content = jsonEncode(userinfo);
  serverPath = "/api/0002";
  httpRequest = await httpClient.post(serverIp, serverPort, serverPath)
    ..headers.contentType = ContentType.json
    ..headers.contentLength = content.length
    ..write(content);
  httpResponse = await httpRequest.close();
  httpResponseContent = await utf8.decoder.bind(httpResponse).join();
  printHttpContentInfo(httpResponse, httpResponseContent);

// Read : GET Login
  List login = [];
  print("|-> Login Read user_info by GET");
  print("Enter ID: ");
  final id = stdin.readLineSync();
  login.add(id);
  print("Enter PassWord: ");
  final pw = stdin.readLineSync();
  login.add(pw);
  var content2 = jsonEncode(login);
  serverPath = "/api/0003";
  httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
    ..headers.contentType = ContentType.json
    ..headers.contentLength = content2.length
    ..write(content2);
  httpResponse = await httpRequest.close();
  httpResponseContent = await utf8.decoder.bind(httpResponse).join();
  printHttpContentInfo(httpResponse, httpResponseContent);
  userToken = int.parse(httpResponseContent[0]);

// Read : GET menu info
  List search = [userToken];
  print("|-> Menu info Read by GET");
  print("Enter a word to search on the server: ");
  final wordToSearch = stdin.readLineSync();
  search.add(wordToSearch);
  var searchword = jsonEncode(search);
  serverPath = "/api/0001";
  httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
    ..headers.contentType = ContentType.json
    ..headers.contentLength = searchword.length
    ..write(searchword);
  httpResponse = await httpRequest.close();
  httpResponseContent = await utf8.decoder.bind(httpResponse).join();
  printHttpContentInfo(httpResponse, httpResponseContent);

// Read : GET user_info
  print("|-> User_info Read by GET");
  var usertokenNum = jsonEncode(userToken);
  serverPath = "/api/0004";
  httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
    ..headers.contentType = ContentType.json
    ..headers.contentLength = usertokenNum.length
    ..write(usertokenNum);
  httpResponse = await httpRequest.close();
  httpResponseContent = await utf8.decoder.bind(httpResponse).join();
  printHttpContentInfo(httpResponse, httpResponseContent);
}

void printHttpContentInfo(var httpResponse, var httpResponseContent) {
  print("|<- status-code    : ${httpResponse.statusCode}");
  print("|<- content-type   : ${httpResponse.headers.contentType}");
  print("|<- content        : $httpResponseContent \n");
}
