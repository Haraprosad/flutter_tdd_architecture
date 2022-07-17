import 'dart:convert';

import 'package:flutter_tdd_architecture/app/core/error/exceptions.dart';
import 'package:flutter_tdd_architecture/app/core/values/app_values.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

// class MockSharedPreferences extends Mock implements SharedPreferences{
// }
@GenerateMocks([SharedPreferences])
void main(){
  late NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences
    );
  });

  group('getLastNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return NumberTrivia from SharedPreferences when there is one in the cache', () async{
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));
      //act
      final result = await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
      //assert
      verify(mockSharedPreferences.getString(AppValues.CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return CacheException when the SharedPreference return null value', (){
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;
      //assert
      expect(()=>call(),throwsA(const TypeMatcher<CacheException>()));
    });

  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
    NumberTriviaModel(number: 1, text: 'test trivia');
    Future<void> tValue(){
      return mockSharedPreferences.setString(AppValues.CACHED_NUMBER_TRIVIA, json.encode(tNumberTriviaModel.toJson()));
    }

    test('should call SharedPreferences to cache the data', () {
      //arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      // act
      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(triviaToCache: tNumberTriviaModel);
      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        AppValues.CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });
}