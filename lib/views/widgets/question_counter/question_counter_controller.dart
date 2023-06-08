import 'package:flutter/material.dart';

enum QuestionCounterState { running, paused, stopped }

class QuestionCounterController extends ChangeNotifier {
  QuestionCounterState state = QuestionCounterState.running;

  void pause() {
    if (state == QuestionCounterState.paused) return;
    state = QuestionCounterState.paused;
    notifyListeners();
  }

  void stop() {
    if (state == QuestionCounterState.stopped) return;
    state = QuestionCounterState.stopped;
    notifyListeners();
  }

  void play() {
    if (state == QuestionCounterState.running) return;
    state = QuestionCounterState.running;
    notifyListeners();
  }
}
