import 'dart:math';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'intro_button.dart';

class IntroductionScreen extends StatefulWidget {
  // All pages of the onboarding
  final List<Widget> pages;

  // Callback when Done button is pressed
  final VoidCallback onDone;

  // Done button
  final Widget done;

  // Decoration of Done button
  final IntroBoxStyle doneDecoration;

  // Back button
  final Widget back;

  // Decoration of Back button
  final IntroBoxStyle backDecoration;

  // Is the Back button should be display
  //
  // @Default `false`
  final bool showBackButton;

  // Callback when page change
  final ValueChanged<int> onChange;

  // Callback when Skip button is pressed
  final VoidCallback onSkip;

  // Skip button
  final Widget skip;

  // Decoration of Skip button
  final IntroBoxStyle skipDecoration;

  // Is the Skip button should be display
  //
  // @Default `false`
  final bool showSkipButton;

  // Next button
  final Widget next;

  // Decoration of Next button
  final IntroBoxStyle nextDecoration;

  // Is the Next button should be display
  //
  // @Default `true`
  final bool showNextButton;

  // Decoration of direction box
  final IntroBoxStyle directionBoxStyle;

  // Is the progress indicator should be display
  //
  // @Default `true`
  final bool isProgress;

  // Is the user is allow to change page
  //
  // @Default `false`
  final bool freeze;

  // Dots decorator to custom dots color, size and spacing
  final DotsDecorator dotsDecorator;

  // Animation duration in millisecondes
  //
  // @Default `350`
  final int animationDuration;

  // Index of the initial page
  //
  // @Default `0`
  final int initialPage;

  // Flex ratio of the back button
  //
  // @Default `1`
  final int backFlex;

  // Flex ratio of the skip button
  //
  // @Default `1`
  final int skipFlex;

  // Flex ratio of the progress indicator
  //
  // @Default `1`
  final int dotsFlex;

  // Flex ratio of the next/done button
  //
  // @Default `1`
  final int nextFlex;

  // Type of animation between pages
  //
  // @Default `Curves.easeIn`
  final Curve curve;

  const IntroductionScreen({
    Key key,
    @required this.pages,
    @required this.onDone,
    @required this.done,
    this.doneDecoration,
    this.back,
    this.backDecoration,
    this.showBackButton = false,
    this.onChange,
    this.onSkip,
    this.skip,
    this.skipDecoration,
    this.showSkipButton = false,
    this.next,
    this.nextDecoration,
    this.showNextButton = true,
    this.directionBoxStyle,
    this.isProgress = true,
    this.freeze = false,
    this.dotsDecorator = const DotsDecorator(),
    this.animationDuration = 350,
    this.initialPage = 0,
    this.backFlex = 1,
    this.skipFlex = 1,
    this.dotsFlex = 1,
    this.nextFlex = 1,
    this.curve = Curves.easeIn,
  })  : assert(pages != null),
        assert(
        pages.length > 0,
        "You provide at least one page on introduction screen !",
        ),
        assert(onDone != null),
        assert(done != null),
        assert((showSkipButton && skip != null) || !showSkipButton),
        assert(skipFlex >= 0 && dotsFlex >= 0 && nextFlex >= 0),
        assert(initialPage == null || initialPage >= 0),
        super(key: key);

  @override
  IntroductionScreenState createState() => IntroductionScreenState();
}

class IntroductionScreenState extends State<IntroductionScreen> {
  PageController _pageController;
  double _currentPage = 0.0;
  bool _isSkipPressed = false;
  bool _isScrolling = false;

  PageController get controller => _pageController;

  @override
  void initState() {
    super.initState();
    int initialPage = min(widget.initialPage, widget.pages.length - 1);
    _currentPage = initialPage.toDouble();
    _pageController = PageController(initialPage: initialPage);
  }

  void _onNext() {
    animateScroll(min(_currentPage.round() + 1, widget.pages.length - 1));
  }

  Future<void> _onSkip() async {
    if (widget.onSkip != null) return widget.onSkip();
    await skipToEnd();
  }

  void _onBack() {
    animateScroll(max(0, _currentPage.round() - 1));
  }

  Future<void> skipToEnd() async {
    if (!mounted) return;
    setState(() => _isSkipPressed = true);
    await animateScroll(widget.pages.length - 1);
    setState(() => _isSkipPressed = false);
  }

  Future<void> animateScroll(int page) async {
    if (!mounted) return;
    setState(() => _isScrolling = true);
    await _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: widget.animationDuration),
      curve: widget.curve,
    );
    setState(() => _isScrolling = false);
  }

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics is PageMetrics) {
      if (!mounted) return false;
      setState(() => _currentPage = metrics.page);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double appWidth = MediaQuery.of(context).size.width;
    double appHeight = MediaQuery.of(context).size.height;

    final isLastPage = (_currentPage.round() == widget.pages.length - 1);
    bool isSkipBtn = (!_isSkipPressed && !isLastPage && widget.showSkipButton);

    final isFirstPage = (_currentPage.round() == 0);
    bool isBackBtn = (!isFirstPage && widget.showBackButton);

    final skipBtn = IntroButton(
      child: widget.skip,
      decoration: widget.skipDecoration,
      onPressed: isSkipBtn ? _onSkip : null,
    );

    final nextBtn = IntroButton(
      child: widget.next,
      decoration: widget.nextDecoration,
      onPressed: widget.showNextButton && !_isScrolling ? _onNext : null,
    );

    final doneBtn = IntroButton(
      child: widget.done,
      decoration: widget.doneDecoration,
      onPressed: widget.onDone,
    );

    final backBtn = IntroButton(
      child: widget.back,
      decoration: widget.backDecoration,
      onPressed: widget.showBackButton && !_isScrolling ? _onBack : null,
    );

    final directionBoxStyle = (widget.directionBoxStyle ??
        IntroBoxStyle(
          height: 60,
          width: appWidth,
          alignment: null,
          boxDecoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
          ),
        ));

    Widget skipOrBackWidget;
    if (isSkipBtn) {
      skipOrBackWidget = Expanded(
        flex: widget.skipFlex,
        child: skipBtn,
      );
    } else if (isBackBtn) {
      skipOrBackWidget = Expanded(
        flex: widget.backFlex,
        child: backBtn,
      );
    } else {
      skipOrBackWidget = Expanded(
        flex: widget.skipFlex,
        child: Opacity(opacity: 0, child: skipBtn,),
      );
    }

    return Scaffold(
      body: Container(
        height: appHeight,
        child: Column(
          children: <Widget>[
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: PageView(
                  controller: _pageController,
                  physics: widget.freeze
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  children: widget.pages.map((p) => p).toList(),
                  onPageChanged: widget.onChange,
                ),
              ),
            ),
            Container(
              height: directionBoxStyle.height,
              width: directionBoxStyle.width,
              decoration: directionBoxStyle.boxDecoration,
              margin: directionBoxStyle.margin,
              alignment: directionBoxStyle.alignment,
              child: Row(
                children: [
                  skipOrBackWidget,
                  Expanded(
                    flex: widget.dotsFlex,
                    child: Center(
                      child: widget.isProgress
                          ? DotsIndicator(
                        dotsCount: widget.pages.length,
                        position: _currentPage,
                        decorator: widget.dotsDecorator,
                      )
                          : const SizedBox(),
                    ),
                  ),
                  Expanded(
                    flex: widget.nextFlex,
                    child: isLastPage
                        ? doneBtn
                        : widget.showNextButton
                        ? nextBtn
                        : Opacity(opacity: 0.0, child: nextBtn),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
