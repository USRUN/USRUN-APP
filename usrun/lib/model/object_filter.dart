import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class ObjectFilter with MapperObject {
  int value;
  String name;
  String iconURL;
  double iconSize;

  ObjectFilter({
    this.value = 0,
    this.name = "",
    this.iconURL = "",
    this.iconSize = 20,
  }) : assert(value != null &&
            name != null &&
            iconURL != null &&
            iconSize != null &&
            iconSize > 0);
}
