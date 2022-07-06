import 'dart:convert';

import 'package:flutter_tdd_architecture/app/modules/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_architecture/app/modules/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main(){
  late NumberTriviaModel tNumberTriviaModel;
  setUp((){
    tNumberTriviaModel = const NumberTriviaModel(text: 'Test Text', number: 1);
  });
  test('Should be a subclass of of NumberTrivia Entity', (){
    //assert
     expect(tNumberTriviaModel,isA<NumberTrivia>());
  });

  group('fromJson', (){
    //for int
    test('should return a valid model when the json number is an integer', () async{
      //arrange
      final Map<String,dynamic> jsonMap = await json.decode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
    //for double
    test('should return a valid model when the json number is regarded as double', () async{
      //arrange
      final Map<String,dynamic> jsonMap = await json.decode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
  });
  
  group('toJson', (){
    test('should return a json containing proper data', () async{
      //act
      final result = tNumberTriviaModel.toJson();
      //assert
      final expectedMap = {
        "text" : "Test Text",
        "number" : 1,
      };
      expect(result,expectedMap);
    });
  });
}