part of 'all.dart';

enum QuestionCategory {
  history,
  geography,
  sciences,
  nature,
  gastronomy,
  arts,
  sports,
  programmation,
  otaku,
}

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
      default:
        throw UnimplementedError('Unknown category: $this');
    }
  }
}