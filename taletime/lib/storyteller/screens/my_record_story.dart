import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:taletime/storyteller/screens/save_or_upload_story.dart';
import 'package:taletime/common%20utils/constants.dart';
import 'package:taletime/storyteller/utils/record_class.dart';
import 'package:taletime/storyteller/utils/sound_recorder.dart';

class MyRecordStory extends StatefulWidget {
  final Story? myStory;
  MyRecordStory(this.myStory);

  @override
  State<MyRecordStory> createState() => _MyRecordStoryState(myStory);
}

class _MyRecordStoryState extends State<MyRecordStory> {
  final Story? myStory;
  _MyRecordStoryState(this.myStory);


  Widget buildStart(){
    final isRecording = false;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? "STOP" : "START";
    final primary = isRecording ? Colors.teal.shade100 : kPrimaryColor;
    final onPrimary = isRecording ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(175, 50),
        primary: primary,
        onPrimary: onPrimary
      ),
        icon: Icon(icon, color:Colors.white),
        label: Text(text, style: TextStyle(color:Colors.white),),
      onPressed: () {},
    );
  }

  Widget buildPlay(){
    final isPlaying = false;
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? "Stop playing" : "Start Playing";
    final primary = isPlaying ? Colors.teal.shade100 : kPrimaryColor;
    final onPrimary = isPlaying ? Colors.white : Colors.black;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(175, 50),
          primary: primary,
          onPrimary: onPrimary
      ),
      icon: Icon(icon, color:Colors.white),
      label: Text(text, style: TextStyle(color:Colors.white),),
      onPressed: () {},
    );
  }

  Widget buildPlayer(){
    final recoder = false;
    final text = recoder ? "Now Recording" : "Press Start";
    final animate = recoder;

    return AvatarGlow(
      endRadius: 140,
      animate: animate,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.teal.shade100,
        child: CircleAvatar(
          radius: 92,
          backgroundColor: kPrimaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("TalTime", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("00:00", style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text(text, style: TextStyle(color: Colors.white, fontSize: 12),),
            ],
          ),
        ),
      ),

    );
  }

  Widget buildSave(){

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 40),
          primary: kPrimaryColor,
          onPrimary: Colors.black
      ),
      icon: Icon(Icons.save_alt, color:Colors.white),
      label: Text("SAVE", style: TextStyle(color:Colors.white),),
      onPressed: () {},
    );
  }

  Widget buildDiscard(){

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 40),
          primary: kPrimaryColor,
          onPrimary: Colors.black
      ),
      icon: Icon(Icons.delete_forever, color:Colors.white),
      label: Text("DISCARD", style: TextStyle(color:Colors.white),),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true, title: Text("Story Recorder", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 75,),
            buildPlayer(),
            SizedBox(height: 40,),
            buildStart(),
            SizedBox(height: 40,),
            buildPlay(),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDiscard(),
                SizedBox(width: 35,),
                buildSave()
              ],
            )
          ],
        ),
      ),
    );
  }
}
