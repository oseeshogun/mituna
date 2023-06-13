import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/src/enums/all.dart';
import 'package:mituna/src/providers/user.dart';

import 'oreal_painter.dart';
import 'text/title_level_two.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    this.onPressed,
  });

  final QuestionCategory category;
  final void Function(List<String>?)? onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(userDataProvider).when(
              loading: () => Container(),
              error: (error, stackTrace) => Container(),
              data: (user) {
                return TextButton(
                  onPressed: () => onPressed?.call(user?.goodResponses),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomPaint(
                        painter: OreolPainter(),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(category.asset),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 100,
                          width: 100,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextTitleLevelTwo(category.title),
                    ],
                  ),
                );
              },
            );
      },
    );
  }
}
