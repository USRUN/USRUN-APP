import 'package:usrun/util/reflector.dart';

const String STRAVA_CLIENT_ID = "26496";
const String STRAVA_CLIENT_SECRET = "06db3de6b974347549b2d27e3c4794dd05e3f811";
const String STRAVA_SCOPE = "profile:read_all,activity:read_all";

const DEFAULT_LENGTH = 30;

// Define error code
const LOGOUT_CODE = 100;
const MAINTENANCE = 101;
const FORCE_UPDATE = 102;

const FIELD_REQUIRED = 1000;
const ACCESS_DENY = 1001;
const UPDATE_FAIL = 1002;
const IMAGE_INVALID = 1003;
const OTP_INVALID = 1004;
const OTP_EXPIRED = 1005;

const USER_NOT_FOUND = 2000;
const USER_CAN_NOT_JOIN = 2001;
const USER_JOINED = 2002;
const USER_QUIT_FAIL = 2003;
const USER_CREATE_FAIL = 2004;
const USER_NOT_IN = 2005;
const USER_IS_OWNER = 2006;
const USER_DOES_NOT_PERMISSION = 2007;
const USER_UPDATE_PASSWORD_FAIL = 2008;
const USER_FOLLOW_FAIL = 2009;
const FOLOWER_NOT_FOUND = 2010;
const USER_EXISTED = 2011;
const USER_IS_CONNECTED = 2012;
const USER_CAN_NOT_CONNECT = 2013;
const USER_EMAIL_IS_USED = 2014;
const OPEN_ID_IS_USED = 2015;
const USER_CAN_NOT_DISCONNECT = 2016;
const USER_LOGIN_FAIL = 2017;
const USER_IS_IN_EVENT = 2018;
const USER_RESET_PASSWORD_FAIL = 2022;
const USER_EMAIL_NOT_FOUND = 2023;
const USER_EMAIL_IS_SOCIAL = 2024;

const TEAM_NOT_FOUND = 3000;

const EVENT_NOT_FOUND = 4000;
const EVENT_EVENT_EXIT = 4001;
const EVENT_UN_ACTIVE = 4002;
const EVENT_CAN_NOT_CREATE = 4003;

const ACTIVITY_NOT_FOUND = 5000;
const ACTIVITY_ADD_FAIL = 5001;

const FUND_NOT_FOUND = 6000;

const LEADER_BOARD_NOT_FOUND = 7000;
const LEADER_BOARD_CREATE_FAIL = 7001;
const LEADER_BOARD_NOT_SUPPORT = 7002;
const LEADER_BOARD_ACCESS_DENIED = 7003;
const LEADER_BOARD_DELETE_FAIL = 7004;

enum StatType {
  week,
  month,
  year,
}

@reflector
enum Gender {
  Other,
  Male,
  Female,
}

@reflector
enum FollowingPrivacy { FreeToFollow, RequestToFollow }

@reflector
enum ActivitiesPrivacy { Public, FollowersOnly, Private }

@reflector
enum FollowStatus {
  None,
  Requesting,
  Followed,
  Accepted,
  Denied,
}

@reflector
enum LoginChannel {
  Facebook,
  Google,
  Strava,
  UsRun,
}

@reflector
enum EventType { League, Team, User }

@reflector
enum UserRole { Owner, Admin, Member }

@reflector
enum TeamVerifyStatus {
  None,
  Verified,
  Public,
}

@reflector
enum MemberStatus { WaitingApprove, Active, Public }

@reflector
enum SportType {
  OTHER,
  CYCLING,
  RUNNING,
  WALKING,
  TRIATHLON,
  SWIMMING,
}

@reflector
enum LeaderBoardType {
  Team,
  Individual,
}

@reflector
enum LeaderBoardPrivacy {
  OnlyMe,
  AllParticipants,
  CustomParticipants,
}

enum ClubType {
  OTHER,
  CASUAL_CLUB,
  RACING_TEAM,
  SHOP,
  COMPANY,
}

enum RecordActivityType {
  UPRACE,
  STRAVA,
  GARMIN,
}

@reflector
enum TeamType {
  ALL,
  COMPANY,
  SPORTSCLUB,
  SCHOOL,
}

// List<String> sportTypesTitle = [
//   R.strings.other,
//   R.strings.cycling,
//   R.strings.running,
//   R.strings.walking,
//   R.strings.triathlon,
//   R.strings.swimming,
// ];

// List<String> leagueTypesTitle = [
//   "",
//   R.strings.company,
//   R.strings.sportClub,
//   R.strings.school,
// ];

@reflector
enum PushType {
  ActivityComplete,
  LikeOrComment,
  Mention,
  JoinEvent,
  Follow,
  RequestFollow,
  FollowerActivityComplete
}

enum PlatformType {
  Unknown,
  iOS,
  Android,
}

enum AppNotificationType {
  SYSTEM_ALERT,
  OPEN_STORE,
  OPEN_WEB,
}

@reflector
enum EventCertificateType {
  None,
  Achieved,
}
