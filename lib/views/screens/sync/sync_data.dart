import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/src/db/entities/answer.dart';
import 'package:mituna/src/db/entities/question.dart';
import 'package:mituna/src/db/repositories/answer.dart';
import 'package:mituna/src/db/repositories/question.dart';

class SyncData extends StatefulWidget {
  const SyncData({super.key});

  @override
  State<SyncData> createState() => _SyncDataState();
}

class _SyncDataState extends State<SyncData> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<Alignment> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = Tween<Alignment>(begin: Alignment.centerLeft, end: Alignment.centerRight).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
    animationController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final questionRepository = await locator.get<QuestionRepository>();
      final answerRepository = await locator.get<AnswerRepository>();
      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
      animationController.forward();
      rootBundle.loadString('assets/data/questions.json').then((String jsonString) {
        Map<String, dynamic> data = json.decode(jsonString);
        debugPrint("Data ==========================> ${(data['questions'] as List).length}");
        questionRepository.clear();
        answerRepository.clear();
        final answers = (data['questions'] as List).fold(<Map<String, dynamic>>[], (previousValue, question) {
          final ans = (question['answers'] as List).map((answer) => <String, dynamic>{...Map<String, dynamic>.from(answer), "question": question['id']}).toList();
          return [...previousValue, ...ans];
        });
        questionRepository.addAll(Question.fromJsonList(data['questions']));
        answerRepository.addAll(Answer.fromJsonList(answers));
        Future.delayed(const Duration(seconds: 2), () => Navigator.of(context).pop());
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottiefiles/37420-import-contacts.json'),
              const SizedBox(height: 30.0),
              const Text(
                'Veuillez patientez, chargement des questions...',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30.0),
              Container(
                width: MediaQuery.of(context).size.width - kScaffoldHorizontalPadding * 2,
                height: 10,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kColorChambray),
                child: Transform.translate(
                  offset: const Offset(0.0, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.1,
                    alignment: animation.value,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        color: kColorYellow,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 10.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
