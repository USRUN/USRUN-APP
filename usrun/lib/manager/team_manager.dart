import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/data_manager.dart';
import 'package:usrun/manager/login/login_adapter.dart';
import 'package:usrun/model/team_member.dart';
import 'package:usrun/model/event.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/model/response.dart';
import 'package:usrun/model/team.dart';
import 'package:usrun/model/team_leaderboard.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/core/net/client.dart';
import 'package:usrun/page/team/team_activity_item.dart';
import 'package:usrun/page/team/team_rank.dart';
import 'package:usrun/page/team/team_rank_item.dart';
import 'package:usrun/page/team/team_stat_item.dart';

class TeamManager{
  // static User currentUser = User(); // NOTE: doesn't set currentUser = new VALUE, just use currentUser.copy(new user) because user is used in all app

  // test tạm thời
  static User currentUser = new User();
  // ----------

  static Future<Response> getTeamById(int teamId) async {
    Map<String,dynamic> params = {'teamId':teamId};

    Response<dynamic> res = await Client.post('/team/getTeamById',params);

    if(!res.success || res.object == null) return res;

    Response<Team> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: MapperObject.create<Team>(res.object)
    );
    return response;
  }

  static Future<Response> updateTeam(dynamic params) async {
    Response<dynamic> res = await Client.post('/team/update',params);

    if(!res.success || res.object == null) return res;

        Response<Team> response = new Response(
            errorCode: res.errorCode,
            success: res.success,
            object: MapperObject.create<Team>(res.object)
        );
        return response;
  }


  static Future<Response> getTeamSuggestion(int howMany) async{
    Map<String,dynamic> params = {
      // TODO: Resolve User location
      'district': null,
      'province': null,
      'howMany':howMany
    };

    Response<dynamic> res = await Client.post('/team/getTeamSuggestion',  params);

    if(!res.success || (res.object as List).length == 0) return res;

    List<Team> teams = (res.object as List)
        .map((item)=> MapperObject.create<Team>(item)).toList();

    Response<List<Team>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: teams
    );

    return response;
  }

  static Future<Response> findTeamRequest(String teamName, int pageNum, int perPage) async{
    Map<String,dynamic> params = {
      'teamName': teamName,
      'pageNum': pageNum,
      'perPage': perPage
    };

    Response<dynamic> res = await Client.post('/team/findTeam',params);

    if(!res.success || (res.object as List).isEmpty) return res;

    List<Team> teams = (res.object as List)
        .map((item)=> MapperObject.create<Team>(item)).toList();

    Response<List<Team>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: teams
    );

    return response;
  }

  static Future<Response> getAllTeamMemberPaged(int teamId, int pageNum, int perPage) async{
    Map<String,dynamic> params = {
      'teamId': teamId,
      'pageNum': pageNum,
      'perPage': perPage
    };

    Response<dynamic> res = await Client.post('/team/getAllTeamMember',params);

    if(!res.success || (res.object as List).length == 0) return res;

    List<User> teamMembers = (res.object as List)
    .map((item) => MapperObject.create<User>(item)).toList();

    Response<List<User>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: teamMembers
    );

    return response;
  }

  static Future<Response> getTeamMemberByType(int teamId, int teamMemberType, int pageNum, int perPage) async{
    Map<String,dynamic> params = {
      'teamId': teamId,
      'memberType': teamMemberType,
      'page': pageNum,
      'count': perPage
    };
    Response<dynamic> res = await Client.post('/team/getUserByMemberType',params);

    if(!res.success || (res.object as List).length == 0) return res;

    List<User> teamMembers = (res.object as List)
        .map((item) => MapperObject.create<User>(item)).toList();

    Response<List<User>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: teamMembers
    );

    return response;
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

    Response<dynamic> res = await Client.post('/team/changeMemberType',params);
    return res;
  }

  static Future<Response> getMyTeam() async {
    Response<dynamic> res = await Client.post('/team/getTeamByUser',null);

    if(!res.success || (res.object as List).length == 0) return res;

    List<Team> teams = (res.object as List)
    .map((item)=> MapperObject.create<Team>(item)).toList();

    Response<List<Team>> response = new Response(
      errorCode: res.errorCode,
      success: res.success,
      object: teams
    );

    return response;
  }

  static Future<Response> getTeamLeaderBoard(int teamId) async {
    Map<String,dynamic> params = {
      'teamId': teamId
    };

    Response<dynamic> res = await Client.post('/team/getLeaderBoard', params);

    if(!res.success || (res.object as List).length == 0) return res;

    List<TeamLeaderboard> leaderboard = (res.object as List)
        .map((item)=> MapperObject.create<TeamLeaderboard>(item)).toList();

    Response<List<TeamLeaderboard>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: leaderboard
    );

    return response;
  }

  static Future<Response> findTeamMemberRequest(int teamId, String searchString, int pageNum, int perPage) async {
    Map<String,dynamic> params = {
      'teamId': teamId,
      'keyword': searchString,
      'offset': pageNum,
      'count': perPage
    };

    Response<dynamic> res = await Client.post('/team/findUser',params);

    if(!res.success || (res.object as List).isEmpty) return res;

    List<User> teamMembers = (res.object as List)
        .map((item)=> MapperObject.create<User>(item)).toList();

    Response<List<User>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: teamMembers
    );

    return response;
  }

  static Future<Response> findTeamMemberByTypeRequest(String searchString, int memberType, int pageNum, int perPage) async {
    Map<String,dynamic> params = {
      'searchString': searchString,
      'memberType': memberType,
      'pageNum': pageNum,
      'perPage': perPage
    };

    Response<dynamic> res = await Client.post('/team/findTeamMemberByType',params);

    if(!res.success || (res.object as List).isEmpty) return res;

    List<User> teamMembers = (res.object as List)
        .map((item)=> MapperObject.create<User>(item)).toList();

    Response<List<User>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: teamMembers
    );

    return response;
  }

  static Future<Response> getTeamActivityByTeamId(int teamId, int pageNum, int perPage) async {
    Map<String,dynamic> params = {
      'teamId': teamId,
      'offset': pageNum,
      'count': perPage
    };

    Response<dynamic> res = await Client.post('/activity/getActivitiesByTeam',params);

    if(!res.success || (res.object as List).isEmpty) return res;

    List<TeamActivityItem> teamActivities = (res.object as List)
        .map((item)=> MapperObject.create<TeamActivityItem>(item)).toList();

    Response<List<TeamActivityItem>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: teamActivities
    );

    return response;
  }


  static Future<Response> getTeamStatById(int teamId) async {
    Map<String,dynamic> params = {
      'teamId': teamId
    };

    Response<dynamic> res = await Client.post('/team/getTeamStat',params);

    if(!res.success || (res.object as List).isEmpty) return res;

    List<TeamStatItem> teamStat = (res.object as List)
        .map((item)=> MapperObject.create<TeamStatItem>(item)).toList();

    Response<List<TeamStatItem>> response = new Response(
        errorCode: res.errorCode,
        success: res.success,
        object: teamStat
    );

    return response;
  }


}
