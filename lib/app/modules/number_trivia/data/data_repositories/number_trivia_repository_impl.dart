import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_architecture/app/core/error/exceptions.dart';

import 'package:flutter_tdd_architecture/app/core/error/failures.dart';
import 'package:flutter_tdd_architecture/app/core/platform/network_info.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';

import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';

import '../../domain/domain_repositories/number_trivia_repositories.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepositories{
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  const NumberTriviaRepositoryImpl({required this.remoteDataSource,required this.localDataSource,
  required this.networkInfo});
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async{
    if(await networkInfo.isConnected){
      try{
        final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(number);
        localDataSource.cacheNumberTrivia(triviaToCache: remoteTrivia);
        return Right(remoteTrivia);
      }on ServerException{
        return Left(ServerFailure());
      }
    }
    else{
      try{
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      }on CacheException{
        return Left(CacheFailure());
      }

    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
  
}