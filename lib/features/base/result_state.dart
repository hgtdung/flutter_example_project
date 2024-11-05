import 'package:flutter_example_project/data/data_provider/api/network/exceptions/network_exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_state.freezed.dart';

@freezed
sealed class ResultState<T> with _$ResultState<T> {
  const factory ResultState.empty() = Empty;
  const factory ResultState.loading() = Loading;
  const factory ResultState.success(T data) = Data<T>;
  const factory ResultState.error(NetworkExceptions error, [String? errorServerId, int? errorField]) = Error<T>;
}