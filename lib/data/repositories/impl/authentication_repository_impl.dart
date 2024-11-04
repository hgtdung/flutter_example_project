import 'package:flutter_example_project/data/data_provider/api/network/result_response.dart';
import 'package:flutter_example_project/data/models/user.dart';
import 'package:flutter_example_project/data/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  @override
  Future<ResultResponse<User>> loginByEmail() {
    // TODO: implement loginByEmail
    throw UnimplementedError();
  }

}