import 'package:flutter/material.dart';
import 'package:usrun/util/reflector.dart';
import 'package:usrun/model/mapper_object.dart';

class R {
  static final _Color colors = _Color();
  static Strings strings = Strings();

  static void initLocalized(String jsonContent){
    R.strings = MapperObject.create<Strings>(jsonContent);
  }
}

class _Color{
  final Color blue = Color(0xFF03318C);

  final Gradient uiGradient = LinearGradient(
    colors: [
      Color(0xFFFCF946D), Color(0xFFF6AB72),Color(0xFFF5CB8B), Color(0xFFF7DBAE)
    ],
    stops: [0.0, 0.1, 0.6, 1.0]
  );
}

@reflector
class Strings {
  String usrun;

  String ok;
  String errorMessages;
  String notice;
}