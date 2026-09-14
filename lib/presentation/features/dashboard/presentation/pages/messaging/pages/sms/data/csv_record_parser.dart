import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

/// Parses an uploaded CSV into autocompose records.
/// Expected columns (header row required): sender_id, phone, message
/// Adjust the column names below if your real template differs.
class CsvRecordParseResult {
  const CsvRecordParseResult({required this.records, required this.errors});
  final List<Map<String, String>> records;
  final List<String> errors; // e.g. "Row 4: missing phone"
}

CsvRecordParseResult parseAutocomposeCsv(PlatformFile file) {
  final bytes = file.bytes;
  if (bytes == null) {
    return const CsvRecordParseResult(
      records: [],
      errors: ['File has no readable content.'],
    );
  }

  final rows = const CsvToListConverter(eol: '\n')
      .convert(utf8.decode(bytes), shouldParseNumbers: false);

  if (rows.isEmpty) {
    return const CsvRecordParseResult(records: [], errors: ['File is empty.']);
  }

  final header =
      rows.first.map((e) => e.toString().trim().toLowerCase()).toList();
  final senderIdIdx = header.indexOf('sender_id');
  final phoneIdx = header.indexOf('phone');
  final messageIdx = header.indexOf('message');

  if (senderIdIdx == -1 || phoneIdx == -1) {
    return const CsvRecordParseResult(
      records: [],
      errors: ['File must include "sender_id" and "phone" columns.'],
    );
  }

  final records = <Map<String, String>>[];
  final errors = <String>[];

  for (var i = 1; i < rows.length; i++) {
    final row = rows[i];
    if (row.every((cell) => cell.toString().trim().isEmpty)) continue;

    final phone = phoneIdx < row.length ? row[phoneIdx].toString().trim() : '';
    final senderId =
        senderIdIdx < row.length ? row[senderIdIdx].toString().trim() : '';

    if (phone.isEmpty || senderId.isEmpty) {
      errors.add('Row ${i + 1}: missing sender_id or phone, skipped.');
      continue;
    }

    records.add({
      'sender_id': senderId,
      'phone': phone,
      'message': messageIdx != -1 && messageIdx < row.length
          ? row[messageIdx].toString().trim()
          : '',
    });
  }

  return CsvRecordParseResult(records: records, errors: errors);
}
