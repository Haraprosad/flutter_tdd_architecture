import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_architecture/app/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integerValue = int.parse(str);
      if (integerValue < 0) throw const FormatException();
      return Right(integerValue);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
