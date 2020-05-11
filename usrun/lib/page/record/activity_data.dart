import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:usrun/page/record/record_data.dart';

class ActivityData{
  String title;
  String description;
  List<String> photos;
  int totalLike;
  int totalComment;
  int totalShare;
  bool processed;
  int privacy;
  int deleted;
  RecordData recordData;
  String sig;

  ActivityData()
  {
     String base64Key = 'activityusrun1620';
    String message = '1234';

    List<int> messageBytes = utf8.encode(message);
    List<int> key = base64.decode(base64Key);
    Hmac hmac = new Hmac(sha256, key);
    Digest digest = hmac.convert(messageBytes);

    String base64Mac = base64.encode(digest.bytes);
    this.sig = base64Mac;
    print(sig);
  }
}