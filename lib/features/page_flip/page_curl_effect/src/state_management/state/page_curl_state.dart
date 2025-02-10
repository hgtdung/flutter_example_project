import 'package:equatable/equatable.dart';

sealed class PageCurlState extends Equatable {}

class SketchState extends PageCurlState {
  @override
  List<Object?> get props => [];
}

class CurlNormalState extends PageCurlState {
  CurlNormalState();
  @override
  List<Object?> get props => [];
}

class CurlEdgeState extends PageCurlState {

  CurlEdgeState();

  @override
  List<Object?> get props => [];
}

class CurlFreezeState extends PageCurlState {
  @override
  List<Object?> get props => [];
}
