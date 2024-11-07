import 'package:equatable/equatable.dart';

sealed class Page2State extends Equatable{

}

class Page2StateInitialState extends Page2State {
  @override
  List<Object?> get props => [];
}

class Page2StateLoadingState extends Page2State {
  @override
  List<Object?> get props => [];
}

class Page2StateDataState<T> extends Page2State {
  final T data;
  Page2StateDataState(this.data);
  @override
  List<Object?> get props => [data];
}

class Page2StateErrorState  extends Page2State {
  final String message;

  Page2StateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}


