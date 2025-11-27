part of 'all.dart';

enum QuestionCategory { history, geography, sciences, nature, gastronomy, arts, sports, programmation, otaku, religion }

extension QuestionCategoryAsset on QuestionCategory {
  String get asset => 'assets/images/categories/$name.jpg';

  String get title {
    switch (this) {
      case QuestionCategory.history:
        return 'Histoire';
      case QuestionCategory.geography:
        return 'Géographie';
      case QuestionCategory.sciences:
        return 'Sciences';
      case QuestionCategory.nature:
        return 'Nature';
      case QuestionCategory.gastronomy:
        return 'Gasronomie';
      case QuestionCategory.arts:
        return 'Arts';
      case QuestionCategory.sports:
        return 'Sports';
      case QuestionCategory.programmation:
        return 'Programmation';
      case QuestionCategory.otaku:
        return 'Otaku';
      case QuestionCategory.religion:
        return 'Religion';
    }
  }

  bool get isFavorite {
    final prefs = locator.get<SharedPreferences>();
    return prefs.getBool('favorite_$name') ?? _defaultIsFavorite(this);
  }

  set isFavorite(bool value) {
    final prefs = locator.get<SharedPreferences>();
    prefs.setBool('favorite_$name', value);
  }
}

bool _defaultIsFavorite(QuestionCategory category) {
  return {
    QuestionCategory.history,
    QuestionCategory.geography,
    QuestionCategory.nature,
    QuestionCategory.arts,
    QuestionCategory.sciences,
    QuestionCategory.religion,
  }.contains(category);
}
