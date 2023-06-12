import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/contants/colors.dart';
import 'package:mituna/contants/sizes.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/src/http/repositories/all.dart';
import 'package:mituna/views/widgets/all.dart';

class ClaimPrice extends StatefulWidget {
  const ClaimPrice({super.key});

  @override
  State<ClaimPrice> createState() => _ClaimPriceState();
}

class _ClaimPriceState extends State<ClaimPrice> {
  String phone = '';
  bool submitted = false;
  bool loading = false;

  late ConfettiController _controllerTopCenter;

  @override
  void initState() {
    super.initState();
    _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  void submitPhoneNumber(BuildContext context) {
    showTextInputDialog(
      context: context,
      title: 'Numéro Béneficiaire',
      okLabel: 'Confirmer',
      cancelLabel: 'Annuler',
      textFields: [
        DialogTextField(
          hintText: '822222222',
          initialText: phone,
          keyboardType: TextInputType.number,
          prefixText: '+243',
        ),
      ],
    ).then((inputs) {
      if (inputs == null) return;
      if (inputs.isEmpty) return;
      final input = inputs[0];
      if (mounted) {
        setState(() => (phone = input));
      }
    });
  }

  void sendPrice(BuildContext context) {
    setState(() => (loading = true));
    locator.get<GheetRepository>().setUserWinner('+243$phone').then((value) {
      _controllerTopCenter.play();
      setState(() => (submitted = true));
    }).catchError((err) {
      debugPrint(err.toString());
      showAlertDialog(
        context: context,
        title: "Oops",
        message: "Une erreur est survenue, veuillez réessayer.\nSi le problème persiste, contactez le développeur.",
      ).then((value) {
        debugPrint(value.toString());
      });
    }).whenComplete(() {
      setState(() => (loading = false));
    });
  }

  @override
  Widget build(BuildContext context) {
    const appBar = PrimaryAppBar(
      title: TextTitleLevelOne('Votre Prix'),
    );

    return Scaffold(
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - appBar.preferredSize.height - 30,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kScaffoldHorizontalPadding),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/lottiefiles/677-trophy.json',
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    const SizedBox(height: 20.0),
                    const TextTitleLevelTwo(
                      'Félicitation, vous avez gagné 300 unités du réseau de votre choix.',
                      textAlign: TextAlign.center,
                    ),
                    ...(submitted
                        ? [
                            const SizedBox(height: 20.0),
                            const TextDescription(
                              'Vous allez recevoir votre prix bientôt. Le processus peut prendre jusqu\'à 24h',
                              textAlign: TextAlign.center,
                            ),
                          ]
                        : buildSubmitPhoneNumber(context)),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerTopCenter,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 1,
            ),
          ),
        ],
      ),
    );
  }

  buildSubmitPhoneNumber(BuildContext context) {
    return [
      const SizedBox(height: 20.0),
      const TextDescription(
        'Mettez le numéro où vous voulez recevoir votre crédit',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20.0),
      SizedBox(
        width: double.infinity,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 15.0),
            ),
          ),
          child: const Text(
            'Numéro Béneficiaire',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          onPressed: () => submitPhoneNumber(context),
        ),
      ),
      if (phone.isNotEmpty) ...[
        const Spacer(),
        TextDescription(
          'Envoie de 300 unités au +243$phone',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30.0),
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
            child: const TextTitleLevelTwo(
              'Envoyez mon prix',
              color: kColorBlueRibbon,
            ),
            onPressed: () => sendPrice(context),
          ),
        ),
        const SizedBox(height: 30.0),
      ]
    ];
  }
}
