import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_architecture/app/core/error/failures.dart';
import 'package:flutter_tdd_architecture/app/core/usecases/usecase.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/domain_repositories/number_trivia_repositories.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia,Params>{
  final NumberTriviaRepositories repositories;
  const GetConcreteNumberTrivia({required this.repositories});

  @override
  Future<Either<Failure,NumberTrivia>> call({required Params params}) async{
      return await repositories.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  final int number;
  const Params({required this.number});
  @override
  List<Object?> get props =>[number];
}