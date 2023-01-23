import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/weight.dart';
import '../repositories/weight_repositorie.dart';

class AddWeight {
  final WeightRepository repository;

  AddWeight(this.repository);

  Future<Either<Failures, Unit>> call(Weight weight) async {
    return await repository.addWeight(weight);
  }
}
