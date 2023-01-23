import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/weight.dart';
import '../repositories/weight_repositorie.dart';

class LogoutFromProfile {
  final WeightRepository repository;

  LogoutFromProfile(this.repository);

  Future<Either<Failures, Unit>> call() async {
    return await repository.logOutProfile();
  }
}
