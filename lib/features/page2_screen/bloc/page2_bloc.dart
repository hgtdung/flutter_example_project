import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_example_project/data/data_provider/api/network/exceptions/network_exceptions.dart';
import 'package:flutter_example_project/data/data_provider/api/network/result_response.dart';
import 'package:flutter_example_project/data/models/user.dart';
import 'package:flutter_example_project/data/repositories/authentication_repository.dart';
import 'package:flutter_example_project/features/page2_screen/bloc/page2_event.dart';
import 'package:flutter_example_project/features/page2_screen/bloc/page2_state.dart';

class Page2Bloc extends Bloc<Page2Event, Page2State> {
  final AuthenticationRepository _authenticationRepository;
  User? user;

  Page2Bloc(this._authenticationRepository): super(Page2StateLoadingState()){
    on<Page2LoadDataEvent>((event, emit) async {
      onDataEvent(emit);
    });

    on<Page2IncreaseAgeEvent>((event, emit) {
      if(user != null) {
        user = user!.copyWith(age: ++user!.age);
        emit(Page2StateDataState(user));
      }
    });
  }

  Future<void> onDataEvent(Emitter<Page2State> emitter) async{
    var result = await _authenticationRepository.loginByEmail();
    switch(result) {
      case Success(data: User user): {
        this.user = user;
        emitter(Page2StateDataState(user));
      }
      case Failure(error: NetworkExceptions exception): {
        emitter(Page2StateErrorState(NetworkExceptions.getErrorMessage(exception)));
      }
    }
  }
}