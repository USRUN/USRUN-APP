import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';

/*
  ======================================
             CONFIGURATIONS
  ======================================
  <I> Add library to pubspec.yaml:
  + image_picker: ^0.6.7+4
  + image_cropper: ^1.2.3

  <II> Android
  + File name: AndroidManifest.xml
  + Add information to the "<application>" tag:
    android:requestLegacyExternalStorage="true"
  + Add "UCropActivity" into your AndroidManifest.xml:
    <activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>

  <III> IOS
    + Path: <project root>/ios/Runner/Info.plist
    + Add information (Choose "keys" you need to add):
      <key>NSPhotoLibraryUsageDescription</key>
      <string>Application needs photo library accessing permission to upload your own photo</string>
      <key>NSCameraUsageDescription</key>
      <string>Application needs camera usage accessing permission to take a photo</string>
      <key>NSMicrophoneUsageDescription</key>
      <string>Application needs microphone usage accessing permisstion to record videos</string>

  <IV> References:
    + image_picker: https://pub.dev/packages/image_picker/install
    + image_cropper: https://pub.dev/packages/image_cropper

  <V> How to use?:
    + 3 values of <result> variable below:
      - True: Take a photo or Open photo library successfully
      - False: Photo file has been cleared/removed
      - Null: Close action sheet

  void _doSomething() async {
    final CameraPicker _selectedCameraFile = CameraPicker();

    bool result =
        await _selectedCameraFile.showCameraPickerActionSheet(context, <Optional params>);
    if (result == null || !result) return;

    result = await _selectedCameraFile.cropImage(<Optional params>);
    if (!result) return;

    setState(() {});
  }
*/

enum CameraFileState {
  FREE,
  PICKED,
  CROPPED,
}

class CameraPicker {
  CameraFileState _cameraFileState = CameraFileState.FREE;
  PickedFile _file;
  final ImagePicker _picker = ImagePicker();

  ImagePicker get picker => _picker;

  PickedFile get file => _file;

  CameraFileState get cameraFileState => _cameraFileState;

  Future<String> toBase64() async {
    if (_file == null) return Future.value("");
    img.Image data = img.decodeImage(await _file.readAsBytes());
    data = img.bakeOrientation(data);
    return base64Encode(img.encodePng(data));
  }

  Future<PickedFile> showImagePicker({
    BuildContext context,
    ImageSource imageSource: ImageSource.gallery,
    double maxWidth: 800,
    double maxHeight: 600,
    int imageQuality: 95,
    CameraDevice preferredCameraDevice: CameraDevice.rear,
  }) async {
    if (imageQuality < 0) imageQuality = 0;
    if (imageQuality > 100) imageQuality = 100;

    _file = await _picker.getImage(
      source: imageSource,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
    );

    return _file;
  }

  Future<T> showCameraPickerActionSheet<T>(
    BuildContext context, {
    double maxWidth: 800,
    double maxHeight: 600,
    int imageQuality: 95,
    CameraDevice preferredCameraDevice: CameraDevice.rear,
    bool enableClearSelectedFile: false,
  }) {
    final double _spacing = 15.0;
    final double _radius = 7.0;
    final double _btnHeight = 50.0;

    Widget _renderButton({
      String text,
      Function func,
      ShapeBorder shapeBorder,
    }) {
      return SizedBox(
        height: _btnHeight,
        child: FlatButton(
          onPressed: func,
          padding: EdgeInsets.all(0),
          splashColor: Color.fromRGBO(253, 99, 44, 0.1),
          textColor: Colors.white,
          color: Colors.white,
          shape: shapeBorder ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              textScaleFactor: 1.0,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFFFD632C),
              ),
            ),
          ),
        ),
      );
    }

    return showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(_spacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(_radius),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    // Take a photo
                    _renderButton(
                      text: R.strings.takeAPhoto,
                      func: () async {
                        final result = await showImagePicker(
                          context: context,
                          imageSource: ImageSource.camera,
                          maxWidth: maxWidth,
                          maxHeight: maxHeight,
                          imageQuality: imageQuality,
                          preferredCameraDevice: preferredCameraDevice,
                        );

                        if (result == null) {
                          _cameraFileState = CameraFileState.FREE;
                        } else {
                          _cameraFileState = CameraFileState.PICKED;
                        }

                        pop(context, object: true);
                      },
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(_radius),
                          topRight: Radius.circular(_radius),
                        ),
                      ),
                    ),
                    // Horizontal divider
                    Divider(
                      color: Color(0xFFABABAB),
                      height: 1,
                      thickness: 0.4,
                    ),
                    // Open photo library
                    _renderButton(
                      text: R.strings.openPhotoLibrary,
                      func: () async {
                        final result = await showImagePicker(
                          context: context,
                          imageSource: ImageSource.gallery,
                          maxWidth: maxWidth,
                          maxHeight: maxHeight,
                          imageQuality: imageQuality,
                          preferredCameraDevice: preferredCameraDevice,
                        );

                        if (result == null) {
                          _cameraFileState = CameraFileState.FREE;
                        } else {
                          _cameraFileState = CameraFileState.PICKED;
                        }

                        pop(context, object: true);
                      },
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: (enableClearSelectedFile
                            ? BorderRadius.all(
                                Radius.circular(0),
                              )
                            : BorderRadius.only(
                                bottomLeft: Radius.circular(_radius),
                                bottomRight: Radius.circular(_radius),
                              )),
                      ),
                    ),
                    // Horizontal divider
                    Divider(
                      color: Color(0xFFABABAB),
                      height: 1,
                      thickness: 0.4,
                    ),
                    // Clear selected photo
                    (enableClearSelectedFile
                        ? _renderButton(
                            text: R.strings.clearSelectedFile,
                            func: () async {
                              _cameraFileState = CameraFileState.FREE;
                              _file = null;

                              pop(context, object: false);
                            },
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(_radius),
                                bottomRight: Radius.circular(_radius),
                              ),
                            ),
                          )
                        : Container()),
                  ],
                ),
              ),
              SizedBox(height: _spacing),
              _renderButton(
                text: R.strings.close,
                func: () => pop(context, object: false),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> cropImage({
    AndroidUiSettings androidUiSettings,
    IOSUiSettings iosUiSettings,
    List<CropAspectRatioPreset> aspectRatioPresets,
    int maxWidth,
    int maxHeight,
    CropAspectRatio aspectRatio,
    CropStyle cropStyle = CropStyle.rectangle,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 100,
  }) async {
    assert(maxWidth == null || maxWidth > 0);
    assert(maxHeight == null || maxHeight > 0);
    assert(compressQuality >= 0 && compressQuality <= 100);

    if (_file == null) return false;

    if (aspectRatioPresets == null || aspectRatioPresets.length == 0) {
      aspectRatioPresets = [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9,
      ];
    }

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: _file.path,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      aspectRatio: aspectRatio,
      compressFormat: compressFormat,
      compressQuality: compressQuality,
      cropStyle: cropStyle,
      aspectRatioPresets: aspectRatioPresets,
      androidUiSettings: androidUiSettings ??
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
      iosUiSettings: iosUiSettings ??
          IOSUiSettings(
            title: 'Cropper',
          ),
    );

    if (croppedFile != null) {
      _cameraFileState = CameraFileState.CROPPED;
      _file = PickedFile(croppedFile.path);
      return true;
    }

    return false;
  }
}
