import 'package:dartz/dartz.dart';

import '../../ domain/entities/weight.dart';
import '../../ domain/repositories/weight_repositorie.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/weight_remote_data_source.dart';
import '../models/weight_Model.dart';

class WeightRepositoriesImpl implements WeightRepository {
  final WeightRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeightRepositoriesImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failures, Unit>> addWeight(Weight weight) async {
    final WeightModel weightModel =
        WeightModel(id: weight.id, name: weight.name);
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addWeight(weightModel);
        return Right(unit);
      } on OfflineException {
        return Left(OfflineFailures());
      }
    } else {
      return Left(OfflineFailures());
    }
  }

  @override
  Future<Either<Failures, String?>> getAllWeight() async {
    if (await networkInfo.isConnected) {
      try {
        final currentWeight = await remoteDataSource.getWeight();
        if (currentWeight != null) {
          return Right(currentWeight);
        } else {
          return Left(OfflineFailures());
        }
      } on OfflineException {
        return Left(OfflineFailures());
      }
    } else {
      return Left(OfflineFailures());
    }
  }

  @override
  Future<Either<Failures, Unit>> logOutProfile() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logOutProfile();
        return Right(unit);
      } on OfflineException {
        return Left(OfflineFailures());
      }
    } else {
      return Left(OfflineFailures());
    }
  }

  @override
  Future<Either<Failures, Unit>> deleteWeight(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteWeight(id);
        return Right(unit);
      } on OfflineException {
        return Left(OfflineFailures());
      }
    } else {
      return Left(OfflineFailures());
    }
  }
}
