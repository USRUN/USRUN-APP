import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class ObjectFilter with MapperObject {
  int value;
  String name;

  ObjectFilter({
    this.value = 0,
    this.name = "",
  }) : assert(value != null && name != null);
}
