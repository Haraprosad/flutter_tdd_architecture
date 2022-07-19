import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_architecture/app/core/error/failures.dart';
import 'package:flutter_tdd_architecture/app/core/usecases/usecase.dart';
import 'package:flutter_tdd_architecture/app/core/util/input_converter.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/usecases/get_random_number_trivia.dart';

import '../../domain/usecases/get_concrete_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(NumberTriviaInitialState()) {
    on<GetConcreteNumberTriviaEvent>(_getConcreteNumberTriviaEvent);
    on<GetRandomNumberTriviaEvent>(_getRandomNumberTriviaEvent);
  }

  void _getConcreteNumberTriviaEvent(
    GetConcreteNumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);
    inputEither.fold((failure) {
      emit(
          const NumberTriviaErrorState(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (integer) async {
      emit(NumberTriviaLoadingState());
      final failureOrTrivia =
          await getConcreteNumberTrivia(params: Params(number: integer));
      failureOrTrivia.fold(
        (failure) => emit(
            NumberTriviaErrorState(message: _mapFailureToMessage(failure))),
        (trivia) => emit(NumberTriviaLoadedState(numberTrivia: trivia)),
      );
    });
    //emit(const NumberTriviaErrorState(message: "message"));
  }

  //for random number event
    void _getRandomNumberTriviaEvent(
    GetRandomNumberTriviaEvent event,
    Emitter<NumberTriviaState> emit,
  ) async {
      emit(NumberTriviaLoadingState());
      final failureOrTrivia =
          await getRandomNumberTrivia(params: NoParams());
      failureOrTrivia.fold(
        (failure) => emit(
            NumberTriviaErrorState(message: _mapFailureToMessage(failure))),
        (trivia) => emit(NumberTriviaLoadedState(numberTrivia: trivia)),
      );
  }

  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
