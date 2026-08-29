import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mituna/core/domain/errors/failures.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/domain/usecases/auth/anonyme.dart';
import 'package:mituna/domain/usecases/auth/apple.dart';
import 'package:mituna/domain/usecases/auth/google.dart';
import 'package:mituna/presentation/screens/home/home.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticationScreen extends HookWidget {
  AuthenticationScreen({super.key});

  final signInWithGoogleUsecase = SignInWithGoogleUsecase();
  final signInWithAppleUsecase = SignInWithAppleUsecase();
  final anonymeAuthUsecase = AnonymeAuthentificationUsecase();

  static const String route = '/auth';

  static final Uri _termsUri = Uri.parse('https://mituna.oseemasuaku.com/terms');
  static final Uri _privacyUri = Uri.parse('https://mituna.oseemasuaku.com/privacy');

  void _afterAuthRedirect(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.route, (route) => false);
    }
  }

  Future<void> _signIn(
    BuildContext context,
    ValueNotifier<_AuthProvider?> pending,
    _AuthProvider provider,
    Future<Either<Failure, Object?>> Function() usecase,
  ) async {
    if (pending.value != null) return;
    pending.value = provider;
    final result = await usecase();
    if (!context.mounted) return;
    result.fold(
      (failure) => showOkAlertDialog(context: context, title: 'Connexion échouée', message: failure.message),
      (_) => _afterAuthRedirect(context),
    );
    if (context.mounted) pending.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final pending = useState<_AuthProvider?>(null);

    return Scaffold(
      backgroundColor: AppColors.kColorBlueRibbon,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/mituna_rounded.png', height: 40.0, width: 40.0),
                  const SizedBox(width: 12.0),
                  const Text(
                    'Mituna',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Connectez-vous pour que vos données puissent être sauvegardées',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24.0),
              SvgPicture.asset('assets/svgs/quiz show-rafiki.svg', height: 220.0),
              const SizedBox(height: 32.0),
              _SocialAuthButton(
                iconAsset: 'assets/images/icons/icons8-google-48.png',
                label: 'Continuer avec Google',
                loading: pending.value == _AuthProvider.google,
                enabled: pending.value == null,
                onPressed: () => _signIn(context, pending, _AuthProvider.google, signInWithGoogleUsecase.call),
              ),
              const SizedBox(height: 14.0),
              _SocialAuthButton(
                iconAsset: 'assets/images/icons/icons8-apple-50.png',
                label: 'Continuer avec Apple',
                loading: pending.value == _AuthProvider.apple,
                enabled: pending.value == null,
                onPressed: () => _signIn(context, pending, _AuthProvider.apple, signInWithAppleUsecase.call),
              ),
              const SizedBox(height: 24.0),
              const _OrDivider(),
              const SizedBox(height: 24.0),
              _AnonymousButton(
                loading: pending.value == _AuthProvider.anonymous,
                enabled: pending.value == null,
                onPressed: () => _signIn(context, pending, _AuthProvider.anonymous, anonymeAuthUsecase.call),
              ),
              const SizedBox(height: 24.0),
              _TermsText(onOpenTerms: () => launchUrl(_termsUri), onOpenPrivacy: () => launchUrl(_privacyUri)),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}

enum _AuthProvider { google, apple, anonymous }

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.iconAsset,
    required this.label,
    required this.onPressed,
    required this.loading,
    required this.enabled,
  });

  final String iconAsset;
  final String label;
  final VoidCallback onPressed;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled || loading ? 1.0 : 0.5,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.0),
          onTap: enabled ? onPressed : null,
          child: Ink(
            height: 56.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(color: const Color(0xFFE2E5EC)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(iconAsset, height: 22.0, width: 22.0),
                  ),
                ),
                if (loading)
                  const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0, color: AppColors.kColorChambray),
                  )
                else
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2430),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.white38, thickness: 1.0)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OU',
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: Colors.white70,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white38, thickness: 1.0)),
      ],
    );
  }
}

class _AnonymousButton extends StatelessWidget {
  const _AnonymousButton({
    required this.onPressed,
    required this.loading,
    required this.enabled,
  });

  final VoidCallback onPressed;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled || loading ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.0),
          onTap: enabled ? onPressed : null,
          child: Ink(
            height: 56.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: loading
                  ? const SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
                    )
                  : const Text(
                      'Continuer sans compte',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText({required this.onOpenTerms, required this.onOpenPrivacy});

  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacy;

  @override
  Widget build(BuildContext context) {
    const base = TextStyle(fontFamily: 'Lato', fontSize: 12.0, color: Colors.white70, height: 1.5);
    final link = base.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: Colors.white,
    );

    return Text.rich(
      TextSpan(
        style: base,
        children: [
          const TextSpan(text: 'En continuant, vous acceptez les '),
          TextSpan(
            text: "Conditions d'utilisation",
            style: link,
            recognizer: (TapGestureRecognizer()..onTap = onOpenTerms),
          ),
          const TextSpan(text: ' et la '),
          TextSpan(
            text: 'Politique de confidentialité',
            style: link,
            recognizer: (TapGestureRecognizer()..onTap = onOpenPrivacy),
          ),
          const TextSpan(text: ' de Mituna.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
