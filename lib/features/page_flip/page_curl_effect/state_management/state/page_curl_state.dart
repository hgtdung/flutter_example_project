import 'package:equatable/equatable.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/model/cylinder.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/state_management/state/horizontal_page_curl.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/state_management/state/middle_paper_curl.dart';

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
