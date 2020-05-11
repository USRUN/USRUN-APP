
import 'package:location/location.dart';

class TrackRequest{
  int trackID;
  String sig;
  int createTime;
  List<LocationData> locations;
}

class RecordData {

  int trackID;
  int totalTime;
  int createTime;
  int totalDistance;
  int totalStep;
  int avgPace;
  int avgHeart;
  int maxHeart;
  int calories;
  int elevGain;
  int elevMax;

}