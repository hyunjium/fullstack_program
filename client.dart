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

//선택1
while(true) {
  print("1. 회원가입");
  print("2. 로그인");
  final select1 = stdin.readLineSync();
  print('\n');
  if (select1 == '1') {
    // Create : POST id
    List userinfo =[];
    print("|-> Create ID by POST");
    print("아이디 입력: ");
    final userId = stdin.readLineSync();
    userinfo.add(userId);
    print("비밀번호 입력: ");
    final userPw = stdin.readLineSync();
    userinfo.add(userPw);
    print("닉네임 입력: ");
    final userNn = stdin.readLineSync();
    userinfo.add(userNn);
    print("전화번호 입력: ");
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
    print("아이디 입력: ");
    final id = stdin.readLineSync();
    login.add(id);
    print("비밀번호 입력: ");
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

//선택2
    if (userToken > 0) {
      while(true) {
        print("1. 메뉴로 검색하기");
        print("2. 가게로 검색하기");
        print("3. 최근 검색어");
        print("4. 마이페이지");
        print("5. 즐겨찾기");
        final select2 = stdin.readLineSync();
        print('\n');
        if (select2 == '1') {
        // Read : GET menu info
          print("|-> Menu info Read by GET");
          print("검색어를 입력하세요: ");
          final wordToSearch = stdin.readLineSync();
          print('\n');
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
          var menuinfo = httpResponseContent;

          //선택3
          while(true) {
            if (menuinfo.length >= 2) {
              print("1. 구매 사이트로 연결하기");
              print("2. 즐겨찾기 하기");
              print("3. 검색창으로 돌아가기");
              final select3 = stdin.readLineSync();
              print('\n');
              if (select3 == "1") {
                // Get Url
                print(menuinfo);
                print("원하는 메뉴의 숫자를 입력하세요: ");
                final select4 = stdin.readLineSync();
                print('\n');
                serverPath = "/api/0007";
                httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
                  ..headers.contentType = ContentType.json
                  ..headers.set('Authorization', select4!)
                  ..headers.contentLength = searchword.length
                  ..write(searchword);
                httpResponse = await httpRequest.close();
                httpResponseContent = await utf8.decoder.bind(httpResponse).join();
                printHttpContentInfo(httpResponse, httpResponseContent);
              }
              else if (select3 == "2") {
                //Post star
                print(menuinfo);
                print("원하는 메뉴의 숫자를 입력하세요: ");
                final select4 = stdin.readLineSync();
                print('\n');
                var wantnum = jsonEncode(select4);
                serverPath = "/api/0008";
                httpRequest = await httpClient.post(serverIp, serverPort, serverPath)
                  ..headers.contentType = ContentType.json
                  ..headers.set('Authorization', userToken)
                  ..headers.contentLength = wantnum.length
                  ..write(wantnum);
                httpResponse = await httpRequest.close();
                httpResponseContent = await utf8.decoder.bind(httpResponse).join();
                printHttpContentInfo(httpResponse, httpResponseContent);
              }
              else if (select3 == "3") {
                break;
              }
              else {
                print("다시 입력하세요");
              }
            }
          }
        } 
        else if(select2 == '2') {
          // Read : GET store info
          print("|-> Store info Read by GET");
          print("검색어를 입력하세요: ");
          final wordToSearch = stdin.readLineSync();
          print('\n');
          var searchword = jsonEncode(wordToSearch);
          serverPath = "/api/0005";
          httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
            ..headers.contentType = ContentType.json
            ..headers.set('Authorization', userToken)
            ..headers.contentLength = searchword.length
            ..write(searchword);
          httpResponse = await httpRequest.close();
          httpResponseContent = await utf8.decoder.bind(httpResponse).join();
          printHttpContentInfo(httpResponse, httpResponseContent);
          var storeinfo = httpResponseContent;

          //선택3
          while(true) {
            if (storeinfo.length >= 2) {
              print("1. 구매 사이트로 연결하기");
              print("2. 즐겨찾기 하기");
              print("3. 검색창으로 돌아가기");
              final select3 = stdin.readLineSync();
              print('\n');
              if (select3 == "1") {
                // Get Url
                print(storeinfo);
                print("원하는 메뉴의 숫자를 입력하세요: ");
                final select4 = stdin.readLineSync();
                print('\n');
                serverPath = "/api/0007";
                httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
                  ..headers.contentType = ContentType.json
                  ..headers.set('Authorization', select4!)
                  ..headers.contentLength = searchword.length
                  ..write(searchword);
                httpResponse = await httpRequest.close();
                httpResponseContent = await utf8.decoder.bind(httpResponse).join();
                printHttpContentInfo(httpResponse, httpResponseContent);
              }
              else if (select3 == "2") {
                //Post star
                print(storeinfo);
                print("원하는 메뉴의 숫자를 입력하세요: ");
                final select4 = stdin.readLineSync();
                print('\n');
                var wantnum = jsonEncode(select4);
                serverPath = "/api/0008";
                httpRequest = await httpClient.post(serverIp, serverPort, serverPath)
                  ..headers.contentType = ContentType.json
                  ..headers.set('Authorization', userToken)
                  ..headers.contentLength = wantnum.length
                  ..write(wantnum);
                httpResponse = await httpRequest.close();
                httpResponseContent = await utf8.decoder.bind(httpResponse).join();
                printHttpContentInfo(httpResponse, httpResponseContent);
              }
              else if (select3 == "3") {
                break;
              }
              else {
                print("다시 입력하세요");
              }
            }
          }
        }
        else if (select2 == '3') {
          // Read : GET recentsearchWord
          serverPath = "/api/0006";
          httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
            ..headers.contentType = ContentType.json
            ..headers.set('Authorization', userToken);
          httpResponse = await httpRequest.close();
          httpResponseContent = await utf8.decoder.bind(httpResponse).join();
          printHttpContentInfo(httpResponse, httpResponseContent);
        }
        else if (select2 == "4") {
          print("1. 사용자 정보 보기");
          print("2. 로그아웃");
          final select5 = stdin.readLineSync();
          print('\n');
          if (select5 == '1') {
            // Read : GET user_info
             print("|-> User_info Read by GET");
             serverPath = "/api/0004";
             httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
               ..headers.contentType = ContentType.json
               ..headers.set('Authorization', userToken);
             httpResponse = await httpRequest.close();
             httpResponseContent = await utf8.decoder.bind(httpResponse).join();
             printHttpContentInfo(httpResponse, httpResponseContent);
          } else if (select5 == '2') {
            break;
          }

        }
        else if (select2 == "5") {
          // Read : GET star
             print("|-> Star Read by GET");
             serverPath = "/api/0009";
             httpRequest = await httpClient.get(serverIp, serverPort, serverPath)
               ..headers.contentType = ContentType.json
               ..headers.set('Authorization', userToken);
             httpResponse = await httpRequest.close();
             httpResponseContent = await utf8.decoder.bind(httpResponse).join();
             printHttpContentInfo(httpResponse, httpResponseContent);
        }
        }
        }
      }else {
        print("다시 입력하세요 \n");
}
}
}


void printHttpContentInfo(var httpResponse, var httpResponseContent) {
  print("|<- status-code    : ${httpResponse.statusCode}");
  print("|<- content-type   : ${httpResponse.headers.contentType}");
  print("|<- content        : $httpResponseContent \n");
}