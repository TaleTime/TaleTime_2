///The class [sound_recorder] allows the user to record the story.
///It also offers the possibility to delete the recorded story.
///You can record a specific time or a complete story.
import 'dart:async';
import 'dart:io';
import "package:logger/logger.dart";
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:record/record.dart";

class SoundRecorder extends Record {
  /// FlutterSoundRecorder Object
  // FlutterSoundRecorder? _audioRecorder = FlutterSoundRecorder();
  String _path = '';
  String absolutePath ='';
  Record myrecord = Record() ;

  String get getPath => _path;
  bool _isRecorderInitialised = false;

  /// return true if the recorder is currently recording
  //@override
  bool get getRecordingStatus  {
    bool isRecording = false ;
    Future<bool> status = myrecord.isRecording() ;
    status.then((value) => {
      isRecording =  value
    }
    );
    return isRecording ;
  }

  /// initializes the Sound-Recorder and aks for microphone permission if it wasn't granted already from the user
  void record() async {
    /// asks the user for microphone permission
    //final status = await Permission.microphone.request();
     bool status  = await myrecord.hasPermission() ;
    Logger logger = Logger();
    logger.v(status);

    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }

    final statusStorage = await Permission.storage.status;
    print(statusStorage) ;
    if (statusStorage.isDenied) {
     await Permission.storage.request();
    }
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = '${directory.path}/${DateTime.now().microsecondsSinceEpoch}.aac';
      _path = filepath;
      await File(_path).create();
      myrecord.start(path: _path) ;
      _isRecorderInitialised = true;
      print(statusStorage);
  }

  Future<void> dispose() async {
    if (_isRecorderInitialised) {
      _isRecorderInitialised = false;
      return await myrecord.dispose() ;
    };
    return ;
  }



  Future<String?> stop()  async {
    if (!_isRecorderInitialised) {}

     await myrecord.stop() ;
     _isRecorderInitialised = false ;
  }

}
