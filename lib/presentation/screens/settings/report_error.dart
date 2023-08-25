import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/domain/usecases/gsheet.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

class ReportErrorScreen extends HookConsumerWidget {
  ReportErrorScreen({super.key});

  static const String route = '/report_error';

  final formKey = GlobalKey<FormBuilderState>();

  final gsheetUsecase = GsheetUsecase();

  final OutlineInputBorder textFormFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: Colors.white54),
  );

  final hintStyle = const TextStyle(color: Colors.white38);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);
    final reported = useState(false);

    const appBar = PrimaryAppBar(
      title: TextTitleLevelOne('Rapporter une erreur'),
    );

    submit() async {
      if (formKey.currentState?.saveAndValidate() != true) return;
      loading.value = true;
      final firestoreUser = await ref.read(firestoreAuthenticatedUserStreamProvider.future);
      gsheetUsecase
          .addFeedback(
        uid: firestoreUser?.uid,
        name: firestoreUser?.displayName,
        subject: formKey.currentState!.value['subject'],
        message: formKey.currentState!.value['report'],
      )
          .then((result) {
        result.fold((l) {
          showOkAlertDialog(context: context, title: l.message);
        }, (r) {
          reported.value = true;
        });
        loading.value = false;
      });
    }

    if (reported.value) {
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
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Sujet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'subject',
                  decoration: InputDecoration(
                    border: textFormFieldBorder,
                    enabledBorder: textFormFieldBorder,
                    hintStyle: hintStyle,
                    hintText: 'Donnez une titre à votre rapport',
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
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
                FormBuilderTextField(
                  name: 'report',
                  decoration: InputDecoration(
                    border: textFormFieldBorder,
                    enabledBorder: textFormFieldBorder,
                    hintStyle: hintStyle,
                    hintText: 'Décrivez l’erreur que vous avez aperçu dans l’application.',
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ce champ est obligatoire';
                    } else if (value.length < 20) {
                      return 'Votre rapport est très peu descriptif';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                Visibility(
                  visible: !loading.value,
                  replacement: const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: CircularProgressIndicator(
                        color: AppColors.kColorYellow,
                      ),
                    ),
                  ),
                  child: PrimaryButton(
                    child: const TextTitleLevelOne(
                      'Envoyer',
                      color: AppColors.kColorBlack,
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
