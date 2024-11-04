import 'package:flutter_example_project/data/data_provider/api/network/result_response.dart';
import 'package:flutter_example_project/data/models/user.dart';

abstract class AuthenticationRepository {
  Future<ResultResponse<User>> loginByEmail();
}