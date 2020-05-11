import 'dart:convert';

import 'package:crypto/crypto.dart';

const ACTIVITY_SECRET_KEY = 'activityusrun1620';
const TRACK_SECRET_KEY = 'trackusrun1620';

class UsrunCrypto{

  static String buildActivitySig(int trackID){

    List<int> secretBytes = utf8.encode(ACTIVITY_SECRET_KEY);
    List<int> messageBytes = utf8.encode(trackID.toString());
    
    var hmac = new Hmac(sha256, secretBytes);
    Digest sha256Result = hmac.convert(messageBytes);
    
    print("Activity sig: "+sha256Result.toString());
  }

   static String buildTrackSig(int trackID, int createTime){

    List<int> secretBytes = utf8.encode(TRACK_SECRET_KEY);
    List<int> messageBytes = utf8.encode('${trackID.toString()}|${createTime.toString()}');
    
    var hmac = new Hmac(sha256, secretBytes);
    Digest sha256Result = hmac.convert(messageBytes);
    
      print("Track sig: "+sha256Result.toString());
  }
}