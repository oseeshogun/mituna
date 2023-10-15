import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/utils/preferences.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/riverpod/providers/user.dart';
import 'package:mituna/domain/usecases/user.dart';
import 'package:mituna/locator.dart';
import 'package:mituna/presentation/screens/auth/authentication.dart';
import 'package:mituna/presentation/screens/settings/logout_or_delete_account.dart';
import 'package:mituna/presentation/utils/file_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

import 'about_the_app.dart';
import 'donation.dart';
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
    final prefs = locator.get<SharedPreferences>();
    final volume = useState(prefs.volume);

    useEffect(() {
      prefs.volume = volume.value;
      return null;
    }, [volume.value]);

    Future<void> changeUserDisplayName(String displayName) async {
      final inputs = await showTextInputDialog(
        context: context,
        textFields: [
          DialogTextField(
            initialText: displayName,
            hintText: "Nom d'utilisateur",
            maxLength: 9,
            textCapitalization: TextCapitalization.words,
          ),
        ],
      );
      if (inputs == null) return;
      final newDisplayName = inputs.first;
      if (newDisplayName == displayName) return;
      userUsecase.updateDisplayName(newDisplayName);
    }

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
              data: (firestoreUser) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextTitleLevelOne(firestoreUser?.displayName ?? ''),
                  firestoreAuthUserAsyncValue.when(
                    loading: () => SizedBox(),
                    error: (error, stackTrace) => SizedBox(),
                    data: (firestoreUser) => IconButton(
                      icon: const Icon(
                        CupertinoIcons.pencil,
                        size: 14.0,
                        color: Colors.white,
                      ),
                      onPressed: () => changeUserDisplayName(firestoreUser?.displayName ?? ''),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            SettingTile(
              leading: const Icon(
                CupertinoIcons.flag_fill,
                color: Colors.white,
              ),
              title: 'Rapporter une erreur',
              onTap: () => Navigator.of(context).pushNamed(ReportErrorScreen.route),
            ),
            const SizedBox(height: 10.0),
            SoundSlider(
              value: volume.value,
              onChanged: (value) => (volume.value = value),
            ),
            const SizedBox(height: 10.0),
            Builder(builder: (context) {
              return SettingTile(
                leading: const Icon(
                  Icons.code,
                  color: Colors.white,
                ),
                title: 'Code source',
                onLongPress: () async {
                  await Clipboard.setData(ClipboardData(text: 'https://github.com/oseeshogun/mituna'));
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(
                      content: Text('Lien copié'),
                    ),
                  );
                },
                onTap: () => launchUrl(Uri.parse("https://github.com/oseeshogun/mituna"), mode: LaunchMode.externalApplication),
              );
            }),
            const SizedBox(height: 10.0),
            SettingTile(
              leading: const Icon(
                Icons.diversity_1,
                color: Colors.white,
              ),
              title: 'Faire un don',
              onTap: () => Navigator.of(context).pushNamed(Donation.route),
            ),
            const SizedBox(height: 10.0),
            SettingTile(
              leading: const Icon(
                CupertinoIcons.flag_fill,
                color: Colors.white,
              ),
              title: 'A propos',
              onTap: () => Navigator.of(context).pushNamed(AboutTheApp.route),
            ),
            const SizedBox(height: 30.0),
            SettingTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: 'Déconnexion',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LogoutOrDeleteAccount(isDeleteAccount: false))),
            ),
            SettingTile(
              foregroundColor: AppColors.kColorYellow,
              leading: const Icon(CupertinoIcons.trash),
              title: 'Supprimer mon compte',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LogoutOrDeleteAccount(isDeleteAccount: true))),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
