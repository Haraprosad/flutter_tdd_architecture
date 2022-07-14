import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource{
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia({required NumberTriviaModel triviaToCache});
}