import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/data/local/db.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

class ArticleScreen extends HookWidget {
  ArticleScreen(this.article, {super.key});

  final LawArticle article;

  final flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    final playing = useState(false);

    useEffect(() {
      final result = flutterTts.isLanguageAvailable("fr");
      result.then((value) {
        if (value == true) flutterTts.setLanguage("fr");
      });
      flutterTts.setCompletionHandler(() {
        if (context.mounted) playing.value = false;
      });
      return () {
        if (context.mounted && playing.value) flutterTts.stop();
      };
    }, []);

    Future<void> read() async {
      if (playing.value) {
        final result = await flutterTts.stop();
        if (result == 1) playing.value = false;
        return;
      }
      final result = await flutterTts.speak(article.value);
      if (result == 1) playing.value = true;
    }

    return Scaffold(
      appBar: PrimaryAppBar(
        title: TextTitleLevelTwo('Article ${article.number}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(
              'assets/images/armoiries.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.kScaffoldHorizontalPadding),
        child: AutoSizeText(
          article.value,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: playing.value
            ? Stack(
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kColorBlueRibbon,
                    ),
                  ),
                  Center(
                    child: const Icon(
                      Icons.stop,
                      color: AppColors.kColorBlueRibbon,
                    ),
                  )
                ],
              )
            : const Icon(
                Icons.volume_up,
                color: AppColors.kColorBlueRibbon,
              ),
        shape: CircleBorder(),
        onPressed: () => read(),
      ),
    );
  }
}
