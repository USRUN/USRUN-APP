import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';

import 'package:usrun/model/mapper_object.dart';

import 'package:usrun/util/reflector.dart';

@reflector
class Team extends MapperObject {
  int teamId;
  int leagueId;
  String name;
  String nameSlug;
  String description;
  String img;
  String logo;
  DateTime addDate;
  DateTime updateDate;
  bool isActive;
  int memberCount;
  TeamVerifyStatus verifyStatus;
  SportType sportType;
  UserRole userType;
  bool hasOwner = false;
  bool official = false;


  static Widget nameWidget(Team team, [TextStyle style, TextAlign textAlign]) {
    style = style ?? TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);
    List<TextSpan> children = [
      TextSpan(
        text: team.name + " ",
        style: style,
      )
    ];

    if (team.official) {
      children.add(TextSpan(
        text: String.fromCharCode(CupertinoIcons.check_mark_circled.codePoint),
        style: TextStyle(color: R.colors.majorOrange, fontSize: 13),
      ));
    }

    return Text.rich(
      TextSpan(
        children: children,
        style: TextStyle(
          inherit: false,
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          fontFamily: CupertinoIcons.check_mark_circled.fontFamily,
          package: CupertinoIcons.back.fontPackage,
        ),
      ),
      textAlign: textAlign ?? TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  bool operator == (other) {
    if (other is Team) {
      return teamId == other.teamId;
    }
    return false;
  }
}