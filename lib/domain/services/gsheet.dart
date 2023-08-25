import 'package:gsheets/gsheets.dart';
import 'package:mituna/core/constants/gsheet_credentials.dart';

class GsheetService {
  final _gsheets = GSheets(gsheetCredentials);

  Future<Spreadsheet> get spreadsheet {
    return _gsheets.spreadsheet('17pv4tBjYDTixUGgLFsBCbGIcNoWr1yxKw1eCaeO5KW0');
  }

  Future<Worksheet?> get worksheet async {
    return (await spreadsheet).worksheetByIndex(0);
  }
}
