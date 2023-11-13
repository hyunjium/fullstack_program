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
  int userToken;

//과정1
while(true) {
  print("1. 회원가입");
  print("2. 로그인");
  final select1 = stdin.readLineSync();
  if (select1 == '1') {
    // Create : POST id
    List userinfo =[];
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
  } else if (select1 == '2') {
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
    userToken = int.parse(httpResponse.headers['authorization']![0]);

//과정2
    if (userToken > 0) {
      print("1. 메뉴로 검색하기");
      print("2. 가게로 검색하기");
      print("3. 최근 검색어");
      final select2 = stdin.readLineSync();
      if (select2 == '1') {
      // Read : GET menu info
        print("|-> Menu info Read by GET");
        print("Enter a word to search on the server: ");
        final wordToSearch = stdin.readLineSync();
        var searchword = jsonEncode(wordToSearch);
        serverPath = "/api/0001";
        httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
          ..headers.contentType = ContentType.json
          ..headers.set('Authorization', userToken)
          ..headers.contentLength = searchword.length
          ..write(searchword);
        httpResponse = await httpRequest.close();
        httpResponseContent = await utf8.decoder.bind(httpResponse).join();
        printHttpContentInfo(httpResponse, httpResponseContent);
      }

    }
  } else {
    print("다시 입력해주세요 \n");
  }
}
}



// // Read : GET user_info
//   print("|-> User_info Read by GET");
//   var usertokenNum = jsonEncode(userToken);
//   serverPath = "/api/0004";
//   httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
//     ..headers.contentType = ContentType.json
//     ..headers.contentLength = usertokenNum.length
//     ..write(usertokenNum);
//   httpResponse = await httpRequest.close();
//   httpResponseContent = await utf8.decoder.bind(httpResponse).join();
//   printHttpContentInfo(httpResponse, httpResponseContent);
// }

void printHttpContentInfo(var httpResponse, var httpResponseContent) {
  print("|<- status-code    : ${httpResponse.statusCode}");
  print("|<- content-type   : ${httpResponse.headers.contentType}");
  print("|<- content        : $httpResponseContent \n");
}