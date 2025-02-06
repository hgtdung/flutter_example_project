import 'package:equatable/equatable.dart';
import 'package:flutter_example_project/features/page_flip/page_curl_effect/model/coordinates/FPoint.dart';

sealed class PageCurlEvent extends Equatable {}

class SketchEvent extends PageCurlEvent {
  @override
  List<Object?> get props => [];
}

class CurlNormalEvent extends PageCurlEvent {
  CurlNormalEvent();

  @override
  List<Object?> get props => [];
}

class CurlEdgeEvent extends PageCurlEvent {
  final double leftLimitationAngle;
  final FPoint newPivot;
  CurlEdgeEvent({required this.leftLimitationAngle,required this.newPivot});

  @override
  List<Object?> get props => [];

  copyWith(
      {double? leftLimitationAngle, FPoint? newPivot}) {
    return CurlEdgeEvent(
        leftLimitationAngle: leftLimitationAngle ?? this.leftLimitationAngle,
        newPivot: newPivot?? this.newPivot
    );
  }
}

class CurlFreezeEvent extends PageCurlEvent {
  @override
  List<Object?> get props => [];
}
