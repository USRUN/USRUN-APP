import 'package:usrun/core/define.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class User with MapperObject {
  int userId;
  String openId;
  LoginChannel type;
  String code;
  String email;
  String avatar;
  String name;
  String nameSlug;
  bool isActive;
  String deviceToken;
  DateTime birthday;
  String phone;
  int province;
  Gender gender;
  num weight;
  num height;
  String accessToken;
  DateTime lastLogin;

  DateTime addDate;
  DateTime updateTime;

  bool hcmus;

  int followerCount;
  int followingCount;
  int activityCount;

  num distance;
  int rank;
  int activeDays;

  FollowingPrivacy followingPrivacy;
  ActivitiesPrivacy activitiesPrivacy;

  FollowStatus followStatus;

  List<int> notifications;

  TeamMemberType teamMemberType;

  @override
  bool operator ==(other) {
    if (other is User) {
      return userId == other.userId;
    }
    return false;
  }

  User({
    this.userId,
    this.openId,
    this.type,
    this.code,
    this.email,
    this.avatar,
    this.name,
    this.nameSlug,
    this.isActive,
    this.deviceToken,
    this.birthday,
    this.phone,
    this.province,
    this.gender,
    this.weight,
    this.height,
    this.accessToken,
    this.lastLogin,
    this.addDate,
    this.updateTime,
    this.hcmus,
    this.followerCount,
    this.followingCount,
    this.activityCount,
    this.distance,
    this.rank,
    this.activeDays,
    this.followingPrivacy,
    this.activitiesPrivacy,
    this.followStatus,
    this.notifications,
    this.teamMemberType,
  });
}
