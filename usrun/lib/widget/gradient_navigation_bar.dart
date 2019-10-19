import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:usrun/core/R.dart';

import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

const double _kNavBarPersistentHeight = 44.0;
const _HeroTag _defaultHeroTag = _HeroTag(null);
const Duration _kNavBarTitleFadeDuration = Duration(milliseconds: 150);
const double _kNavBarBackButtonTapWidth = 50.0;
const double _kNavBarEdgePadding = 16.0;

enum RouteType {
  push,
  present,
  show,
}

class NoneNavigationBar extends StatelessWidget implements ObstructingPreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

  @override
  bool get fullObstruction => null;

  @override
  Size get preferredSize {
    return const Size.fromHeight(0);
  }
}

class GradientNavigationBar extends StatefulWidget implements ObstructingPreferredSizeWidget {
  const GradientNavigationBar({
    Key key,
    this.routeType = RouteType.push,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyMiddle = true,
    this.previousPageTitle,
    this.middle,
    this.trailing,
    this.backgroundColor,
    this.padding,
    this.actionsForegroundColor,
    this.transitionBetweenRoutes = true,
    this.heroTag = _defaultHeroTag,
  })  : assert(automaticallyImplyLeading != null),
        assert(automaticallyImplyMiddle != null),
        assert(transitionBetweenRoutes != null),
        assert(heroTag != null),
        assert(!transitionBetweenRoutes || identical(heroTag, _defaultHeroTag)),
        super(key: key);

  final Widget leading;
  final RouteType routeType;
  final bool automaticallyImplyLeading;
  final bool automaticallyImplyMiddle;
  final String previousPageTitle;
  final Widget middle;
  final Widget trailing;
  final Color backgroundColor;
  final EdgeInsetsDirectional padding;
  final Color actionsForegroundColor;
  final bool transitionBetweenRoutes;
  final Object heroTag;

  /// True if the navigation bar's background color has no transparency.
  @override
  bool get fullObstruction => backgroundColor == null ? null : backgroundColor.alpha == 0xFF;

  @override
  Size get preferredSize {
    return const Size.fromHeight(_kNavBarPersistentHeight);
  }

  @override
  _GradientNavigationBarState createState() {
    return _GradientNavigationBarState();
  }
}

// A state class exists for the nav bar so that the keys of its sub-components
// don't change when rebuilding the nav bar, causing the sub-components to
// lose their own states.
class _GradientNavigationBarState extends State<GradientNavigationBar> {
  _NavigationBarStaticComponentsKeys keys;

  Border border = _GradientBorder.fromBorderSide(
    BorderSide.none,
    gradient: R.colors.uiGradient,
  );

  @override
  void initState() {
    super.initState();
    keys = _NavigationBarStaticComponentsKeys();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = widget.backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor;

    final _NavigationBarStaticComponents components = _NavigationBarStaticComponents(
      keys: keys,
      routeType: widget.routeType,
      route: ModalRoute.of(context),
      userLeading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      automaticallyImplyTitle: widget.automaticallyImplyMiddle,
      previousPageTitle: widget.previousPageTitle,
      userMiddle: widget.middle,
      userTrailing: widget.trailing,
      padding: widget.padding,
      userLargeTitle: null,
      large: false,
    );

    final Widget navBar = _wrapWithBackground(
      border: border,
      backgroundColor: backgroundColor,
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: _PersistentNavigationBar(
          components: components,
          padding: widget.padding,
        ),
      ),
    );

    if (!widget.transitionBetweenRoutes || !_isTransitionable(context)) {
      // Lint ignore to maintain backward compatibility.
      return _wrapActiveColor(widget.actionsForegroundColor, context, navBar); // ignore: deprecated_member_use_from_same_package
    }

    return SafeArea(
        child: _wrapActiveColor(
      // Lint ignore to maintain backward compatibility.
      widget.actionsForegroundColor,
      // ignore: deprecated_member_use_from_same_package
      context,
      Builder(
        // Get the context that might have a possibly changed CupertinoTheme.
        builder: (BuildContext context) {
          return Hero(
            tag: widget.heroTag == _defaultHeroTag ? _HeroTag(Navigator.of(context)) : widget.heroTag,
            createRectTween: _linearTranslateWithLargestRectSizeTween,
            placeholderBuilder: _navBarHeroLaunchPadBuilder,
            flightShuttleBuilder: _navBarHeroFlightShuttleBuilder,
            transitionOnUserGestures: true,
            child: _TransitionableNavigationBar(
              componentsKeys: keys,
              backgroundColor: backgroundColor,
              backButtonTextStyle: CupertinoTheme.of(context).textTheme.navActionTextStyle,
              titleTextStyle: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              largeTitleTextStyle: null,
              border: border,
              hasUserMiddle: widget.middle != null,
              largeExpanded: false,
              child: navBar,
            ),
          );
        },
      ),
    ));
  }
}

class _GradientBorder extends Border {
  const _GradientBorder({
    this.gradient,
    BorderSide top = BorderSide.none,
    BorderSide right = BorderSide.none,
    BorderSide bottom = BorderSide.none,
    BorderSide left = BorderSide.none,
  }) : super(top: top, right: right, bottom: bottom, left: left);

  const _GradientBorder.fromBorderSide(BorderSide side, {this.gradient}) : super.fromBorderSide(side);

  final Gradient gradient;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius borderRadius,
  }) {
    if (gradient != null) {
      canvas.drawRect(
        rect,
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.fill,
      );
    }

    super.paint(
      canvas,
      rect,
      textDirection: textDirection,
      shape: shape,
      borderRadius: borderRadius,
    );
  }
}

class _HeroTag {
  const _HeroTag(this.navigator);

  final NavigatorState navigator;

  // Let the Hero tag be described in tree dumps.
  @override
  String toString() => 'Default Hero tag for Cupertino navigation bars with navigator $navigator';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final _HeroTag otherTag = other;
    return navigator == otherTag.navigator;
  }

  @override
  int get hashCode {
    return identityHashCode(navigator);
  }
}

class _PersistentNavigationBar extends StatelessWidget {
  const _PersistentNavigationBar({
    Key key,
    this.components,
    this.padding,
    this.middleVisible,
  }) : super(key: key);

  final _NavigationBarStaticComponents components;

  final EdgeInsetsDirectional padding;

  /// Whether the middle widget has a visible animated opacity. A null value
  /// means the middle opacity will not be animated.
  final bool middleVisible;

  @override
  Widget build(BuildContext context) {
    Widget middle = components.middle;

    if (middle != null) {
      middle = DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        child: Semantics(header: true, child: middle),
      );
      // When the middle's visibility can change on the fly like with large title
      // slivers, wrap with animated opacity.
      middle = middleVisible == null
          ? middle
          : AnimatedOpacity(
              opacity: middleVisible ? 1.0 : 0.0,
              duration: _kNavBarTitleFadeDuration,
              child: middle,
            );
    }

    Widget leading = components.leading;
    final Widget backChevron = components.backChevron;
    final Widget backLabel = components.backLabel;

    if (leading == null && backChevron != null && backLabel != null) {
      leading = CupertinoNavigationBarBackButton._assemble(
        backChevron,
        backLabel,
      );
    }

    Widget paddedToolbar = NavigationToolbar(
      leading: leading,
      middle: middle,
      trailing: components.trailing,
      centerMiddle: true,
      middleSpacing: 6.0,
    );

    if (padding != null) {
      paddedToolbar = Padding(
        padding: EdgeInsets.only(
          top: padding.top,
          bottom: padding.bottom,
        ),
        child: paddedToolbar,
      );
    }

    return SizedBox(
      height: _kNavBarPersistentHeight + MediaQuery.of(context).padding.top,
      child: SafeArea(
        bottom: false,
        child: paddedToolbar,
      ),
    );
  }
}

class CupertinoNavigationBarBackButton extends StatelessWidget {
  /// Construct a [CupertinoNavigationBarBackButton] that can be used to pop
  /// the current route.
  ///
  /// The [color] parameter must not be null.
  const CupertinoNavigationBarBackButton({
    this.color,
    this.previousPageTitle,
  })  : _backChevron = null,
        _backLabel = null;

  // Allow the back chevron and label to be separately created (and keyed)
  // because they animate separately during page transitions.
  const CupertinoNavigationBarBackButton._assemble(
    this._backChevron,
    this._backLabel,
  )   : previousPageTitle = null,
        color = null;

  /// The [Color] of the back button.
  ///
  /// Can be used to override the color of the back button chevron and label.
  ///
  /// Defaults to [CupertinoTheme]'s `primaryColor` if null.
  final Color color;

  /// An override for showing the previous route's title. If null, it will be
  /// automatically derived from [CupertinoPageRoute.title] if the current and
  /// previous routes are both [CupertinoPageRoute]s.
  final String previousPageTitle;

  final Widget _backChevron;

  final Widget _backLabel;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic> currentRoute = ModalRoute.of(context);
    assert(
      currentRoute?.canPop == true,
      'CupertinoNavigationBarBackButton should only be used in routes that can be popped',
    );

    TextStyle actionTextStyle = CupertinoTheme.of(context).textTheme.navActionTextStyle;
    if (color != null) {
      actionTextStyle = actionTextStyle.copyWith(color: color);
    }

    return CupertinoButton(
      child: Semantics(
        container: true,
        excludeSemantics: true,
        label: 'Back',
        button: true,
        child: DefaultTextStyle(
          style: actionTextStyle,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: _kNavBarBackButtonTapWidth),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(padding: EdgeInsetsDirectional.only(start: 8.0)),
                _backChevron ?? const _BackChevron(),
                const Padding(padding: EdgeInsetsDirectional.only(start: 6.0)),
                Flexible(
                  child: _backLabel ??
                      _BackLabel(
                        specifiedPreviousTitle: previousPageTitle,
                        route: currentRoute,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.maybePop(context);
      },
    );
  }
}

class _BackChevron extends StatelessWidget {
  const _BackChevron({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);
    final TextStyle textStyle = DefaultTextStyle.of(context).style;

    // Replicate the Icon logic here to get a tightly sized icon and add
    // custom non-square padding.
    Widget iconWidget = Text.rich(
      TextSpan(
        text: String.fromCharCode(CupertinoIcons.back.codePoint),
        style: TextStyle(
          inherit: false,
          color: textStyle.color,
          fontSize: 34.0,
          fontFamily: CupertinoIcons.back.fontFamily,
          package: CupertinoIcons.back.fontPackage,
        ),
      ),
    );
    switch (textDirection) {
      case TextDirection.rtl:
        iconWidget = Transform(
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
          alignment: Alignment.center,
          transformHitTests: false,
          child: iconWidget,
        );
        break;
      case TextDirection.ltr:
        break;
    }

    return iconWidget;
  }
}

class _BackLabel extends StatelessWidget {
  const _BackLabel({
    Key key,
    @required this.specifiedPreviousTitle,
    @required this.route,
  })  : assert(route != null),
        super(key: key);

  final String specifiedPreviousTitle;
  final ModalRoute<dynamic> route;

  // `child` is never passed in into ValueListenableBuilder so it's always
  // null here and unused.
  Widget _buildPreviousTitleWidget(BuildContext context, String previousTitle, Widget child) {
    if (previousTitle == null) {
      return const SizedBox(height: 0.0, width: 0.0);
    }

    Text textWidget = Text(
      previousTitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (previousTitle.length > 12) {
      textWidget = const Text('Back');
    }

    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1.0,
      child: textWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (specifiedPreviousTitle != null) {
      return _buildPreviousTitleWidget(context, specifiedPreviousTitle, null);
    } else if (route is CupertinoPageRoute<dynamic>) {
      final CupertinoPageRoute<dynamic> cupertinoRoute = route;
      // There is no timing issue because the previousTitle Listenable changes
      // happen during route modifications before the ValueListenableBuilder
      // is built.
      return ValueListenableBuilder<String>(
        valueListenable: cupertinoRoute.previousTitle,
        builder: _buildPreviousTitleWidget,
      );
    } else {
      return const SizedBox(height: 0.0, width: 0.0);
    }
  }
}

@immutable
class _NavigationBarStaticComponentsKeys {
  _NavigationBarStaticComponentsKeys()
      : navBarBoxKey = GlobalKey(debugLabel: 'Navigation bar render box'),
        leadingKey = GlobalKey(debugLabel: 'Leading'),
        backChevronKey = GlobalKey(debugLabel: 'Back chevron'),
        backLabelKey = GlobalKey(debugLabel: 'Back label'),
        middleKey = GlobalKey(debugLabel: 'Middle'),
        trailingKey = GlobalKey(debugLabel: 'Trailing'),
        largeTitleKey = GlobalKey(debugLabel: 'Large title');

  final GlobalKey navBarBoxKey;
  final GlobalKey leadingKey;
  final GlobalKey backChevronKey;
  final GlobalKey backLabelKey;
  final GlobalKey middleKey;
  final GlobalKey trailingKey;
  final GlobalKey largeTitleKey;
}

@immutable
class _NavigationBarStaticComponents {
  _NavigationBarStaticComponents({
    @required _NavigationBarStaticComponentsKeys keys,
    @required RouteType routeType,
    @required ModalRoute<dynamic> route,
    @required Widget userLeading,
    @required bool automaticallyImplyLeading,
    @required bool automaticallyImplyTitle,
    @required String previousPageTitle,
    @required Widget userMiddle,
    @required Widget userTrailing,
    @required Widget userLargeTitle,
    @required EdgeInsetsDirectional padding,
    @required bool large,
  })  : leading = createLeading(
          leadingKey: keys.leadingKey,
          userLeading: userLeading,
          route: route,
          automaticallyImplyLeading: automaticallyImplyLeading,
          padding: padding,
          routeType: routeType,
        ),
        backChevron = createBackChevron(
          backChevronKey: keys.backChevronKey,
          userLeading: userLeading,
          route: route,
          automaticallyImplyLeading: automaticallyImplyLeading,
          routeType: routeType,
        ),
        backLabel = createBackLabel(
          backLabelKey: keys.backLabelKey,
          userLeading: userLeading,
          route: route,
          previousPageTitle: previousPageTitle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          routeType: routeType,
        ),
        middle = createMiddle(
          middleKey: keys.middleKey,
          userMiddle: userMiddle,
          userLargeTitle: userLargeTitle,
          route: route,
          automaticallyImplyTitle: automaticallyImplyTitle,
          large: large,
        ),
        trailing = createTrailing(
          trailingKey: keys.trailingKey,
          userTrailing: userTrailing,
          padding: padding,
        ),
        largeTitle = createLargeTitle(
          largeTitleKey: keys.largeTitleKey,
          userLargeTitle: userLargeTitle,
          route: route,
          automaticImplyTitle: automaticallyImplyTitle,
          large: large,
        );

  static Widget _derivedTitle({
    bool automaticallyImplyTitle,
    ModalRoute<dynamic> currentRoute,
  }) {
    // Auto use the CupertinoPageRoute's title if middle not provided.
    if (automaticallyImplyTitle && currentRoute is CupertinoPageRoute && currentRoute.title != null) {
      return Text(currentRoute.title);
    }

    return null;
  }

  final KeyedSubtree leading;

  static KeyedSubtree createLeading({
    @required GlobalKey leadingKey,
    @required Widget userLeading,
    @required ModalRoute<dynamic> route,
    @required bool automaticallyImplyLeading,
    @required EdgeInsetsDirectional padding,
    @required RouteType routeType,
  }) {
    Widget leadingContent;

    if (userLeading != null) {
      leadingContent = userLeading;
    } else if (automaticallyImplyLeading && route is PageRoute && route.canPop && route.fullscreenDialog && routeType == RouteType.present) {
      leadingContent = CupertinoButton(
        child: const Text('Close',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
            )),
        padding: EdgeInsets.zero,
        onPressed: () {
          route.navigator.maybePop();
        },
      );
    }

    if (leadingContent == null) {
      return null;
    }

    return KeyedSubtree(
      key: leadingKey,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: padding?.start ?? _kNavBarEdgePadding,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(
            size: 32.0,
          ),
          child: leadingContent,
        ),
      ),
    );
  }

  final KeyedSubtree backChevron;

  static KeyedSubtree createBackChevron({
    @required GlobalKey backChevronKey,
    @required Widget userLeading,
    @required ModalRoute<dynamic> route,
    @required bool automaticallyImplyLeading,
    @required RouteType routeType,
  }) {
    if (userLeading != null || !automaticallyImplyLeading || route == null || !route.canPop || routeType == RouteType.present) {
      return null;
    }
    return KeyedSubtree(key: backChevronKey, child: const _BackChevron());
  }

  /// This widget is not decorated with a font since the font style could
  /// animate during transitions.
  final KeyedSubtree backLabel;

  static KeyedSubtree createBackLabel({
    @required GlobalKey backLabelKey,
    @required Widget userLeading,
    @required ModalRoute<dynamic> route,
    @required bool automaticallyImplyLeading,
    @required String previousPageTitle,
    @required RouteType routeType,
  }) {
    if (userLeading != null || !automaticallyImplyLeading || route == null || !route.canPop || routeType == RouteType.present) {
      return null;
    }

    return KeyedSubtree(
      key: backLabelKey,
      child: _BackLabel(
        specifiedPreviousTitle: previousPageTitle,
        route: route,
      ),
    );
  }

  /// This widget is not decorated with a font since the font style could
  /// animate during transitions.
  final KeyedSubtree middle;

  static KeyedSubtree createMiddle({
    @required GlobalKey middleKey,
    @required Widget userMiddle,
    @required Widget userLargeTitle,
    @required bool large,
    @required bool automaticallyImplyTitle,
    @required ModalRoute<dynamic> route,
  }) {
    Widget middleContent = userMiddle;

    if (large) {
      middleContent ??= userLargeTitle;
    }

    middleContent ??= _derivedTitle(
      automaticallyImplyTitle: automaticallyImplyTitle,
      currentRoute: route,
    );

    if (middleContent == null) {
      return null;
    }

    return KeyedSubtree(
      key: middleKey,
      child: middleContent,
    );
  }

  final KeyedSubtree trailing;

  static KeyedSubtree createTrailing({
    @required GlobalKey trailingKey,
    @required Widget userTrailing,
    @required EdgeInsetsDirectional padding,
  }) {
    if (userTrailing == null) {
      return null;
    }

    return KeyedSubtree(
      key: trailingKey,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: padding?.end ?? _kNavBarEdgePadding,
        ),
        child: IconTheme.merge(
          data: const IconThemeData(
            size: 32.0,
          ),
          child: userTrailing,
        ),
      ),
    );
  }

  /// This widget is not decorated with a font since the font style could
  /// animate during transitions.
  final KeyedSubtree largeTitle;

  static KeyedSubtree createLargeTitle({
    @required GlobalKey largeTitleKey,
    @required Widget userLargeTitle,
    @required bool large,
    @required bool automaticImplyTitle,
    @required ModalRoute<dynamic> route,
  }) {
    if (!large) {
      return null;
    }

    final Widget largeTitleContent = userLargeTitle ??
        _derivedTitle(
          automaticallyImplyTitle: automaticImplyTitle,
          currentRoute: route,
        );

    assert(
      largeTitleContent != null,
      'largeTitle was not provided and there was no title from the route.',
    );

    return KeyedSubtree(
      key: largeTitleKey,
      child: largeTitleContent,
    );
  }
}

class _TransitionableNavigationBar extends StatelessWidget {
  _TransitionableNavigationBar({
    @required this.componentsKeys,
    @required this.backgroundColor,
    @required this.backButtonTextStyle,
    @required this.titleTextStyle,
    @required this.largeTitleTextStyle,
    @required this.border,
    @required this.hasUserMiddle,
    @required this.largeExpanded,
    @required this.child,
  })  : assert(componentsKeys != null),
        assert(largeExpanded != null),
        assert(!largeExpanded || largeTitleTextStyle != null),
        super(key: componentsKeys.navBarBoxKey);

  final _NavigationBarStaticComponentsKeys componentsKeys;
  final Color backgroundColor;
  final TextStyle backButtonTextStyle;
  final TextStyle titleTextStyle;
  final TextStyle largeTitleTextStyle;
  final Border border;
  final bool hasUserMiddle;
  final bool largeExpanded;
  final Widget child;

  RenderBox get renderBox {
    final RenderBox box = componentsKeys.navBarBoxKey.currentContext.findRenderObject();
    assert(
      box.attached,
      '_TransitionableNavigationBar.renderBox should be called when building '
      'hero flight shuttles when the from and the to nav bar boxes are already '
      'laid out and painted.',
    );
    return box;
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      bool inHero;
      context.visitAncestorElements((Element ancestor) {
        if (ancestor is ComponentElement) {
          assert(
            ancestor.widget.runtimeType != _NavigationBarTransition,
            '_TransitionableNavigationBar should never re-appear inside '
            '_NavigationBarTransition. Keyed _TransitionableNavigationBar should '
            'only serve as anchor points in routes rather than appearing inside '
            'Hero flights themselves.',
          );
          if (ancestor.widget.runtimeType == Hero) {
            inHero = true;
          }
        }
        inHero ??= false;
        return true;
      });
      assert(
        inHero == true,
        '_TransitionableNavigationBar should only be added as the immediate '
        'child of Hero widgets.',
      );
      return true;
    }());
    return child;
  }
}

class _NavigationBarTransition extends StatelessWidget {
  _NavigationBarTransition({
    @required this.animation,
    @required this.topNavBar,
    @required this.bottomNavBar,
  })  : heightTween = Tween<double>(
          begin: bottomNavBar.renderBox.size.height,
          end: topNavBar.renderBox.size.height,
        ),
        backgroundTween = ColorTween(
          begin: bottomNavBar.backgroundColor,
          end: topNavBar.backgroundColor,
        ),
        borderTween = BorderTween(
          begin: bottomNavBar.border,
          end: topNavBar.border,
        );

  final Animation<double> animation;
  final _TransitionableNavigationBar topNavBar;
  final _TransitionableNavigationBar bottomNavBar;

  final Tween<double> heightTween;
  final ColorTween backgroundTween;
  final BorderTween borderTween;

  @override
  Widget build(BuildContext context) {
    final _NavigationBarComponentsTransition componentsTransition = _NavigationBarComponentsTransition(
      animation: animation,
      bottomNavBar: bottomNavBar,
      topNavBar: topNavBar,
      directionality: Directionality.of(context),
    );

    final List<Widget> children = <Widget>[
      // Draw an empty navigation bar box with changing shape behind all the
      // moving components without any components inside it itself.
      AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return _wrapWithBackground(
            // Don't update the system status bar color mid-flight.
            updateSystemUiOverlay: false,
            backgroundColor: backgroundTween.evaluate(animation),
            border: _GradientBorder.fromBorderSide(
              BorderSide.none,
              gradient: R.colors.uiGradient
            ),
            child: SizedBox(
              height: heightTween.evaluate(animation),
              width: double.infinity,
            ),
          );
        },
      ),
      // Draw all the components on top of the empty bar box.
      componentsTransition.bottomBackChevron,
      componentsTransition.bottomBackLabel,
      componentsTransition.bottomLeading,
      componentsTransition.bottomMiddle,
      componentsTransition.bottomLargeTitle,
      componentsTransition.bottomTrailing,
      // Draw top components on top of the bottom components.
      componentsTransition.topLeading,
      componentsTransition.topBackChevron,
      componentsTransition.topBackLabel,
      componentsTransition.topMiddle,
      componentsTransition.topLargeTitle,
      componentsTransition.topTrailing,
    ];

    children.removeWhere((Widget child) => child == null);

    // The actual outer box is big enough to contain both the bottom and top
    // navigation bars. It's not a direct Rect lerp because some components
    // can actually be outside the linearly lerp'ed Rect in the middle of
    // the animation, such as the topLargeTitle.
    return SizedBox(
      height: math.max(heightTween.begin, heightTween.end) + MediaQuery.of(context).padding.top,
      width: double.infinity,
      child: Stack(
        children: children,
      ),
    );
  }
}

@immutable
class _NavigationBarComponentsTransition {
  _NavigationBarComponentsTransition({
    @required this.animation,
    @required _TransitionableNavigationBar bottomNavBar,
    @required _TransitionableNavigationBar topNavBar,
    @required TextDirection directionality,
  })  : bottomComponents = bottomNavBar.componentsKeys,
        topComponents = topNavBar.componentsKeys,
        bottomNavBarBox = bottomNavBar.renderBox,
        topNavBarBox = topNavBar.renderBox,
        bottomBackButtonTextStyle = bottomNavBar.backButtonTextStyle,
        topBackButtonTextStyle = topNavBar.backButtonTextStyle,
        bottomTitleTextStyle = bottomNavBar.titleTextStyle,
        topTitleTextStyle = topNavBar.titleTextStyle,
        bottomLargeTitleTextStyle = bottomNavBar.largeTitleTextStyle,
        topLargeTitleTextStyle = topNavBar.largeTitleTextStyle,
        bottomHasUserMiddle = bottomNavBar.hasUserMiddle,
        topHasUserMiddle = topNavBar.hasUserMiddle,
        bottomLargeExpanded = bottomNavBar.largeExpanded,
        topLargeExpanded = topNavBar.largeExpanded,
        transitionBox =
            // paintBounds are based on offset zero so it's ok to expand the Rects.
            bottomNavBar.renderBox.paintBounds.expandToInclude(topNavBar.renderBox.paintBounds),
        forwardDirection = directionality == TextDirection.ltr ? 1.0 : -1.0;

  static final Animatable<double> fadeOut = Tween<double>(
    begin: 1.0,
    end: 0.0,
  );
  static final Animatable<double> fadeIn = Tween<double>(
    begin: 0.0,
    end: 1.0,
  );

  final Animation<double> animation;
  final _NavigationBarStaticComponentsKeys bottomComponents;
  final _NavigationBarStaticComponentsKeys topComponents;

  // These render boxes that are the ancestors of all the bottom and top
  // components are used to determine the components' relative positions inside
  // their respective navigation bars.
  final RenderBox bottomNavBarBox;
  final RenderBox topNavBarBox;

  final TextStyle bottomBackButtonTextStyle;
  final TextStyle topBackButtonTextStyle;
  final TextStyle bottomTitleTextStyle;
  final TextStyle topTitleTextStyle;
  final TextStyle bottomLargeTitleTextStyle;
  final TextStyle topLargeTitleTextStyle;

  final bool bottomHasUserMiddle;
  final bool topHasUserMiddle;
  final bool bottomLargeExpanded;
  final bool topLargeExpanded;

  // This is the outer box in which all the components will be fitted. The
  // sizing component of RelativeRects will be based on this rect's size.
  final Rect transitionBox;

  // x-axis unity number representing the direction of growth for text.
  final double forwardDirection;

  // Take a widget it its original ancestor navigation bar render box and
  // translate it into a RelativeBox in the transition navigation bar box.
  RelativeRect positionInTransitionBox(
    GlobalKey key, {
    @required RenderBox from,
  }) {
    final RenderBox componentBox = key.currentContext.findRenderObject();
    assert(componentBox.attached);

    return RelativeRect.fromRect(
      componentBox.localToGlobal(Offset.zero, ancestor: from) & componentBox.size,
      transitionBox,
    );
  }

  // Create a Tween that moves a widget between its original position in its
  // ancestor navigation bar to another widget's position in that widget's
  // navigation bar.
  //
  // Anchor their positions based on the vertical middle of their respective
  // render boxes' leading edge.
  //
  // Also produce RelativeRects with sizes that would preserve the constant
  // BoxConstraints of the 'from' widget so that animating font sizes etc don't
  // produce rounding error artifacts with a linearly resizing rect.
  RelativeRectTween slideFromLeadingEdge({
    @required GlobalKey fromKey,
    @required RenderBox fromNavBarBox,
    @required GlobalKey toKey,
    @required RenderBox toNavBarBox,
  }) {
    final RelativeRect fromRect = positionInTransitionBox(fromKey, from: fromNavBarBox);

    final RenderBox fromBox = fromKey.currentContext.findRenderObject();
    final RenderBox toBox = toKey.currentContext.findRenderObject();

    // We move a box with the size of the 'from' render object such that its
    // upper left corner is at the upper left corner of the 'to' render object.
    // With slight y axis adjustment for those render objects' height differences.
    Rect toRect = toBox
            .localToGlobal(
              Offset.zero,
              ancestor: toNavBarBox,
            )
            .translate(
              0.0,
              -fromBox.size.height / 2 + toBox.size.height / 2,
            ) &
        fromBox.size; // Keep the from render object's size.

    if (forwardDirection < 0) {
      // If RTL, move the center right to the center right instead of matching
      // the center lefts.
      toRect = toRect.translate(-fromBox.size.width + toBox.size.width, 0.0);
    }

    return RelativeRectTween(
      begin: fromRect,
      end: RelativeRect.fromRect(toRect, transitionBox),
    );
  }

  Animation<double> fadeInFrom(double t, {Curve curve = Curves.easeIn}) {
    return animation.drive(fadeIn.chain(
      CurveTween(curve: Interval(t, 1.0, curve: curve)),
    ));
  }

  Animation<double> fadeOutBy(double t, {Curve curve = Curves.easeOut}) {
    return animation.drive(fadeOut.chain(
      CurveTween(curve: Interval(0.0, t, curve: curve)),
    ));
  }

  Widget get bottomLeading {
    final KeyedSubtree bottomLeading = bottomComponents.leadingKey.currentWidget;

    if (bottomLeading == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.leadingKey, from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.4),
        child: bottomLeading.child,
      ),
    );
  }

  Widget get bottomBackChevron {
    final KeyedSubtree bottomBackChevron = bottomComponents.backChevronKey.currentWidget;

    if (bottomBackChevron == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.backChevronKey, from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.6),
        child: DefaultTextStyle(
          style: bottomBackButtonTextStyle,
          child: bottomBackChevron.child,
        ),
      ),
    );
  }

  Widget get bottomBackLabel {
    final KeyedSubtree bottomBackLabel = bottomComponents.backLabelKey.currentWidget;

    if (bottomBackLabel == null) {
      return null;
    }

    final RelativeRect from = positionInTransitionBox(bottomComponents.backLabelKey, from: bottomNavBarBox);

    // Transition away by sliding horizontally to the leading edge off of the screen.
    final RelativeRectTween positionTween = RelativeRectTween(
      begin: from,
      end: from.shift(
        Offset(
          forwardDirection * (-bottomNavBarBox.size.width / 2.0),
          0.0,
        ),
      ),
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeOutBy(0.2),
        child: DefaultTextStyle(
          style: bottomBackButtonTextStyle,
          child: bottomBackLabel.child,
        ),
      ),
    );
  }

  Widget get bottomMiddle {
    final KeyedSubtree bottomMiddle = bottomComponents.middleKey.currentWidget;
    final KeyedSubtree topBackLabel = topComponents.backLabelKey.currentWidget;
    final KeyedSubtree topLeading = topComponents.leadingKey.currentWidget;

    // The middle component is non-null when the nav bar is a large title
    // nav bar but would be invisible when expanded, therefore don't show it here.
    if (!bottomHasUserMiddle && bottomLargeExpanded) {
      return null;
    }

    if (bottomMiddle != null && topBackLabel != null) {
      // Move from current position to the top page's back label position.
      return PositionedTransition(
        rect: animation.drive(slideFromLeadingEdge(
          fromKey: bottomComponents.middleKey,
          fromNavBarBox: bottomNavBarBox,
          toKey: topComponents.backLabelKey,
          toNavBarBox: topNavBarBox,
        )),
        child: FadeTransition(
          // A custom middle widget like a segmented control fades away faster.
          opacity: fadeOutBy(bottomHasUserMiddle ? 0.4 : 0.7),
          child: Align(
            // As the text shrinks, make sure it's still anchored to the leading
            // edge of a constantly sized outer box.
            alignment: AlignmentDirectional.centerStart,
            child: DefaultTextStyleTransition(
              style: animation.drive(TextStyleTween(
                begin: bottomTitleTextStyle,
                end: topBackButtonTextStyle,
              )),
              child: bottomMiddle.child,
            ),
          ),
        ),
      );
    }

    // When the top page has a leading widget override (one of the few ways to
    // not have a top back label), don't move the bottom middle widget and just
    // fade.
    if (bottomMiddle != null && topLeading != null) {
      return Positioned.fromRelativeRect(
        rect: positionInTransitionBox(bottomComponents.middleKey, from: bottomNavBarBox),
        child: FadeTransition(
          opacity: fadeOutBy(bottomHasUserMiddle ? 0.4 : 0.7),
          // Keep the font when transitioning into a non-back label leading.
          child: DefaultTextStyle(
            style: bottomTitleTextStyle,
            child: bottomMiddle.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget get bottomLargeTitle {
    final KeyedSubtree bottomLargeTitle = bottomComponents.largeTitleKey.currentWidget;
    final KeyedSubtree topBackLabel = topComponents.backLabelKey.currentWidget;
    final KeyedSubtree topLeading = topComponents.leadingKey.currentWidget;

    if (bottomLargeTitle == null || !bottomLargeExpanded) {
      return null;
    }

    if (bottomLargeTitle != null && topBackLabel != null) {
      // Move from current position to the top page's back label position.
      return PositionedTransition(
        rect: animation.drive(slideFromLeadingEdge(
          fromKey: bottomComponents.largeTitleKey,
          fromNavBarBox: bottomNavBarBox,
          toKey: topComponents.backLabelKey,
          toNavBarBox: topNavBarBox,
        )),
        child: FadeTransition(
          opacity: fadeOutBy(0.6),
          child: Align(
            // As the text shrinks, make sure it's still anchored to the leading
            // edge of a constantly sized outer box.
            alignment: AlignmentDirectional.centerStart,
            child: DefaultTextStyleTransition(
              style: animation.drive(TextStyleTween(
                begin: bottomLargeTitleTextStyle,
                end: topBackButtonTextStyle,
              )),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: bottomLargeTitle.child,
            ),
          ),
        ),
      );
    }

    if (bottomLargeTitle != null && topLeading != null) {
      // Unlike bottom middle, the bottom large title moves when it can't
      // transition to the top back label position.
      final RelativeRect from = positionInTransitionBox(bottomComponents.largeTitleKey, from: bottomNavBarBox);

      final RelativeRectTween positionTween = RelativeRectTween(
        begin: from,
        end: from.shift(
          Offset(
            forwardDirection * bottomNavBarBox.size.width / 4.0,
            0.0,
          ),
        ),
      );

      // Just shift slightly towards the trailing edge instead of moving to the
      // back label position.
      return PositionedTransition(
        rect: animation.drive(positionTween),
        child: FadeTransition(
          opacity: fadeOutBy(0.4),
          // Keep the font when transitioning into a non-back-label leading.
          child: DefaultTextStyle(
            style: bottomLargeTitleTextStyle,
            child: bottomLargeTitle.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget get bottomTrailing {
    final KeyedSubtree bottomTrailing = bottomComponents.trailingKey.currentWidget;

    if (bottomTrailing == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(bottomComponents.trailingKey, from: bottomNavBarBox),
      child: FadeTransition(
        opacity: fadeOutBy(0.6),
        child: bottomTrailing.child,
      ),
    );
  }

  Widget get topLeading {
    final KeyedSubtree topLeading = topComponents.leadingKey.currentWidget;

    if (topLeading == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(topComponents.leadingKey, from: topNavBarBox),
      child: FadeTransition(
        opacity: fadeInFrom(0.6),
        child: topLeading.child,
      ),
    );
  }

  Widget get topBackChevron {
    final KeyedSubtree topBackChevron = topComponents.backChevronKey.currentWidget;
    final KeyedSubtree bottomBackChevron = bottomComponents.backChevronKey.currentWidget;

    if (topBackChevron == null) {
      return null;
    }

    final RelativeRect to = positionInTransitionBox(topComponents.backChevronKey, from: topNavBarBox);
    RelativeRect from = to;

    // If it's the first page with a back chevron, shift in slightly from the
    // right.
    if (bottomBackChevron == null) {
      final RenderBox topBackChevronBox = topComponents.backChevronKey.currentContext.findRenderObject();
      from = to.shift(
        Offset(
          forwardDirection * topBackChevronBox.size.width * 2.0,
          0.0,
        ),
      );
    }

    final RelativeRectTween positionTween = RelativeRectTween(
      begin: from,
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(bottomBackChevron == null ? 0.7 : 0.4),
        child: DefaultTextStyle(
          style: topBackButtonTextStyle,
          child: topBackChevron.child,
        ),
      ),
    );
  }

  Widget get topBackLabel {
    final KeyedSubtree bottomMiddle = bottomComponents.middleKey.currentWidget;
    final KeyedSubtree bottomLargeTitle = bottomComponents.largeTitleKey.currentWidget;
    final KeyedSubtree topBackLabel = topComponents.backLabelKey.currentWidget;

    if (topBackLabel == null) {
      return null;
    }

    final RenderAnimatedOpacity topBackLabelOpacity = topComponents.backLabelKey.currentContext?.ancestorRenderObjectOfType(const TypeMatcher<RenderAnimatedOpacity>());

    Animation<double> midClickOpacity;
    if (topBackLabelOpacity != null && topBackLabelOpacity.opacity.value < 1.0) {
      midClickOpacity = animation.drive(Tween<double>(
        begin: 0.0,
        end: topBackLabelOpacity.opacity.value,
      ));
    }

    // Pick up from an incoming transition from the large title. This is
    // duplicated here from the bottomLargeTitle transition widget because the
    // content text might be different. For instance, if the bottomLargeTitle
    // text is too long, the topBackLabel will say 'Back' instead of the original
    // text.
    if (bottomLargeTitle != null && topBackLabel != null && bottomLargeExpanded) {
      return PositionedTransition(
        rect: animation.drive(slideFromLeadingEdge(
          fromKey: bottomComponents.largeTitleKey,
          fromNavBarBox: bottomNavBarBox,
          toKey: topComponents.backLabelKey,
          toNavBarBox: topNavBarBox,
        )),
        child: FadeTransition(
          opacity: midClickOpacity ?? fadeInFrom(0.4),
          child: DefaultTextStyleTransition(
            style: animation.drive(TextStyleTween(
              begin: bottomLargeTitleTextStyle,
              end: topBackButtonTextStyle,
            )),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: topBackLabel.child,
          ),
        ),
      );
    }

    // The topBackLabel always comes from the large title first if available
    // and expanded instead of middle.
    if (bottomMiddle != null && topBackLabel != null) {
      return PositionedTransition(
        rect: animation.drive(slideFromLeadingEdge(
          fromKey: bottomComponents.middleKey,
          fromNavBarBox: bottomNavBarBox,
          toKey: topComponents.backLabelKey,
          toNavBarBox: topNavBarBox,
        )),
        child: FadeTransition(
          opacity: midClickOpacity ?? fadeInFrom(0.3),
          child: DefaultTextStyleTransition(
            style: animation.drive(TextStyleTween(
              begin: bottomTitleTextStyle,
              end: topBackButtonTextStyle,
            )),
            child: topBackLabel.child,
          ),
        ),
      );
    }

    return null;
  }

  Widget get topMiddle {
    final KeyedSubtree topMiddle = topComponents.middleKey.currentWidget;

    if (topMiddle == null) {
      return null;
    }

    // The middle component is non-null when the nav bar is a large title
    // nav bar but would be invisible when expanded, therefore don't show it here.
    if (!topHasUserMiddle && topLargeExpanded) {
      return null;
    }

    final RelativeRect to = positionInTransitionBox(topComponents.middleKey, from: topNavBarBox);

    // Shift in from the trailing edge of the screen.
    final RelativeRectTween positionTween = RelativeRectTween(
      begin: to.shift(
        Offset(
          forwardDirection * topNavBarBox.size.width / 2.0,
          0.0,
        ),
      ),
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(0.25),
        child: DefaultTextStyle(
          style: topTitleTextStyle,
          child: topMiddle.child,
        ),
      ),
    );
  }

  Widget get topTrailing {
    final KeyedSubtree topTrailing = topComponents.trailingKey.currentWidget;

    if (topTrailing == null) {
      return null;
    }

    return Positioned.fromRelativeRect(
      rect: positionInTransitionBox(topComponents.trailingKey, from: topNavBarBox),
      child: FadeTransition(
        opacity: fadeInFrom(0.4),
        child: topTrailing.child,
      ),
    );
  }

  Widget get topLargeTitle {
    final KeyedSubtree topLargeTitle = topComponents.largeTitleKey.currentWidget;

    if (topLargeTitle == null || !topLargeExpanded) {
      return null;
    }

    final RelativeRect to = positionInTransitionBox(topComponents.largeTitleKey, from: topNavBarBox);

    // Shift in from the trailing edge of the screen.
    final RelativeRectTween positionTween = RelativeRectTween(
      begin: to.shift(
        Offset(
          forwardDirection * topNavBarBox.size.width,
          0.0,
        ),
      ),
      end: to,
    );

    return PositionedTransition(
      rect: animation.drive(positionTween),
      child: FadeTransition(
        opacity: fadeInFrom(0.3),
        child: DefaultTextStyle(
          style: topLargeTitleTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          child: topLargeTitle.child,
        ),
      ),
    );
  }
}

Widget _wrapWithBackground({
  Border border,
  Color backgroundColor,
  Widget child,
  bool updateSystemUiOverlay = true,
}) {
  Widget result = child;
  if (updateSystemUiOverlay) {
    final bool darkBackground = backgroundColor.computeLuminance() < 0.179;
    final SystemUiOverlayStyle overlayStyle = darkBackground ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    result = AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      sized: true,
      child: result,
    );
  }
  final DecoratedBox childWithBackground = DecoratedBox(
    decoration: BoxDecoration(
      border: border,
      color: backgroundColor,
    ),
    child: result,
  );

  if (backgroundColor.alpha == 0xFF) return childWithBackground;

  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: childWithBackground,
    ),
  );
}

Widget _wrapActiveColor(Color color, BuildContext context, Widget child) {
  if (color == null) {
    return child;
  }

  return CupertinoTheme(
    data: CupertinoTheme.of(context).copyWith(primaryColor: color),
    child: child,
  );
}

// Whether the current route supports nav bar hero transitions from or to.
bool _isTransitionable(BuildContext context) {
  final ModalRoute<dynamic> route = ModalRoute.of(context);

  // Fullscreen dialogs never transitions their nav bar with other push-style
  // pages' nav bars or with other fullscreen dialog pages on the way in or on
  // the way out.
  return route is PageRoute && !route.fullscreenDialog;
}

CreateRectTween _linearTranslateWithLargestRectSizeTween = (Rect begin, Rect end) {
  final Size largestSize = Size(
    math.max(begin.size.width, end.size.width),
    math.max(begin.size.height, end.size.height),
  );
  return RectTween(
    begin: begin.topLeft & largestSize,
    end: end.topLeft & largestSize,
  );
};

final HeroPlaceholderBuilder _navBarHeroLaunchPadBuilder = (
  BuildContext context,
  Size heroSize,
  Widget child,
) {
  assert(child is _TransitionableNavigationBar);
  // Tree reshaping is fine here because the Heroes' child is always a
  // _TransitionableNavigationBar which has a GlobalKey.

  // Keeping the Hero subtree here is needed (instead of just swapping out the
  // anchor nav bars for fixed size boxes during flights) because the nav bar
  // and their specific component children may serve as anchor points again if
  // another mid-transition flight diversion is triggered.

  // This is ok performance-wise because static nav bars are generally cheap to
  // build and layout but expensive to GPU render (due to clips and blurs) which
  // we're skipping here.
  return Visibility(
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    visible: false,
    child: child,
  );
};

final HeroFlightShuttleBuilder _navBarHeroFlightShuttleBuilder = (
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  assert(animation != null);
  assert(flightDirection != null);
  assert(fromHeroContext != null);
  assert(toHeroContext != null);
  assert(fromHeroContext.widget is Hero);
  assert(toHeroContext.widget is Hero);

  final Hero fromHeroWidget = fromHeroContext.widget;
  final Hero toHeroWidget = toHeroContext.widget;

  assert(fromHeroWidget.child is _TransitionableNavigationBar);
  assert(toHeroWidget.child is _TransitionableNavigationBar);

  final _TransitionableNavigationBar fromNavBar = fromHeroWidget.child;
  final _TransitionableNavigationBar toNavBar = toHeroWidget.child;

  assert(fromNavBar.componentsKeys != null);
  assert(toNavBar.componentsKeys != null);

  assert(
    fromNavBar.componentsKeys.navBarBoxKey.currentContext.owner != null,
    'The from nav bar to Hero must have been mounted in the previous frame',
  );
  assert(
    toNavBar.componentsKeys.navBarBoxKey.currentContext.owner != null,
    'The to nav bar to Hero must have been mounted in the previous frame',
  );

  switch (flightDirection) {
    case HeroFlightDirection.push:
      return _NavigationBarTransition(
        animation: animation,
        bottomNavBar: fromNavBar,
        topNavBar: toNavBar,
      );
      break;
    case HeroFlightDirection.pop:
      return _NavigationBarTransition(
        animation: animation,
        bottomNavBar: toNavBar,
        topNavBar: fromNavBar,
      );
  }
  return null;
};
