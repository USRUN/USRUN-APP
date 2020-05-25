import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class Track extends MapperObject{
  int trackId;
  int userId;
  String description;
  String time;
}