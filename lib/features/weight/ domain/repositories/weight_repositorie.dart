import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/weight.dart';

abstract class WeightRepository {
  Future<Either<Failures, String?>> getAllWeight();
  Future<Either<Failures, Unit>> addWeight(Weight weight);
  Future<Either<Failures, Unit>> logOutProfile();
  Future<Either<Failures, Unit>> deleteWeight(String id);
}
