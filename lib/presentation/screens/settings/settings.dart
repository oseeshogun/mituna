import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/domain/usecases/user.dart';
import 'package:mituna/presentation/screens/auth/authentication.dart';
import 'package:mituna/presentation/utils/file_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

import 'report_error.dart';

class SettingsScreen extends HookConsumerWidget {
  SettingsScreen({super.key});

  final picker = ImagePicker();
  final userUsecase = UserUsecase();
  static const route = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuthUserAsyncValue = ref.watch(firebaseAuthUserStreamProvider);
    final firestoreAuthUserAsyncValue = ref.watch(firestoreAuthenticatedUserStreamProvider);

    Future<void> updateAvatar(ValueNotifier<bool> loading) async {
      final source = await selectPickImageSource(context);
      if (source == null) return;
      final XFile? xFileImage = await picker.pickImage(source: source);
      if (xFileImage == null) return;
      loading.value = true;
      userUsecase.updateUserAvatar(xFileImage.path).then((result) {
        result.fold((l) {
          showOkAlertDialog(context: context, title: l.message);
        }, (r) => null);
        loading.value = false;
      });
    }

    return Scaffold(
      appBar: PrimaryAppBar(
        title: const TextTitleLevelOne('Paramètres'),
        actions: [
          IconButton(
            tooltip: 'Réjoignez-nous sur Discord',
            onPressed: () => launchUrl(Uri.parse('https://discord.gg/TSqVPtaQ4A')),
            icon: const Icon(Icons.discord),
          ),
          firebaseAuthUserAsyncValue.when(
            loading: () => Container(),
            error: (error, stackTrace) => Container(),
            data: (firebaseUser) {
              if (firebaseUser?.isAnonymous == true) {
                return IconButton(
                  onPressed: () => Navigator.of(context).pushNamed(AuthenticationScreen.route),
                  icon: const Icon(
                    CupertinoIcons.person_crop_circle,
                    size: 30,
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            firestoreAuthUserAsyncValue.when(
              loading: () => SizedBox(),
              error: (error, stackTrace) => SizedBox(),
              data: (firestoreUser) => UserAvatar(
                avatar: firestoreUser?.avatar ?? '',
                onUpdateImage: (loading) => updateAvatar(loading),
              ),
            ),
            const SizedBox(height: 10.0),
            firestoreAuthUserAsyncValue.when(
              loading: () => SizedBox(),
              error: (error, stackTrace) => SizedBox(),
              data: (firestoreUser) => TextTitleLevelOne(firestoreUser?.displayName ?? ''),
            ),
            const SizedBox(height: 30.0),
            SettingTile(
              leading: const Icon(
                CupertinoIcons.person_fill,
                color: Colors.white,
              ),
              title: "Nom d'utilisateur",
              subtitle: "Changer votre nom d'utilisateur",
              onTap: () {},
            ),
            const SizedBox(height: 10.0),
            SettingTile(
              leading: const Icon(
                CupertinoIcons.flag_fill,
                color: Colors.white,
              ),
              title: 'Rapporter une erreur',
              subtitle: 'Une réponse n’est pas correcte ? un bug ?',
              onTap: () => Navigator.of(context).pushNamed(ReportErrorScreen.route),
            ),
          ],
        ),
      ),
    );
  }
}
