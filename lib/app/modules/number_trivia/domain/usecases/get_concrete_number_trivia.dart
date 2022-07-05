import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_architecture/app/core/error/failures.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/domain_repositories/number_trivia_repositories.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';

class GetConcreteNumberTrivia{
  final NumberTriviaRepositories repositories;
  const GetConcreteNumberTrivia({required this.repositories});

  Future<Either<Failure,NumberTrivia>> call({required int number}) async{
      return await repositories.getConcreteNumberTrivia(number);
  }
}