import 'package:flutter/foundation.dart';
import 'package:taletime/utils/constants.dart';
import 'package:taletime/utils/decoration_util.dart';
import 'package:taletime/utils/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taletime/utils/Story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:taletime/utils/edit_profile.dart';

class listfavorite extends ChangeNotifier {
  List<Story> listen1 = [];

  void addStory(Story story) {
    listen1.add(story);
    notifyListeners();
  }

  void removeStory(Story story) {
    listen1.remove(story);
    notifyListeners();
  }

  List<Story> get storys {
    return listen1;
  }
}
