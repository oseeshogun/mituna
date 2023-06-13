import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mituna/src/models/extra_category.dart';
import 'package:mituna/src/providers/user.dart';

import 'oreal_painter.dart';
import 'text/title_level_two.dart';

class ExtraCategoryItem extends StatelessWidget {
  const ExtraCategoryItem({
    super.key,
    required this.category,
    this.onPressed,
  });

  final ExtraCategory category;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(userDataProvider).when(
              loading: () => Container(),
              error: (error, stackTrace) => Container(),
              data: (user) {
                return Tooltip(
                  message: category.message,
                  child: TextButton(
                    onPressed: () => onPressed?.call(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomPaint(
                          painter: OreolPainter(),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            height: 100,
                            width: 100,
                            child: Icon(
                              category.icon,
                              color: category.color,
                              size: 40.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextTitleLevelTwo(category.name),
                      ],
                    ),
                  ),
                );
              },
            );
      },
    );
  }
}
