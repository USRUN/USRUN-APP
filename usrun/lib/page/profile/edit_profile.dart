import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/widget/input_field.dart';
import 'package:usrun/widget/drop_down_menu.dart';
import 'package:usrun/widget/input_calendar.dart';
import 'package:usrun/widget/avatar_view.dart';

class EditProfilePage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();
  final String _userCode = "STU1653072";
  final _dropDownMenuItemList = [
    {'value': '0', 'text': 'Male'},
    {'value': '1', 'text': 'Female'}
  ];

  void _getDOBFunction(DateTime picker) {
    print("Birthday/DOB: ${picker.day}/${picker.month}/${picker.year}");

    // TODO: Do something with "picker" variable
  }

  void _getSelectedDropDownMenuItem(String newValue) {
    dynamic object = this._dropDownMenuItemList[0];

    for (int i = 0; i < this._dropDownMenuItemList.length; ++i) {
      if (this._dropDownMenuItemList[i]['value'].compareTo(newValue) == 0) {
        object = this._dropDownMenuItemList[i];
        break;
      }
    }

    print("Selected drop down menu item: ${object.toString()}");

    // TODO: Do something with "object" variable
  }

  void _updateProfile(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    // TODO: Function for updating changes of profile
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: R.colors.appBackground,
      appBar: GradientAppBar(
        leading: new IconButton(
          icon: Image.asset(
            R.myIcons.appBarBackBtn,
            width: R.appRatio.appAppBarIconSize,
          ),
          onPressed: () => pop(context),
        ),
        gradient: R.colors.uiGradient,
        centerTitle: true,
        title: Text(
          R.strings.editProfile,
          style: TextStyle(
              color: Colors.white, fontSize: R.appRatio.appFontSize22),
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              R.myIcons.appBarCheckBtn,
              width: R.appRatio.appAppBarIconSize,
            ),
            onPressed: () => _updateProfile(context),
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
                AvatarView(
                  avatarImageURL: R.images.avatarQuocTK,
                  avatarImageSize: R.appRatio.appAvatarSize150,
                  enableSquareAvatarImage: false,
                  pressAvatarImage: () {
                    // TODO: A function for doing something
                    // Example: Click to change avatar of my profile or my teams, or direct to other pages.
                    print("Nothing to show");
                  },
                  avatarBoxBorder: Border.all(
                    color: R.colors.majorOrange,
                    width: 2,
                  ),
                  supportImageURL: R.images.avatar,
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                Text(
                  "TRẦN KIẾN QUỐC",
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
                  _userCode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: R.colors.contentText,
                      fontSize: R.appRatio.appFontSize18),
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
                        controller: _firstNameController,
                        enableFullWidth: false,
                        labelTitle: "First Name",
                        hintText: "First Name",
                      ),
                    ),
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _lastNameController,
                        enableFullWidth: false,
                        labelTitle: "Last Name",
                        hintText: "Last Name",
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                InputField(
                  controller: _emailController,
                  enableFullWidth: true,
                  labelTitle: "Email",
                  hintText: "Type your email here",
                  textInputType: TextInputType.emailAddress,
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
                        controller: _countryController,
                        enableFullWidth: false,
                        labelTitle: "Country",
                        hintText: "Country",
                      ),
                    ),
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _cityController,
                        enableFullWidth: false,
                        labelTitle: "City",
                        hintText: "City",
                      ),
                    )
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
                        controller: _districtController,
                        enableFullWidth: false,
                        labelTitle: "District",
                        hintText: "District",
                      ),
                    ),
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _jobController,
                        enableFullWidth: false,
                        labelTitle: "What's Your Job?",
                        hintText: "Your Job",
                      ),
                    )
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
                      child: InputCalendar(
                        labelTitle: "Birthday",
                        enableFullWidth: false,
                        getDOBFunc: this._getDOBFunction,
                      ),
                    ),
                    Container(
                      child: DropDownMenu(
                        errorEmptyData: "Nothing to show",
                        enableFullWidth: false,
                        maxHeightBox: R.appRatio.appHeight320,
                        labelTitle: "Gender",
                        hintText: "Gender",
                        enableHorizontalLabelTitle: false,
                        onChanged: this._getSelectedDropDownMenuItem,
                        items: this._dropDownMenuItemList,
                      ),
                    )
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
                        labelTitle: "Height",
                        hintText: "170",
                        suffixText: "cm",
                        textInputType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: R.appRatio.appWidth181,
                      child: InputField(
                        controller: _weightController,
                        enableFullWidth: false,
                        labelTitle: "Weight",
                        hintText: "50",
                        suffixText: "kg",
                        textInputType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: R.appRatio.appSpacing25,
                ),
                InputField(
                  controller: _biographyController,
                  enableFullWidth: true,
                  labelTitle: "Biography",
                  hintText: "Share something about yourself...",
                  enableMaxLines: true,
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
  }
}
