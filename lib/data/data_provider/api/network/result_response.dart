import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'exceptions/network_exceptions.dart';

part 'result_response.freezed.dart';

@freezed
sealed class ResultResponse<T> with _$ResultResponse<T> {
  const factory ResultResponse.success(T data) = Success<T>;

  const factory ResultResponse.failure(NetworkExceptions error) = Failure<T>;

}