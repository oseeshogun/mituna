import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mituna/data/network/entities/question_of_the_day.dart';
import 'package:mituna/data/network/repositories/question_of_the_day.dart';
import 'package:mituna/data/network/services/question_of_the_day.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';

import 'question_of_the_day_test.mocks.dart';

@GenerateMocks([QuestionOfTheDayService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuestionOfTheDayRepository questionOfTheDayRepository;
  final questionOfTheDayService = MockQuestionOfTheDayService();

  setUp(() {
    questionOfTheDayRepository = QuestionOfTheDayRepository(questionOfTheDayService);
  });

  test('Get question of the day', () async {
    when(questionOfTheDayService.getQuestionOfTheDay()).thenAnswer(
      (realInvocation) async => await HttpResponse(
        QuestionOfTheDayData(
          id: 'q1',
          question: 'Le nombre qui suit 3 ?',
          assertions: ['1', '2', '3', '4'],
          date: DateTime.now().toIso8601String(),
          reponse: '4',
        ),
        Response(
          requestOptions: RequestOptions(),
          statusCode: 200,
        ),
      ),
    );

    final result = await questionOfTheDayRepository.getQuestionOfTheDay();

    expect(result.response.statusCode, 200);
    expect(result.data.id, 'q1');
  });
}
