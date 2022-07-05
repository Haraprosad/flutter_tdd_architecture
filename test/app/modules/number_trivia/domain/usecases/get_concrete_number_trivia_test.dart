import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/domain_repositories/number_trivia_repositories.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepositories{
}

void main(){
   late GetConcreteNumberTrivia usecase;
   late MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repositories: mockNumberTriviaRepository);
  });
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1,text: "test");
  test('should get trivia for the number from the repository', () async{
    //arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber)).thenAnswer((_)async =>
    const Right(tNumberTrivia));
    //act
    final result = await usecase(number:tNumber);
    //assert
    expect(result,const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}