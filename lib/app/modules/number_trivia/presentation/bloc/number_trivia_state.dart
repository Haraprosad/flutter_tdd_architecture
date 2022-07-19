part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaInitialState extends NumberTriviaState {}

class NumberTriviaLoadingState extends NumberTriviaState {}

class NumberTriviaLoadedState extends NumberTriviaState {
  final NumberTrivia numberTrivia;
  const NumberTriviaLoadedState({required this.numberTrivia});
  @override
  List<Object> get props => [numberTrivia];
}

class NumberTriviaErrorState extends NumberTriviaState {
  final String message;
  const NumberTriviaErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
