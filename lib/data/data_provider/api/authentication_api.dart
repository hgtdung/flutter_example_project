import 'package:flutter_example_project/data/data_provider/api/network/result_response.dart';
import 'package:flutter_example_project/data/models/authentication_response.dart';

abstract class AuthenticationAPI {
  Future<ResultResponse<AuthenticationResponse>> loginByEmail(String email);
}