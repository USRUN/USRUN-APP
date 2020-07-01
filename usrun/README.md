# usrun

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

#facebook_signin:
<string name="facebook_app_id">148274109786625</string> <string name="fb_login_protocol_scheme">fb148274109786625</string>
appID: 148274109786625
appSecret: 9491347aff49bf0278881afe7ce21ed0

# setup
flutter packages pub run build_runner build DIR

## Full command (debug)
flutter clean && flutter pub get && flutter packages pub run build_runner build DIR && flutter run

## Full command (release)
flutter clean && flutter pub get && flutter packages pub run build_runner build DIR && flutter run --release
