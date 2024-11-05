import 'package:flutter/cupertino.dart';
import 'package:flutter_example_project/data/data_provider/api/network/error_response.dart';
import 'package:flutter_example_project/data/data_provider/api/network/exceptions/network_exceptions.dart';
import 'package:flutter_example_project/features/base/result_state.dart';

abstract class BaseViewmodel<T> extends ChangeNotifier {
  ResultState<T>? resultState;
  
  void setResultState({required ResultState<T>? resultState}) {
    this.resultState = resultState;
    notifyListeners();
  }
  
  void handleNetworkExceptions(NetworkExceptions exception) {
        setResultState(resultState: ResultState.error(exception));
  }

  void resetResultState() {
    setResultState(resultState: ResultState.empty());
  }
}