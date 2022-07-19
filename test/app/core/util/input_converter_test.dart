import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_architecture/app/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {
    test('should return an int when the string represents the unsigned integer',
        () {
      //arrange
      const str = '123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, const Right(123));
    });

    test('should return a failure when the string is not an integer', (){
      //arrange
      const str = 'abc';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result,Left(InvalidInputFailure()));
    });

     test('should return a failure when the string is a negative integer', (){
      //arrange
      const str = '-123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result,Left(InvalidInputFailure()));
    });
  });
}
