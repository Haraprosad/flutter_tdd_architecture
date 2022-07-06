import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_architecture/app/core/error/failures.dart';
import 'package:flutter_tdd_architecture/app/core/usecases/usecase.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/domain_repositories/number_trivia_repositories.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia,NoParams>{
  final NumberTriviaRepositories repositories;
  const GetRandomNumberTrivia({required this.repositories});
  @override
  Future<Either<Failure, NumberTrivia>> call({required NoParams params}) async{
    return await repositories.getRandomNumberTrivia();
  }
}