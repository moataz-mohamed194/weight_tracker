import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/weight.dart';
import '../repositories/weight_repositorie.dart';

class GetAllWeight {
  final WeightRepository repository;

  GetAllWeight(this.repository);

  Future<Either<Failures, String?>> call() async {
    return await repository.getAllWeight();
  }
}
