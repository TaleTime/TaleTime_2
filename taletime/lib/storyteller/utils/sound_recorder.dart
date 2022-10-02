import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:taletime/storyteller/utils/record_class.dart';

import '../../common utils/decoration_util.dart';

class SoundRecorder extends FlutterSoundRecorder {
  FlutterSoundRecorder? _audioRecorder = FlutterSoundRecorder();
  bool _isRecorderInitialised = false;

  final pathToSaveAudio = "audio_example.aac";

  bool get isRecording => _audioRecorder!.isRecording;

  Future initRecorder(String fileName, String directoryName) async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    final statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }

    await _audioRecorder!.openRecorder();
    directoryPath = await _directoryPath(directoryName);
    completePath = await _completePath(directoryPath, fileName);
    _createDirectory();
    createFile(completePath);
    _isRecorderInitialised = true;

    await _audioRecorder!.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );
  }

  void dispose() {
    if (!_isRecorderInitialised) return;

    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future record(String path) async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.startRecorder(toFile: path);
  }

  Future stop(BuildContext context, TextEditingController controller,
      List<Record> records, Duration duration) async {
    if (!_isRecorderInitialised) return;

    final path = await _audioRecorder!.stopRecorder();

    showDialog(
        context: context,
        builder: (context) {
          return Decorations().confirmationDialog(
              "Do you really want to add this part?", "", context, () async {
            String? name = await openDialog(
                context, "Enter a name for your recorded part", controller);
            if (name == null) {
              name = "Part";
            }
            final audioFile = File(path!);

            Record record = Record(name, duration, audioFile);
            records.add(record);
            Navigator.of(context).pop();
          });
        });
  }

  String completePath = "";
  String directoryPath = "";

  Future<String> _completePath(String directoryName, String fileName) async {
    var name = getFileName(fileName);
    return "$directoryName$name";
  }

  Future<String> _directoryPath(String directoryName) async {
    var directory = await getExternalStorageDirectory();
    var directoryPath = directory!.path;
    return "$directoryPath/records/$directoryName";
  }

  String getFileName(String fileName) {
    return "$fileName.mp3";
  }

  Future createFile(String path) async {
    File(path).create(recursive: true).then((File file) async {
      //write to file
      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);
      print("FILE CREATED AT : " + file.path);
    });
  }

  void _createDirectory() async {
    bool isDirectoryCreated = await Directory(directoryPath).exists();
    if (!isDirectoryCreated) {
      Directory(directoryPath).create().then((Directory directory) {
        print("DIRECTORY CREATED AT : " + directory.path);
      });
    }
  }
}
