import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taletime/storyteller/utils/record_class.dart';

class SoundRecorder extends FlutterSoundRecorder {
  /// FlutterSoundRecorder Object
  FlutterSoundRecorder? _audioRecorder = FlutterSoundRecorder();
  String path = '';

  ///
  bool _isRecorderInitialised = false;

  /// return true if the recorder is currently recording
  bool get isRecording => _audioRecorder!.isRecording;

  /// initializes the Sound-Recorder and aks for microphone permission if it wasn't granted already from the user
  Future initRecorder() async {
    /// asks the user for microphone permission
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    final statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }

    await _audioRecorder!.openRecorder();

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

  Future record() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.startRecorder(toFile: 'audio');
  }

  Future<void> stop() async {
    if (!_isRecorderInitialised) ;

    path = (await _audioRecorder!.stopRecorder())!;
  }

  String get getPath => path;

  Future createFile(String path) async {
    File(path).create(recursive: true).then((File file) async {
      //write to file
      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);
      print("FILE CREATED AT : " + file.path);
    });
  }

  Duration? recordTime(Duration diff) {
    var startTime = DateTime.now();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      diff = DateTime.now().difference(startTime);

      if (!isRecording) {
        t.cancel(); //cancel function calling
      }
    });
  }
}
