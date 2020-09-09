import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class ObjectFilter<T> with MapperObject {
  T value;
  String name;
  String iconURL;
  double iconSize;

  ObjectFilter({
    this.value,
    this.name = "",
    this.iconURL = "",
    this.iconSize = 20,
  }) : assert(value != null &&
            name != null &&
            iconURL != null &&
            iconSize != null &&
            iconSize > 0);
}
