import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/weight.dart';
import '../repositories/weight_repositorie.dart';

class DeleteWeight {
  final WeightRepository repository;

  DeleteWeight(this.repository);

  Future<Either<Failures, Unit>> call(String id) async {
    return await repository.deleteWeight(id);
  }
}
