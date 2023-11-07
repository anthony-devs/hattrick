import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class QuizUploader extends StatelessWidget {
  Future<void> uploadQuestions(List<PlatformFile> selectedFiles) async {
    for (var selectedFile in selectedFiles) {
      var bytes = selectedFile.bytes!;
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]!.rows) {
          String question = row[0]!.value.toString();
          String correctAnswer = row[1]!.value.toString();
          List<String> options = List<String>.from(
            row.sublist(2, 5).map((cell) => cell!.value.toString()),
          ); // Convert Data objects to strings
          String difficulty = row[5]!.value.toString();
          int duration = 12;
          int points = 4;

          // Check the difficulty level and upload to the appropriate collection
          String collectionName =
              difficulty == 'easy' ? 'easy_questions' : 'hard_questions';

          await http.post(
            Uri.parse(
                "https://hattrick-server-production.up.railway.app//upload-${difficulty == 'easy' ? 'easy' : 'hard'}"),
            body: jsonEncode(<String, String>{
              'question': question,
              'correctAnswer': correctAnswer,
              'opt1': options[0],
              'opt2': options[1],
              'opt3': options[2],
              'duration': duration.toString(),
              'points': points.toString()
            }),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          print(options[1]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Quiz Uploader')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx'],
                );
                if (result != null) {
                  List<PlatformFile> selectedFiles = result.files;
                  uploadQuestions(selectedFiles);
                }
              },
              child: Text('Select File'),
            ),
          ],
        ),
      ),
    );
  }
}
