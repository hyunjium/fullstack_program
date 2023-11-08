import 'dart:io';
import 'package:excel/excel.dart';

void main() async {
  final file = File('apple.xlsx'); // 엑셀 파일 경로

  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
    print(table); // 엑셀 시트 이름 출력
    var sheet = excel.tables[table]!;
    print(sheet.maxCols);
    print(sheet.maxRows);

    for (var row in sheet.rows) {
      var rowData = [];
      var cell;
      for (cell in row) {
        rowData.add(cell.value);
      }
      print(rowData);
    }
  }
}