import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_architecture/app/core/usecases/usecase.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/domain_repositories/number_trivia_repositories.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

// class MockNumberTriviaRepository extends Mock implements NumberTriviaRepositories{
// }
void main(){
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepositories mockNumberTriviaRepository;
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepositories();
    usecase = GetRandomNumberTrivia(repositories: mockNumberTriviaRepository);
  });
  const tNumberTrivia = NumberTrivia(number: 1,text: "test");
  test('should get trivia from the repository', () async{
    //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_)async =>
    const Right(tNumberTrivia));
    //act
    final result = await usecase(params:NoParams());
    //assert
    expect(result,const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}