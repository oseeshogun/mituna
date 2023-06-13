import 'package:flutter/material.dart';

class ExtraCategory {
  ExtraCategory({
    required this.name,
    required this.slug,
    this.asset,
    this.icon,
    this.color,
    this.message,
  }) : assert(icon != null || asset != null, "icon & asset can not be both null");

  final IconData? icon;
  final Color? color;
  final String name;
  final String? message;
  final String slug;
  final String? asset;
}

final extraCategories = [
  ExtraCategory(
    name: 'Historique',
    slug: 'history',
    asset: '',
    icon: Icons.history_edu,
    color: Colors.white,
    message: 'Vos bonnes réponses',
  ),
  ExtraCategory(
    name: 'Contribuez',
    slug: 'contribution',
    icon: Icons.app_registration,
    color: Colors.white,
    message: 'Vous avez une question ? Soumettez-là.',
  ),
];
