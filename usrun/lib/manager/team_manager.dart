import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/login/login_adapter.dart';
import 'package:usrun/model/team_summary.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/core/net/client.dart';

class TeamManager{
  // static User currentUser = User(); // NOTE: doesn't set currentUser = new VALUE, just use currentUser.copy(new user) because user is used in all app

  // test tạm thời
  static User currentUser = new User();
  // ----------

  static Future<Response> getTeamById(int teamId) async {
    Map<String,dynamic> params = {'teamId':teamId};

    Response<dynamic> res = await Client.post('/team/getTeamById',params);
    return res;
  }

  static Future<Response> getTeamSuggestion(int howMany) async{
    Map<String,dynamic> params = {
      'district':'',
      'province':currentUser.city,
      'howMany':howMany
    };

    Response<dynamic> res = await Client.post('/team/getTeamSuggestion',  params);
    return res;
  }

  static Future<Response> findTeamRequest(String teamName, int pageNum, int perPage) async{
    Map<String,dynamic> params = {
      'teamName': teamName,
      'pageNum': pageNum,
      'perPage': perPage
    };

    Response<dynamic> res = await Client.post('/team/findTeam',params);
    return res;
  }

  static Future<Response> getAllTeamMemberPaged(int teamId, int pageNum, int perPage) async{
    Map<String,dynamic> params = {
      'teamId': teamId,
      'pageNum': pageNum,
      'perPage': perPage
    };

    Response<dynamic> res = await Client.post('/team/getAllTeamMember',params);
    return res;
  }

  static Future<Response> getTeamMemberByType(int teamId, int teamMemberType) async{
    Map<String,dynamic> params = {
      'teamId': teamId,
      'teamMemberType': teamMemberType
    };
  }

  static Future<Response> requestJoinTeam(int teamId) async{
    Map<String,dynamic> params = {'teamId':teamId};

    Response<dynamic> res = await Client.post('/team/join',params);
    return res;
  }

  static Future<Response> cancelJoinTeam(int teamId) async{
    Map<String,dynamic> params = {'teamId':teamId};

    Response<dynamic> res = await Client.post('/team/cancelJoin',params);
    return res;
  }

  static Future<Response> updateTeamMemberRole(int teamId, int memberId, int newRole) async {
    Map<String,dynamic> params = {
      'teamId': teamId,
      'memberId': memberId,
      'memberType': newRole
    };

    Response<dynamic> res = await Client.post('/team/cancelJoin',params);
    return res;
  }
}