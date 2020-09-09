# usrun

## Facebook signin:
<string name="facebook_app_id">148274109786625</string> <string name="fb_login_protocol_scheme">fb148274109786625</string>
appID: 148274109786625
appSecret: 9491347aff49bf0278881afe7ce21ed0

### setup
flutter packages pub run build_runner build DIR

### Full command (debug)
flutter clean && flutter pub get && flutter packages pub run build_runner build DIR && flutter run

### Full command (release)
flutter clean && flutter pub get && flutter packages pub run build_runner build DIR && flutter run --release
