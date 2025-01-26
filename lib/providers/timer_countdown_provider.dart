import 'dart:async';

import 'package:flutter/material.dart';

class TimerCountdownProvider extends ChangeNotifier {
  int? _totalTimerSeconds;
  bool _isTimerRunning = false;
  Timer? _countdownTimer;
  Duration _myDuration = const Duration(seconds: 0);
  VoidCallback? _timerEndCallback;

  Duration get myDuration => _myDuration;

  setTotalTimerSeconds(int newDuration) {
    _totalTimerSeconds = newDuration;
  }

  setTimerEndCallback(VoidCallback callback) {
    _timerEndCallback = callback;
  }

  void startTimer() {
    _myDuration = Duration(seconds: _totalTimerSeconds ?? 0);
    _countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
    _isTimerRunning = true;
  }

  void stopTimer() {
    _countdownTimer?.cancel();
    _isTimerRunning = false;

    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    _myDuration = Duration(seconds: _totalTimerSeconds ?? 0);

    notifyListeners();
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      resetTimer();
      _timerEndCallback!.call();
    } else {
      _myDuration = Duration(seconds: seconds);
    }

    notifyListeners();
  }

  void invokeCountdownTimer() {
    if (!_isTimerRunning) {
      startTimer();
    }
  }

  // !!! --------------- RESET TIMER-COUNTDOWN-PROVIDER PROVIDER --------------- !!! //
  void resetTimerProvider() {
    stopTimer();

    notifyListeners();
  }
}
