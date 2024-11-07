import 'package:flutter_example_project/data/data_provider/api/authentication_api.dart';
import 'package:flutter_example_project/data/data_provider/api/network/result_response.dart';
import 'package:flutter_example_project/data/models/user.dart';
import 'package:flutter_example_project/data/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationAPI _authenticationAPI;
  AuthenticationRepositoryImpl(this._authenticationAPI);
  @override
  Future<ResultResponse<User>> loginByEmail() async{
    /// Call API here
    /// _authenticationAPI.loginByEmail()

    /// Mock data
      return ResultResponse.success(User(name: "Henry", gender: "male", age: 21));
  }

}