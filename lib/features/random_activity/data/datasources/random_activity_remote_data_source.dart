import 'package:dio/dio.dart';
import 'package:the_boring_app/core/errors/exceptions.dart';
import 'package:the_boring_app/features/random_activity/data/models/random_activity_model.dart';

abstract class RandomActivityRemoteDataSource {
  Future<RandomActivityModel>? getRandomActivity();
}

class RandomActivityRemoteDataSourceImpl implements RandomActivityRemoteDataSource {
  final Dio dio;

  RandomActivityRemoteDataSourceImpl({required this.dio});

  @override
  Future<RandomActivityModel>? getRandomActivity() async {
    final response = await dio.get(
      'https://www.boredapi.com/api/acitvity',
      queryParameters: {
        'api_key': '',
      },
    );
    if (response.statusCode == 200) {
      return RandomActivityModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
