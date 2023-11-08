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
  var jsonContent = {};

// Create : POST id
  print("|-> Create ID by POST");
  print("Enter ID: ");
  final ID = stdin.readLineSync();
  print("Enter PassWord: ");
  final PW = stdin.readLineSync();
  print("Enter NickName: ");
  final NN = stdin.readLineSync();
  print("Enter PhoneNumber: ");
  final PN = stdin.readLineSync();

  jsonContent[ID] = [PW,NN,PN];
  content = jsonEncode(jsonContent);
  serverPath = "/api/0002";
  httpRequest = await httpClient.post(serverIp, serverPort, serverPath)
    ..headers.contentType = ContentType.json
    ..headers.contentLength = content.length
    ..write(content);
  httpResponse = await httpRequest.close();
  httpResponseContent = await utf8.decoder.bind(httpResponse).join();
  printHttpContentInfo(httpResponse, httpResponseContent);

// Read : GET menu info
  print("|-> Menu info Read by GET");
  print("Enter a word to search on the server: ");
  final wordToSearch = stdin.readLineSync();
  serverPath = "/api/0001?search=$wordToSearch";
  httpRequest = await httpClient.get(serverIp, serverPort, serverPath);
  httpResponse = await httpRequest.close();
  httpResponseContent = await utf8.decoder.bind(httpResponse).join();
  printHttpContentInfo(httpResponse, httpResponseContent);
}

void printHttpContentInfo(var httpResponse, var httpResponseContent) {
  print("|<- status-code    : ${httpResponse.statusCode}");
  print("|<- content-type   : ${httpResponse.headers.contentType}");
  print("|<- content        : $httpResponseContent \n");
}
