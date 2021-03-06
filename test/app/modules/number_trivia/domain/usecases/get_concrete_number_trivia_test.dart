import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/domain_repositories/number_trivia_repositories.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

// class MockNumberTriviaRepository extends Mock implements NumberTriviaRepositories{
// }

@GenerateMocks([NumberTriviaRepositories])
void main(){
   late GetConcreteNumberTrivia usecase;
   late MockNumberTriviaRepositories mockNumberTriviaRepository;
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepositories();
    usecase = GetConcreteNumberTrivia(repositories: mockNumberTriviaRepository);
  });
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1,text: "test");
  test('should get trivia for the number from the repository', () async{
    //arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer((_)async =>
    const Right(tNumberTrivia));
    //act
    final result = await usecase(params: const Params(number: tNumber));
    //assert
    expect(result,const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}