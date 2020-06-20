# Setup reflectable
flutter packages pub run build_runner build DIR

## Full command (debug)
flutter clean && flutter pub get && flutter packages pub run build_runner build DIR && flutter run

## Full command (release)
flutter clean && flutter pub get && flutter packages pub run build_runner build DIR && flutter run --release
