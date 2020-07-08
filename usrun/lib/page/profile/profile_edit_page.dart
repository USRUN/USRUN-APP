import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/define.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/manager/user_manager.dart';
import 'package:usrun/model/user.dart';
import 'package:usrun/widget/avatar_view.dart';
import 'package:usrun/widget/drop_down_menu/drop_down_menu.dart';
import 'package:usrun/widget/drop_down_menu/drop_down_object.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/input_calendar.dart';
import 'package:usrun/widget/input_field.dart';

class EditProfilePage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  User editUser = new User();

  final _dropdownGender = [
    DropDownObject<Gender>(value: Gender.Male, text: 'Male'),
    DropDownObject<Gender>(value: Gender.Female, text: 'Female')
  ];

  List<DropDownObject<int>> _dropdownCities = [];

  void _setUpValue(){
    _nameController.text = UserManager.currentUser.name;
    if (UserManager.currentUser.height!=null)
      {
        _heightController.text = UserManager.currentUser.height.toString();
      }
    if (UserManager.currentUser.weight!=null)
    {
      _weightController.text = UserManager.currentUser.weight.toString();
    }
    R.strings.provinces.asMap().forEach((index, value) {
      _dropdownCities.add(DropDownObject<int>(value: index, text: value));
      print(_dropdownCities[index].value);
      print(_dropdownCities[index].text);
    });
  }



  void _getDOBFunction(DateTime picker) {
    print("Birthday/DOB: ${picker.day}/${picker.month}/${picker.year}");
    editUser.birthday = picker;
  }

  void _getSelectedDropDownGender<T>(T value) {
    print("Selected item with value: $value");
    editUser.gender = value as Gender;
  }

  void _getSelectedDropDownCities<T>(T value) {
    print("Selected item with value: $value");
    editUser.province = value as int;
  }

  void _updateProfile(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    // TODO: Function for updating changes of profile
  }

  @override
  Widget build(BuildContext context) {
    editUser.copy(UserManager.currentUser);
    _setUpValue();
    FocusScope.of(context).requestFocus(new FocusNode());
    Widget _buildElement = Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: GradientAppBar(
        leading: FlatButton(
          onPressed: () => pop(context),
          padding: EdgeInsets.all(0.0),
          splashColor: R.colors.lightBlurMajorOrange,
          textColor: Colors.white,
          child: ImageCacheManager.getImage(
            url: R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
            height: R.appRatio.appAppBarIconSize,
          ),
        ),
        gradient: R.colors.uiGradient,
        centerTitle: true,
        title: Text(
          R.strings.editProfile,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
        actions: <Widget>[
          Container(
            width: R.appRatio.appWidth60,
            child: FlatButton(
              onPressed: () => _updateProfile(context),
              padding: EdgeInsets.all(0.0),
              splashColor: R.colors.lightBlurMajorOrange,
              textColor: Colors.white,
              child: ImageCacheManager.getImage(
                url: R.myIcons.appBarCheckBtn,
                width: R.appRatio.appAppBarIconSize,
                height: R.appRatio.appAppBarIconSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: R.appRatio.appSpacing15,
            right: R.appRatio.appSpacing15,
          ),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Align(
                alignment: Alignment.center,
                child: AvatarView(
                    avatarImageURL: UserManager.currentUser.avatar,
                    avatarImageSize: R.appRatio.appAvatarSize150,
                    enableSquareAvatarImage: false,
                    pressAvatarImage: () {
                      // TODO: A function for doing something
                      // Example: Click to change avatar of my profile or my teams, or direct to other pages.
                      print(R.strings.nothingToShow);
                    },
                    avatarBoxBorder: Border.all(
                      color: R.colors.majorOrange,
                      width: 2,
                    ),
                    supportImageURL: editUser.hcmus?R.myIcons.hcmusLogo:null,
                  )
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Text(
                  UserManager.currentUser.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: R.colors.contentText,
                    fontSize: R.appRatio.appFontSize18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing5,
                ),
                Text(
                  UserManager.currentUser.code == null
                      ? "USRUN${UserManager.currentUser.userId}"
                      : UserManager.currentUser.code,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: R.colors.contentText,
                      fontSize: R.appRatio.appFontSize18),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Container(
                  width: R.appRatio.appWidth181,
                  child: InputField(
                    controller: _nameController,
                    enableFullWidth: false,
                    labelTitle: R.strings.name,
                    hintText: R.strings.name,
                  ),
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                DropDownMenu(
                  errorEmptyData: R.strings.nothingToShow,
                  labelTitle: R.strings.city,
                  hintText: R.strings.city,
                  enableHorizontalLabelTitle: false,
                  onChanged: this._getSelectedDropDownCities,
                  items: this._dropdownCities,
                  initialValue: 0,
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputCalendar(
                        labelTitle: R.strings.birthday,
                        defaultDay: editUser.birthday!=null?'${editUser.birthday.day}/${editUser.birthday.month}/${editUser.birthday.year}':'dd/mm/yyyyy',
                        enableFullWidth: false,
                        getDOBFunc: this._getDOBFunction,
                      ),
                    ),
                    DropDownMenu(
                      errorEmptyData: R.strings.nothingToShow,
                      enableFullWidth: false,
                      labelTitle: R.strings.gender,
                      hintText: R.strings.gender,
                      enableHorizontalLabelTitle: false,
                      onChanged: this._getSelectedDropDownGender,
                      items: this._dropdownGender,
                      initialValue: _dropdownGender[UserManager.currentUser.gender.index].value,
                    ),
                  ],
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _heightController,
                        enableFullWidth: false,
                        labelTitle: R.strings.height,
                        hintText: R.strings.height,
                        suffixText: "cm",
                        textInputType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _weightController,
                        enableFullWidth: false,
                        labelTitle: R.strings.weight,
                        hintText: R.strings.weight,
                        suffixText: "kg",
                        textInputType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
        child: _buildElement,
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        });
  }
}
