import 'dart:async';


class TimerService {
  Timer _timer;
  int _totalTime;

  bool isRunning = false;
  Function(int) _onCallBackFunction;

  TimerService(int totalTime, void onData(int second)) {
    this._totalTime = totalTime;
    this._onCallBackFunction = onData;
  }

  void _onTick(Timer timer) {
    // print("uprace_app _onTick");
    if (this._onCallBackFunction != null) {
      _totalTime++;
      this._onCallBackFunction(_totalTime);
    }
  }

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    isRunning = true;
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    isRunning = false;
  }

  void reset() {
    stop();
    isRunning = false;
  }

  void close() {
    stop();
    _onCallBackFunction = null;
  }
}
