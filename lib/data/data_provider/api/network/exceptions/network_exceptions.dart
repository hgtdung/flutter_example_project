
import 'package:dio/dio.dart';
import 'package:flutter_example_project/data/data_provider/api/network/error_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'network_exceptions.freezed.dart';

@freezed
sealed class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorisedRequest() = UnauthorisedRequest;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.badCertificate() = BadCertificate;

  const factory NetworkExceptions.connectionError() = ConnectionError;

  const factory NetworkExceptions.notFound(String reason) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatExceptions() = FormatExceptions;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefautlError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  static NetworkExceptions getDioException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions networkExceptions;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
            case DioExceptionType.connectionTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
            case DioExceptionType.unknown:
              networkExceptions =
              const NetworkExceptions.noInternetConnection();
            case DioExceptionType.badCertificate:
              networkExceptions =  NetworkExceptions.badRequest();

            case DioExceptionType.connectionError:
              networkExceptions = const NetworkExceptions.connectionError();
            case DioExceptionType.receiveTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case (400):
                  networkExceptions =
                  const NetworkExceptions.unauthorisedRequest();
                case (401):
                  networkExceptions =
                  const NetworkExceptions.unauthorisedRequest();
                case (403):
                  networkExceptions =
                  const NetworkExceptions.unauthorisedRequest();
                case (404):
                  networkExceptions =
                  const NetworkExceptions.notFound("not found");
                case (409):
                  networkExceptions = const NetworkExceptions.conflict();
                case (408):
                  networkExceptions = const NetworkExceptions.requestTimeout();
                case (500):
                  networkExceptions =
                  const NetworkExceptions.internalServerError();
                case (503):
                  networkExceptions =
                  const NetworkExceptions.serviceUnavailable();
                default:
                  {
                    var responseCode = error.response!.statusCode;
                    networkExceptions = NetworkExceptions.defaultError(
                        'Received invalid status code: $responseCode');
                  }
              }
            case DioExceptionType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
          }
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatExceptions {
        return const NetworkExceptions.formatExceptions();
      } catch (_) {
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = "";
    errorMessage = switch (networkExceptions) {
      NotImplemented() => "Not implemented",
      RequestCancelled() => "Request Cancelled",
      InternalServerError() => "Internal Server Error",
      NotFound(reason: var reason) => reason,
      ServiceUnavailable() => "Service unavailable",
      MethodNotAllowed() => "Method Allowed",
      BadRequest() => "Bad request",
      UnauthorisedRequest() => " Unauthorised request",
      UnexpectedError() => "Unexpected error occurred",
      NoInternetConnection() => "No internet connection",
      Conflict() => "Error due to conflect",
      SendTimeout() => "Send timeout connection with API server",
      UnableToProcess() => "Unable to process the data",
      DefautlError(error: String error) => error,
      FormatExceptions() => "Unexpected error occurred",
      NotAcceptable() => "Not acceptable",
      BadCertificate() => "Bad certificate",
      ConnectionError() => "Connection error",
      RequestTimeout() => "Request timeout",
    };
    return errorMessage;
  }
}
