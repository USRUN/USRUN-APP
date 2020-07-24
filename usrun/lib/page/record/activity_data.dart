import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/crypto.dart';
import 'package:usrun/page/record/record_const.dart';
import 'package:usrun/page/record/record_data.dart';

class ActivityData{
  String title;
  String description;
  List<File> photos;
  int totalLove;
  int totalComment;
  int totalShare;
  bool processed;
  ActivityPrivacyMode privacy;
  int deleted;
  bool showMap;
  RecordData recordData;
  String sig;

  ActivityData(int trackID, RecordData data)
  {
    this.title = _generateTitle();
    this.description = "";
    this.totalLove = 0;
    this.totalComment = 0;
    this.totalShare = 0;
    this.deleted = 0;
    this.showMap = true;
    this.privacy = ActivityPrivacyMode.Public;
    this.sig = "";
    this.photos = [];
    this.recordData = data;
  }

  _generateTitle(){
     var date = DateTime.now();
     print(date);
    if (date.hour >= 5 && date.hour < 12) {
      return R.strings.morningRun;
    }
    if (date.hour >= 12 && date.hour < 17) {
      return  R.strings.afternoonRun;
    }
    if (date.hour >= 17 && date.hour < 20) {
      return  R.strings.eveningRun;
    }
    return R.strings.nightRun;
  }

   void addPhotoFile(File newFile, int indexFile) {
    if (indexFile >= photos.length && indexFile >= MAX_PHOTO_UPLOAD) {
      photos.removeAt(0);
      photos.add(newFile);
    } else if(photos.length >= MAX_PHOTO_UPLOAD && indexFile < photos.length) {
      photos[indexFile] = newFile;
    } else {
      photos.add(newFile);
    }
  }
}