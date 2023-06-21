import 'package:dartz/dartz.dart';

import 'package:the_boring_app/core/errors/failures.dart';
import 'package:the_boring_app/features/random_activity/domain/entities/random_activity.dart';

abstract class RandomActivityRepository {
  Future<Either<Failure, RandomActivity?>> getRandomActivity();
}
