import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_architecture/app/core/error/exceptions.dart';
import 'package:flutter_tdd_architecture/app/core/error/failures.dart';
import 'package:flutter_tdd_architecture/app/core/platform/network_info.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/data_repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

// class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{}
@GenerateMocks([NumberTriviaRemoteDataSource])
// class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{}
@GenerateMocks([NumberTriviaLocalDataSource])
// class MockNetworkInfo extends Mock implements NetworkInfo{}
@GenerateMocks([NetworkInfo])

void main(){
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource : mockRemoteDataSource,
      localDataSource : mockLocalDataSource,
      networkInfo : mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', (){
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(text: "test trivia", number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if the device is online', () async{
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repositoryImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async=> true);
      });
      test('should return remote data when the call to remote data source is successful', () async{
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async =>tNumberTriviaModel);
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test('should cache the data locally when the call to remote data source is successful', () async{
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((_) async =>tNumberTriviaModel);
        //act
        await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(triviaToCache: tNumberTriviaModel));
      });

      test('should return Server Failure when the call to remote data source is failed', () async{
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });

    });

    group('device is offline', (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async=> false);
      });
      test('should return last locally cached data when the cached data is present', ()async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async=> tNumberTriviaModel);
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result,equals(const Right(tNumberTrivia)));
      });

      test('should return cache failure when no cache data is present', ()async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result,equals(Left(CacheFailure())));
      });
    });

  });

}
