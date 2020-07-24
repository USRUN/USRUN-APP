import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/widget/ui_button.dart';

import 'custom_dialog/custom_alert_dialog.dart';

class ImageSourcePicker extends StatelessWidget {
  const ImageSourcePicker(
      {this.ratioX,
      this.ratioY,
      this.shape,
      this.maxWidth,
      this.maxHeight,
      this.quality, this.parentContext});
  final BuildContext parentContext;
  final CropStyle shape;
  final dynamic ratioX;
  final dynamic ratioY;
  final dynamic maxWidth;
  final dynamic maxHeight;
  final dynamic quality;


  void onChooseImageSource( ImageSource chosen) async {
    File photo = await ImagePicker.pickImage(source: chosen);
    if (photo == null) {
      pop(parentContext, object: null);
    } else {
      pop(
        parentContext,
        object: await handleImagePicked(shape, ratioX, ratioY, photo,
            maxWidth, maxHeight, quality),
      );
    }
  }



  Future<File> handleImagePicked(
      CropStyle cropStyle,
      double customRatioX,
      double customRatioY,
      File photo,
      int maxWidth,
      int maxHeight,
      int quality) async {
    int initSize = (await photo.length() ~/ 1000);
    int sizeDecreaseQuality = 3800;
    int sizeMax = 5500;
    int refDefaultSize = 4000;

    if (initSize > sizeMax) {
      await showCustomAlertDialog(parentContext,
          title: R.strings.imageUploadFailed,
          content: R.strings.imageTooLarge,
          firstButtonText: R.strings.ok,
          firstButtonFunction: () => {pop(parentContext, object: null)},
          secondButtonText: "");
      return null;
    }

    if (initSize > sizeDecreaseQuality) {
      quality = (refDefaultSize * quality) ~/ initSize;
    }

    File result = await ImageCropper.cropImage(
      sourcePath: photo.path,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      cropStyle: cropStyle,
      aspectRatio: CropAspectRatio(ratioX: customRatioX, ratioY: customRatioY),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: quality,
      androidUiSettings: R.imagePickerDefaults.defaultAndroidSettings,
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            child: Text(
              R.strings.chooseImage,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: R.appRatio.appFontSize18,
                color: R.colors.labelText,
              ),
            ),
          ),
          Divider(
            color: R.colors.majorOrange,
            height: 1,
          ),
          SizedBox(height: R.appRatio.appSpacing20),
          UIButton(
            text: R.strings.gallery.toUpperCase(),
            textSize: R.appRatio.appFontSize16,
            fontWeight: FontWeight.w700,
            height: 40,
            gradient: R.colors.uiGradient,
            onTap: () async {
              onChooseImageSource(ImageSource.gallery);
            },
          ),
          SizedBox(height: R.appRatio.appSpacing15),
          UIButton(
            text: R.strings.camera.toUpperCase(),
            textSize: R.appRatio.appFontSize16,
            gradient: R.colors.uiGradient,
            fontWeight: FontWeight.w700,
            height: 40,
            onTap: () async {
              onChooseImageSource(ImageSource.camera);
            },
          ),
          SizedBox(height: R.appRatio.appSpacing15),
          UIButton(
            text: R.strings.cancel.toUpperCase(),
            textSize: R.appRatio.appFontSize16,
            fontWeight: FontWeight.w700,
            height: 40,
            color: R.colors.grayABABAB,
            onTap: () => pop(context, object: null),
          ),
        ],
      ),
    );
  }
}
