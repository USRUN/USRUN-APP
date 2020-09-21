import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usrun/core/R.dart';
import 'package:usrun/core/helper.dart';
import 'package:usrun/util/image_cache_manager.dart';
import 'package:usrun/widget/introduction_screen/dots_decorator.dart';
import 'package:usrun/widget/introduction_screen/intro_button.dart';
import 'package:usrun/widget/introduction_screen/introduction.dart';

class OnBoardingPage extends StatefulWidget {
  final Function onIntroEndFunc;

  OnBoardingPage({
    this.onIntroEndFunc,
  });

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  final double _spacing = R.appRatio.appSpacing20;
  final Color _colorAccent = Color(0xFFDA2A16);

  List<Widget> _pageList;

  String _next = "";
  String _skip = "";
  String _start = "";

  String _title01 = "";
  String _description01 = "";
  String _title02 = "";
  String _description02 = "";
  String _title03 = "";
  String _description03 = "";
  String _title04 = "";
  String _description04 = "";
  String _title05 = "";
  String _description05 = "";
  String _finalMessage = "";

  @override
  void initState() {
    super.initState();
    _updateVariableByLocale();
    _updateOnboardingPages();
  }

  void _onIntroEnd() async {
    if (widget.onIntroEndFunc != null) {
      widget.onIntroEndFunc();
    } else {
      pop(context);
    }
  }

  void _updateVariableByLocale() {
    if (R.currentAppLanguage.compareTo("en") == 0) {
      _next = "Next";
      _skip = "Skip";
      _start = "Start";

      _title01 = "Welcome to USRUN!";
      _description01 =
          "We've got fascinating features ahead to help you maintain & improve your health with running";
      _title02 = "Record your run";
      _description02 =
          "Plot your running track, monitor real-time statistics and upload your activities along with theirs photos and info";
      _title03 = "Participate in teams";
      _description03 =
          "Become a part of the team and enjoy running events together";
      _title04 = "Running events";
      _description04 =
          "Participate in challenging events to compete with other teams or runners. We'll keep you informed about new, ongoing events and also past ones that you participated in";
      _title05 = "Personalize your application";
      _description05 =
          "We offer a lot of ways for you to make the application fit your preferences. Choose between a light and a dark theme, Vietnamese and English, SI and Non-SI unit of length";
      _finalMessage = "Start running now for a better health";
    } else {
      _next = "Tiếp tục";
      _skip = "Bỏ qua";
      _start = "Bắt đầu";

      _title01 = "Chào mừng bạn đến với USRUN!";
      _description01 =
          "Ứng dụng chạy bộ giúp bạn rèn luyện sức khỏe với những tính năng thú vị đang đợi bạn phía trước";
      _title02 = "Ghi nhận cuộc chạy";
      _description02 =
          "Theo dõi quãng đường chạy, hiển thị các thông số thông kê theo thời gian thực, và đăng tải hoạt động với những thông tin và hình ảnh thú vị về cuộc chạy của bạn";
      _title03 = "Tham gia đội, nhóm";
      _description03 =
          "Trở thành một đội viên để theo dõi hoạt động của nhóm và tham gia các sự kiện chạy bộ";
      _title04 = "Sự kiện Chạy bộ";
      _description04 =
          "Theo dõi thông tin những sự kiện mới nhất và quá khứ mà bạn đã từng tham gia, và tham gia sự kiện mà bạn muốn thử thách bản thân";
      _title05 = "Cấu hình ứng dụng";
      _description05 =
          "Thay đổi chủ đề, ngôn ngữ hiển thị, đơn vị đo và nhiều tính năng cấu hình ứng dụng mới lạ";
      _finalMessage = "Hãy chạy bộ vì sức khỏe của bạn";
    }
  }

  void _updateOnboardingPages() {
    _pageList = [
      _renderIntroPage(
        imageURL: R.images.onboarding01,
        title: _title01,
        description: _description01,
      ),
      _renderIntroPage(
        imageURL: R.images.onboarding02,
        title: _title02,
        description: _description02,
      ),
      _renderIntroPage(
        imageURL: R.images.onboarding03,
        title: _title03,
        description: _description03,
      ),
      _renderIntroPage(
        imageURL: R.images.onboarding04,
        title: _title04,
        description: _description04,
      ),
      _renderIntroPage(
        imageURL: R.images.onboarding05,
        title: _title05,
        description: _description05,
      ),
      _renderFinalPage(
        imageURL: R.images.onboarding06,
        message: _finalMessage,
      ),
    ];
  }

  Widget _renderAppLogo() {
    return Container(
      margin: EdgeInsets.only(
        top: _spacing * 2,
      ),
      child: Image.asset(
        R.images.logoText,
        width: 120,
      ),
    );
  }

  Widget _renderIntroPage({
    @required String imageURL,
    @required String title,
    @required String description,
  }) {
    Widget _renderTitle() {
      return Container(
        margin: EdgeInsets.only(
          top: R.appRatio.appSpacing15,
          bottom: R.appRatio.appSpacing15,
        ),
        child: Text(
          title,
          textScaleFactor: 1,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: R.colors.majorOrange,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    Widget _renderImage() {
      return ImageCacheManager.getImage(
        url: imageURL,
        height: R.appRatio.appHeight280,
        width: double.infinity,
        fit: BoxFit.contain,
      );
    }

    Widget _renderLine() {
      return Container(
        margin: EdgeInsets.only(
          top: _spacing,
          bottom: _spacing,
        ),
        child: ImageCacheManager.getImage(
          url: R.images.onboardingLine,
          width: double.infinity,
        ),
      );
    }

    Widget _renderDescription() {
      return Text(
        description,
        textScaleFactor: 1,
        overflow: TextOverflow.ellipsis,
        maxLines: 10,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      );
    }

    Widget _buildElement = Scaffold(
      resizeToAvoidBottomPadding: false,
      primary: false,
      appBar: PreferredSize(
        child: Container(),
        preferredSize: Size(0, 0),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        height: R.appRatio.deviceHeight,
        margin: EdgeInsets.only(
          left: _spacing,
          right: _spacing,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _renderAppLogo(),
              _renderTitle(),
              _renderImage(),
              _renderLine(),
              _renderDescription(),
            ],
          ),
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }

  Widget _renderFinalPage({
    @required String imageURL,
    @required String message,
  }) {
    Widget _renderImage() {
      return Container(
        margin: EdgeInsets.only(
          top: _spacing * 3,
          bottom: _spacing,
          left: _spacing,
          right: _spacing,
        ),
        child: ImageCacheManager.getImage(
          url: imageURL,
          height: R.appRatio.appHeight300,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      );
    }

    Widget _renderMessage() {
      return Text(
        message,
        textScaleFactor: 1,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: R.colors.majorOrange,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    Widget _buildElement = Scaffold(
      resizeToAvoidBottomPadding: false,
      primary: false,
      appBar: PreferredSize(
        child: Container(),
        preferredSize: Size(0, 0),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        height: R.appRatio.deviceHeight,
        margin: EdgeInsets.only(
          left: _spacing,
          right: _spacing,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _renderAppLogo(),
              _renderImage(),
              _renderMessage(),
            ],
          ),
        ),
      ),
    );

    return NotificationListener<OverscrollIndicatorNotification>(
      child: _buildElement,
      onNotification: (overScroll) {
        overScroll.disallowGlow();
        return false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: _introKey,
      pages: _pageList,
      screenDecoration: BoxDecoration(
        color: Colors.white,
      ),
      showSkipButton: true,
      showBackButton: false,
      backFlex: 0,
      directionBoxStyle: IntroBoxStyle(
        height: 60,
        width: R.appRatio.deviceWidth,
        alignment: null,
        boxDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
      ),
      onSkip: () => _onIntroEnd(),
      skipDecoration: IntroBoxStyle(
        margin: EdgeInsets.only(left: _spacing),
        alignment: Alignment.centerLeft,
        enableSplashColor: false,
      ),
      skip: Text(
        _skip,
        textScaleFactor: 1.0,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: R.colors.majorOrange,
        ),
      ),
      nextFlex: 0,
      nextDecoration: IntroBoxStyle(
        margin: EdgeInsets.only(right: _spacing),
        alignment: Alignment.centerRight,
        enableSplashColor: false,
      ),
      next: Text(
        _next,
        textScaleFactor: 1.0,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _colorAccent,
        ),
      ),
      onDone: () => _onIntroEnd(),
      doneDecoration: IntroBoxStyle(
        margin: EdgeInsets.only(right: _spacing),
        alignment: Alignment.centerRight,
        enableSplashColor: false,
      ),
      done: Text(
        _start,
        textScaleFactor: 1.0,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _colorAccent,
        ),
      ),
      dotsDecorator: DotsDecorator(
        spacing: EdgeInsets.all(4.0),
        size: Size(8.0, 8.0),
        color: R.colors.majorOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
        ),
        activeBoxShadow: R.styles.boxShadowB,
        activeColor: _colorAccent,
        activeSize: Size(14.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
        ),
      ),
    );
  }
}
