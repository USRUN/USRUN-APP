
import 'package:usrun/core/define.dart';

class TeamMemberUtil{

  static TeamMemberType enumFromInt(int toCast){
    return TeamMemberType.values[toCast-1];
  }

  static String enumToString(TeamMemberType toCast){
    List<String> userRoleAsString = ['Owner', 'Admin', 'Member', 'Pending', 'Invited', 'Blocked', 'Guest'];

    return userRoleAsString[toCast.index];
  }

  static bool authorizeEqualLevel(TeamMemberType required, TeamMemberType toAuthorize){
    if(required.index == toAuthorize.index)
      return true;

    return false;
 }

  static bool authorizeHigherLevel(TeamMemberType required, TeamMemberType toAuthorize){
    if(toAuthorize.index <= required.index)
      return true;

    return false;
 }

 static bool authorizeLowerLevel(TeamMemberType required, TeamMemberType toAuthorize){
   if(toAuthorize.index >= required.index )
     return true;

   return false;
 }
}