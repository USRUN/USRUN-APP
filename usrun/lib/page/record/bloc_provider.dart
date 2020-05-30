import 'dart:async';

import 'package:flutter/material.dart';

Type _typeOf<T>() => T;

abstract class BlocBase {
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final T bloc;

  BlocProvider({Key key, @required this.child, @required this.bloc});

  @override
  BlocProviderState<T> createState() => BlocProviderState();

  static T of<T extends BlocBase>(BuildContext context) {
    BlocProviderInherited<T> provider = context.getElementForInheritedWidgetOfExactType<BlocProviderInherited<T>>().widget;
    return provider?.bloc;
  }
}

class BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new BlocProviderInherited<T>(
      child: widget.child,
      bloc: widget.bloc,
    );
  }
}

class BlocProviderInherited<T extends BlocBase> extends InheritedWidget {
  BlocProviderInherited({Key key, @required Widget child, @required this.bloc})
      : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}

class MyStreamController<T> {

  StreamController<T> _controller;

  T t;

  StreamSubscription _streamSubscription;

  MyStreamController({@required T defaultValue, bool activeBroadcast = false}) {
    if (activeBroadcast) {
      _controller = new StreamController<T>.broadcast();
    } else {
      _controller = new StreamController<T>();
    }
    this.t = defaultValue;
  }

  void listenValueChange() {
    this._streamSubscription = this._controller.stream.listen((value){
      t = value;
    });
  }

  T get value => t;

  Stream<T> get stream => _controller.stream;

  void add(T t) {
    this._controller.sink.add(t);
  }

  close() {
    if (_controller.isClosed) {
      return;
    }
    if (_streamSubscription != null) {
      this._streamSubscription.cancel();
    }
    if (this._controller != null && !this._controller.isClosed) {
      this._controller.close();
    }
  }

}