import 'package:dartz/dartz.dart';
import 'package:the_boring_app/core/connection/network_info.dart';
import 'package:the_boring_app/core/errors/exceptions.dart';
import 'package:the_boring_app/core/errors/failures.dart';
import 'package:the_boring_app/features/random_activity/data/datasources/random_activity_local_data_source.dart';
import 'package:the_boring_app/features/random_activity/data/datasources/random_activity_remote_data_source.dart';
import 'package:the_boring_app/features/random_activity/domain/entities/random_activity.dart';
import 'package:the_boring_app/features/random_activity/domain/repositories/random_activity_repository.dart';

class RandomActivityRepositoryImpl implements RandomActivityRepository {
  final RandomActivityRemoteDataSource remoteDataSource;
  final RandomActivityLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RandomActivityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RandomActivity?>> getRandomActivity() async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteRandomActivity = await remoteDataSource.getRandomActivity();
        localDataSource.cacheRandomActivity(remoteRandomActivity);
        return Right(remoteRandomActivity);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'Server Failure'));
      }
    } else {
      try {
        final localRandomActivity = await localDataSource.getLastRandomActivity();
        return Right(localRandomActivity);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'Cache Failure'));
      }
    }
  }
}
