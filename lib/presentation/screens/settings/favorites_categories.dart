import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mituna/core/constants/enums/all.dart';
import 'package:mituna/core/presentation/theme/colors.dart';
import 'package:mituna/core/presentation/theme/sizes.dart';
import 'package:mituna/presentation/widgets/all.dart';
import 'package:mituna/presentation/widgets/texts/all.dart';

class FavoritesCategories extends HookConsumerWidget {
  static const route = '/favorites_categories';

  const FavoritesCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final states = useState<Map<String, bool?>>({});

    return Scaffold(
      appBar: PrimaryAppBar(
        title: TextTitleLevelTwo('Vos catégories favorites'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.kScaffoldHorizontalPadding),
          child: ListView.builder(
            itemCount: QuestionCategory.values.length,
            itemBuilder: (context, index) {
              final category = QuestionCategory.values[index];

              return CheckboxListTile(
                value: states.value[category.name] ??  category.isFavorite,
                title: Text(
                  category.title,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                fillColor: WidgetStatePropertyAll(AppColors.kColorBlueRibbon),
                checkColor: AppColors.kColorYellow,
                onChanged: (value) {
                  category.isFavorite = value ?? category.isFavorite;
                  states.value = {...states.value, category.name: value};
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
