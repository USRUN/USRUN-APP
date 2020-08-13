import 'dart:convert';
import 'package:reflectable/reflectable.dart';
import 'package:reflectable/mirrors.dart';
import 'package:usrun/model/splits.dart';
import 'package:usrun/util/reflector.dart';

class JsonParser {
  final Map<String, ClassMirror> classes = <String, ClassMirror>{};

  JsonParser() {
    for (ClassMirror classMirror in reflector.annotatedClasses) {
      classes[classMirror.simpleName] = classMirror;
    }
  }

  bool isMapperObject(String className) {
    return classes[className] != null;
  }

  T decode<T>(dynamic input) {
    if (input is String) {
      Map content = json.decode(input);
      return _parse(content, T);
    } else if (input is Map) {
      return _parse(input, T);
    } else {
      throw new UnsupportedError(
          'The specified JSON input type ($T) is invalid.');
    }
  }

  dynamic _parse(Map map, Type returnType) {
    ClassMirror classMirror = reflector.reflectType(returnType);
    dynamic instance = classMirror.newInstance("", []);
    InstanceMirror instanceMirror = reflector.reflect(instance);

    classMirror.superclass.declarations
        .forEach((String key, DeclarationMirror mirror) {
      _parseProperty(map, key, mirror, instanceMirror);
    });

    classMirror.declarations.forEach((String key, DeclarationMirror mirror) {
      _parseProperty(map, key, mirror, instanceMirror);
    });

    return instance;
  }

  void _parseProperty(Map map, String key, DeclarationMirror mirror,
      InstanceMirror instanceMirror) {
    dynamic newValue = map[key];
    if (newValue != null) {
      Type castType;
      if (mirror is VariableMirror) {
        castType = mirror.reflectedType;
      } else if (mirror is MethodMirror) {
        castType = mirror.reflectedReturnType;
      } else {
        throw new UnsupportedError('Can\'t cast to $castType + $key + $mirror');
      }

      String strProType = castType.toString();
      ClassMirror proMirror = classes[strProType];

      if (proMirror == null) {
        // property type is not reflection type
        if (castType == bool) {
          instanceMirror.invokeSetter(key, _castToBool(newValue));
        } else if (castType == DateTime) {
          instanceMirror.invokeSetter(key, _castToDateTime(newValue));
        } else if (strProType.indexOf('List') == 0) {
          String clsName = strProType.substring(5, strProType.length - 1);
          ClassMirror cls = classes[clsName];
          if (cls == null) {
            // normal list
            instanceMirror.invokeSetter(key, _castToList(newValue, clsName));
          } else {
            // list of reflection item
            List res = _initListType(cls.reflectedType.toString());
            List list = newValue;
            for (Map item in list) {
              var obj = _parse(item, cls.reflectedType);
              res.add(obj);
            }
            instanceMirror.invokeSetter(key, res);
          }
        } else {
          if (castType == double) {
            newValue = newValue?.toDouble();
          }
          instanceMirror.invokeSetter(key, newValue);
        }
      } else if (proMirror.isEnum) {
        // property type is enum
        List values = proMirror.invokeGetter('values');
        instanceMirror.invokeSetter(key, values[newValue]);
      } else {
        // property type is reflection type
        var newObj = _parse(newValue, castType);
        instanceMirror.invokeSetter(key, newObj);
      }
    }
  }

  String encode(Object input) {
    Map res = _encodeObject(input);
    return json.encode(res);
  }

  Map _encodeObject(Object input) {
    if (input == null) {
      return null;
    } else {
      InstanceMirror instanceMirror = reflector.reflect(input);
      ClassMirror classMirror = instanceMirror.type;

      Map res = {};

      try {
        if (!classMirror.superclass.simpleName.contains("MapperObject")) {
          classMirror.superclass.declarations
              .forEach((String key, DeclarationMirror mirror) {
            _encodeProperty(key, mirror, instanceMirror, res);
          });
        }
      } catch (e) {
        print("error ${e.toString()}");
      }

      classMirror.declarations.forEach((key, mirror) {
        Type type;

        if (mirror is VariableMirror) {
          type = mirror.reflectedType;
        } else if (mirror is MethodMirror && mirror.isGetter) {
          type = mirror.reflectedReturnType;
        }

        if (type != null) {
          var val = instanceMirror.invokeGetter(key);

          String strCastType = type.toString();

          if (strCastType.indexOf('List') == 0) {
            String clsName = strCastType.substring(5, strCastType.length - 1);
            ClassMirror cls = classes[clsName];
            if (cls == null) {
              res[key] = val;
            } else {
              List arr = [];
              List list = val ?? [];
              for (var item in list) {
                var obj = _encodeObject(item);
                arr.add(obj);
              }
              res[key] = arr;
            }
          } else {
            ClassMirror proMirror = classes[strCastType];

            if (val is DateTime) {
              // Using string date instead of millisecondsSinceEpoch;
              res[key] = val.toIso8601String();
            } else if (val is bool) {
              res[key] = val ? 1 : 0;
            } else if (proMirror == null) {
              res[key] = val;
            } else if (proMirror.isEnum) {
              List values = proMirror.invokeGetter('values');
              int i =
                  val == null ? 0 : values.indexOf(val); // enum value is index
              res[key] = i;
            } else {
              res[key] = _encodeObject(val);
            }
          }
        }
      });

      return res;
    }
  }

  void _encodeProperty(String key, DeclarationMirror mirror,
      InstanceMirror instanceMirror, Map res) {
    Type type;

    if (mirror is VariableMirror) {
      type = mirror.reflectedType;
    } else if (mirror is MethodMirror && mirror.isGetter) {
      type = mirror.reflectedReturnType;
    }

    if (type != null) {
      var val = instanceMirror.invokeGetter(key);

      String strCastType = type.toString();

      if (strCastType.indexOf('List') == 0) {
        String clsName = strCastType.substring(5, strCastType.length - 1);
        ClassMirror cls = classes[clsName];
        if (cls == null) {
          res[key] = val;
        } else {
          List arr = [];
          List list = val ?? [];
          for (var item in list) {
            var obj = _encodeObject(item);
            arr.add(obj);
          }
          res[key] = arr;
        }
      } else {
        ClassMirror proMirror = classes[strCastType];

        if (val is DateTime) {
          // Using string date instead of millisecondsSinceEpoch;
          res[key] = val.toIso8601String();
        } else if (val is bool) {
          res[key] = val ? 1 : 0;
        } else if (proMirror == null) {
          res[key] = val;
        } else if (proMirror.isEnum) {
          List values = proMirror.invokeGetter('values');
          int i = val == null ? 0 : values.indexOf(val); // enum value is index
          res[key] = i;
        } else {
          res[key] = _encodeObject(val);
        }
      }
    }
  }
}

//
// --------------------------------------------------------------------------------
//

final JsonParser objectParser = JsonParser();

//
// --------------------------------------------------------------------------------
//

bool _castToBool(dynamic val) {
  if (val is int) {
    return val != 0;
  }

  if (val is bool) {
    return val;
  }

  if (val is String) {
    return val != '0';
  }

  return false;
}

DateTime _castToDateTime(dynamic val) {
  if (val is int) {
    if (val > 1000000000000) {
      val = val ~/ 1000;
    }
    return DateTime.fromMillisecondsSinceEpoch(val * 1000);
    // server return second, but fromMillisecondsSinceEpoch used millisecond => multiple 1000
  }

  if (val is DateTime) {
    return val;
  }

  if (val is String) {
    return DateTime.parse(val);
  }

  return null;
}

List _castToList(List list, String kl) {
  switch (kl) {
    case 'String':
      return list.cast<String>();
    case 'int':
      return list.cast<int>();
  }
  return list;
}

List _initListType(String type) {
  /*
    + If inside an object contains a LIST TYPE which has REFLECTOR, you have to init
    that list type first.
    + For example, object BigRoutesTimeline has its reflector and List<SmallRouteTimeline>
    inside. However, this timeline variable is a LIST and it also has its REFLECTOR.
    Therefore, you have to init the new list with that type as below.
  */
  switch (type) {
//    case "SmallRouteTimeline":
//      List<SmallRouteTimeline> element = [];
//      return element;
    case "SplitModel":
      List<SplitModel> element = [];
      return element;
    default:
      List element = [];
      return element;
  }
}
