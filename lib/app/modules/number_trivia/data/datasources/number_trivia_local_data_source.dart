import 'dart:convert';

import 'package:flutter_tdd_architecture/app/core/error/exceptions.dart';
import 'package:flutter_tdd_architecture/app/core/values/app_values.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia({required NumberTriviaModel triviaToCache});
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString('CACHED_NUMBER_TRIVIA');
    if (jsonString != null) {
      return Future.value(
          (NumberTriviaModel.fromJson(json.decode(jsonString))));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia({required NumberTriviaModel triviaToCache}) {
    return sharedPreferences.setString(
        AppValues.CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }
}
