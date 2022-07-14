import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource{
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}