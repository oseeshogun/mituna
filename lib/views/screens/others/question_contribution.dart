import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/src/http/repositories/all.dart';
import 'package:mituna/views/widgets/all.dart';

class QuestionContribution extends StatefulWidget {
  const QuestionContribution({super.key});

  static const String route = '/q_contributions';

  @override
  State<QuestionContribution> createState() => _QuestionContributionState();
}

class _QuestionContributionState extends State<QuestionContribution> {
  final formKey = GlobalKey<FormState>();

  final OutlineInputBorder textFormFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.white54),
  );

  final hintStyle = const TextStyle(color: Colors.white38);

  String response = '';
  String question = '';

  bool loading = false;
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    const appBar = PrimaryAppBar(
      title: TextTitleLevelOne('Votre question'),
    );

    Future<void> submit() async {
      debugPrint(formKey.currentState?.validate().toString());
      if (formKey.currentState?.validate() != true) return;
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      try {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid == null) {
          throw Exception("No active user");
        }
        await locator.get<GheetRepository>().sendQuestionContribution(uid, response, question);
      } catch (err) {
        debugPrint(err.toString());
      }
      if (mounted) {
        setState(() {
          submitted = true;
        });
      }
    }

    if (submitted) {
      return Scaffold(
        body: Center(
          child: Lottie.asset(
            'assets/lottiefiles/OTeln9ILf8.json',
            onLoaded: (composition) {
              Future.delayed(
                Duration(
                  milliseconds: composition.duration.inMilliseconds - 500,
                ),
                () => Navigator.of(context).pop(),
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top - appBar.preferredSize.height,
          padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const TextDescription('Vous avez une question que vous voulez partager ? Contribuez à Mituna avec votre merveilleuse question.'),
                const SizedBox(height: 30),
                const Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: textFormFieldBorder,
                    enabledBorder: textFormFieldBorder,
                    hintStyle: hintStyle,
                    hintText: 'Quelle question voulez-vous ajouter à Mituna ?',
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ce champ est obligatoire';
                    } else if (value.length < 20) {
                      return 'Votre question est très peu descriptif';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {
                    question = value;
                  }),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Réponse',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: textFormFieldBorder,
                    enabledBorder: textFormFieldBorder,
                    hintStyle: hintStyle,
                    hintText: 'La réponse à votre question',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() {
                    response = value;
                  }),
                ),
                const Spacer(),
                Visibility(
                  visible: !loading,
                  replacement: const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: CircularProgressIndicator(
                        color: kColorYellow,
                      ),
                    ),
                  ),
                  child: PrimaryButton(
                    child: const TextTitleLevelOne(
                      'Envoyer',
                      color: kColorBlack,
                    ),
                    onPressed: () => submit(),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
