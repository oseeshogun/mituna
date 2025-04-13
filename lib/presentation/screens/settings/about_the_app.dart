import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mituna/core/constants/developers/developers.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/domain/entities/person_to_be_thankful.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutTheApp extends HookWidget {
  const AboutTheApp({super.key});

  static const route = '/about_the_app';

  bool isMiddlePerson(PersonToBeThankful person) {
    return person != peopleToBeThankful.first && person != peopleToBeThankful.last;
  }

  bool isFirstButThereIsMoreThanOnePerson(PersonToBeThankful person) {
    return person == peopleToBeThankful.first && peopleToBeThankful.length > 1;
  }

  Future<void> contactThankfulPerson(BuildContext context, PersonToBeThankful person) async {
    showBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) {
        return Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  if (person.portfolio != null)
                    ThankfulPersonCoordonate(
                      asset: 'assets/icons/icons8-resume-50.png',
                      title: 'Portfolio',
                      onTap: () {
                        if (person.portfolio == null) return;
                        canLaunchUrlString(person.portfolio!).then((canLaunch) {
                          if (canLaunch) {
                            launchUrlString(person.portfolio!);
                          }
                          Navigator.of(context).pop();
                        }).catchError((err) {
                          debugPrint(err.toString());
                        });
                      },
                    ),
                  ThankfulPersonCoordonate(
                    asset: 'assets/icons/icons8-linkedin-50.png',
                    title: 'Linkedin',
                    onTap: () {
                      canLaunchUrlString(person.linkedin).then((canLaunch) {
                        if (canLaunch) {
                          launchUrlString(person.linkedin, mode: LaunchMode.externalApplication);
                        }
                        Navigator.of(context).pop();
                      }).catchError((err) {
                        debugPrint(err.toString());
                      });
                    },
                  ),
                  if (person.whatsapp != null)
                    ThankfulPersonCoordonate(
                      asset: 'assets/icons/icons8-whatsapp-50.png',
                      title: 'Whastapp',
                      onTap: () {
                        if (person.whatsapp == null) return;
                        canLaunchUrlString(person.whatsapp!).then((canLaunch) {
                          if (canLaunch) {
                            launchUrlString(person.whatsapp!, mode: LaunchMode.externalApplication);
                          }
                          Navigator.of(context).pop();
                        }).catchError((err) {
                          debugPrint(err.toString());
                        });
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final version = useFuture(PackageInfo.fromPlatform());

    return Scaffold(
      appBar: const PrimaryAppBar(
        title: TextTitleLevelOne('A propos'),
      ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                TextTitleLevelTwo('Version ${version.data?.version ?? '...'}'),
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () => launchUrl(Uri.parse('https://mituna.oseemasuaku.com/privacy')),
                  child: const TextTitleLevelTwo('Termes & Conditions d\'utilisation'),
                ),
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => Theme(
                          data: ThemeData(
                            cardColor: AppColors.kColorBlueRibbon,
                            brightness: Brightness.dark,
                          ),
                          child: LicensePage(
                            applicationName: 'Mituna',
                            applicationIcon: Image.asset(
                              'assets/images/mituna_rounded.png',
                              fit: BoxFit.contain,
                            ),
                            applicationVersion: version.data?.version ?? '...',
                          ),
                        ),
                      ),
                    );
                  },
                  child: const TextTitleLevelTwo('Licences'),
                ),
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () => contactThankfulPerson(context, developer),
                  child: const TextTitleLevelTwo('Contactez le développeur'),
                ),
                const SizedBox(height: 30.0),
                InkWell(
                  onTap: () => launchUrlString('https://mituna.oseemasuaku.com', mode: LaunchMode.externalApplication),
                  child: const TextTitleLevelTwo('Visitez le site internet'),
                ),
                const SizedBox(height: 30.0),
                const TextTitleLevelTwo('Rémerciements à:'),
                const SizedBox(height: 10.0),
                Text.rich(
                  TextSpan(
                    text: '',
                    children: peopleToBeThankful.map<TextSpan>((person) {
                      final shouldAddComa = isMiddlePerson(person) || isFirstButThereIsMoreThanOnePerson(person);
                      return TextSpan(
                        text: person.toString() + (shouldAddComa ? ', ' : ' '),
                        recognizer: TapGestureRecognizer()..onTap = () => contactThankfulPerson(context, person),
                      );
                    }).toList(),
                    style: TextStyle(
                      color: Colors.white.withAlpha((0.8 * 255).toInt()),
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
