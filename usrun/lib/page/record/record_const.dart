enum RecordState {
  StatusNone,
  StatusStart,
  StatusStop,
  StatusResume,
  StatusFinish
}

enum ReportVisibility {
  Visible,
  Gone
}

enum GPSSignalStatus {
  CHECKING,
  READY,
  NOT_AVAILABLE,
  HIDE
}

enum ActivityPrivacyMode {
  Public,
  Follower,
  OnlyMe
}

enum ActivityStatus {
  ACTIVITY_STATUS_CREATE,
  ACTIVITY_STATUS_UPDATE,
  ACTIVITY_STATUS_FINISH
}



const MAX_POINT_IN_URLS = 230;

// Max time to rerender map
const MAX_TIME_MAP_UPDATE = 10;

// The maximum locations we can skip from the latest location.
const MAX_LOCATION_POINTS_INVALID_SKIP = 5;

const MAX_RECORD_DISTANCE_ALLOW_PER_SECOND = 16;

const MAX_RECORD_WAITING_TIME_ALLOW = 10;

const MAX_PACE_ALLOW = 30 * 60;

const MAX_PHOTO_UPLOAD = 4;
