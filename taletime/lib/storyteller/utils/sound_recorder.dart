///The class [sound_recorder] allows the user to record the story.
///It also offers the possibility to delete the recorded story.
///You can record a specific time or a complete story.
library;

import "dart:async";
import "dart:io";

import "package:flutter_sound/flutter_sound.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";

class SoundRecorder extends FlutterSoundRecorder {
  /// FlutterSoundRecorder Object
  FlutterSoundRecorder? _audioRecorder = FlutterSoundRecorder();
  String _path = "";

  String get getPath => _path;

  ///
  bool _isRecorderInitialised = false;

  /// return true if the recorder is currently recording
  @override
  bool get isRecording => _audioRecorder!.isRecording;

  /// initializes the Sound-Recorder and aks for microphone permission if it wasn't granted already from the user
  Future initRecorder() async {
    /// asks the user for microphone permission
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }

    final statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    } else {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath =
          "${directory.path}/${DateTime.now().microsecondsSinceEpoch}.aac";

      await _audioRecorder!.openRecorder();
      _path = filepath;
      await File(_path).create();
      _isRecorderInitialised = true;

      await _audioRecorder!.setSubscriptionDuration(
        const Duration(milliseconds: 100),
      );
    }
  }

  void dispose() {
    if (!_isRecorderInitialised) return;

    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future record() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.startRecorder(toFile: _path);
  }

  Future<void> stop() async {
    if (!_isRecorderInitialised) {}

    await _audioRecorder!.stopRecorder();
  }
}
