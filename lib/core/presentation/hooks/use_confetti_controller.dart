import 'package:confetti/confetti.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ConfettiController useConfettiController({Duration duration = const Duration(seconds: 5)}) {
  return use(_ConfettiControllerHook(duration: duration));
}

class _ConfettiControllerHook extends Hook<ConfettiController> {
  final Duration duration;

  _ConfettiControllerHook({required this.duration});

  @override
  _ConfettiControllerHookState createState() => _ConfettiControllerHookState();
}

class _ConfettiControllerHookState extends HookState<ConfettiController, _ConfettiControllerHook> {
  late final ConfettiController controller;

  @override
  void initHook() {
    controller = ConfettiController(duration: hook.duration);
  }

  @override
  ConfettiController build(BuildContext context) {
    return controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
