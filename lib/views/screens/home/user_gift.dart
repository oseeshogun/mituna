import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mituna/src/models/all.dart';
import 'package:mituna/src/services/ads.dart';
import 'package:mituna/views/widgets/all.dart';

class UserGift extends StatefulWidget {
  const UserGift(this.user, {super.key});

  final UserObject user;

  @override
  State<UserGift> createState() => _UserGiftState();
}

class _UserGiftState extends State<UserGift> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  void loadAd() {
    RewardedAd.load(
      adUnitId: AdHelper.giftAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                ad.dispose();
                loadAd();
              },

              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void giveReward() {
    _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      debugPrint("Price ==============> ${rewardItem.amount}"); // Reward the user for watching an ad.
      widget.user.incrementTopaz(rewardItem.amount.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: GestureDetector(
        onTap: () => giveReward(),
        child: GiftAnimation(
          child: Image.asset(
            'assets/icons/icons8-gift-50.png',
            height: 35.0,
            width: 35.0,
          ),
        ),
      ),
    );
  }
}
