import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'decoration_util.dart';
import 'package:taletime/utils/edit_profile.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Story {
  late final String name;
  late final String image;
  late final String title;
  late final profiles;
  late final profile;
  final textEditingController = TextEditingController();

  late String profileImage = profile["image"];

  late String? selectedItem = profile["title"];
  Story(
      {required this.name,
      required this.title,
      required this.image,
      required this.profile,
      required this.profiles});
}
