import 'package:flutter_example_project/data/data_provider/api/authentication_api.dart';
import 'package:flutter_example_project/data/data_provider/api/network/result_response.dart';
import 'package:flutter_example_project/data/models/authentication_response.dart';

class AuthenticationAPIImpl implements AuthenticationAPI  {
  @override
  Future<ResultResponse<AuthenticationResponse>> loginByEmail(String email) {
    // TODO: implement loginByEmail
    throw UnimplementedError();
  }

}