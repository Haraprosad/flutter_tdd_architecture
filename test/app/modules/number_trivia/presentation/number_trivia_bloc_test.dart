import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_architecture/app/core/util/input_converter.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

// class MockGetConcreteNumberTrivia extends Mock
//     implements GetConcreteNumberTrivia {}

//todo: should use blocTest here
@GenerateMocks([GetConcreteNumberTrivia])

// class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}
@GenerateMocks([GetRandomNumberTrivia])

// class MockInputConverter extends Mock implements InputConverter {}
@GenerateMocks([InputConverter])
void main() {
  late NumberTriviaBloc numberTriviaBloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  group('getTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    test(
        'should call the InputConverter to validate & convert the string into unsigned integer',
        () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
      //act
      numberTriviaBloc
          .add(const GetConcreteNumberTriviaEvent(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });
  });
}
