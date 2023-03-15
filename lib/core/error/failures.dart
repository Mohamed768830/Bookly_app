// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:get/get.dart';

abstract class Failure {
  final String errMessage;
  Failure({
    required this.errMessage,
  });
}

class ServerFailure extends Failure {
  ServerFailure({required super.errMessage});

  factory ServerFailure.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.connectionTimeout:
        return ServerFailure(errMessage: 'Connection timeout with ApiSrver');
      case DioErrorType.sendTimeout:
        return ServerFailure(errMessage: 'Send timeout with ApiSrver');
      case DioErrorType.receiveTimeout:
        return ServerFailure(errMessage: 'Receive timeout with ApiSrver');
      case DioErrorType.badCertificate:
        return ServerFailure(
            errMessage: 'BadCertificate timeout with ApiSrver');
      case DioErrorType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response!.statusCode!, dioError.response!.data);
      case DioErrorType.cancel:
        return ServerFailure(errMessage: 'Request to ApiServer was cancled');
      case DioErrorType.unknown:
        if (dioError.message!.contains('SocketException')) {
          return ServerFailure(errMessage: 'No Internet Connection');
        }
        return ServerFailure(
            errMessage: 'Unexcpected Error, Please tru again!');
      case DioErrorType.connectionError:
        return ServerFailure(
            errMessage: ' Connection Error, Please tru later!');
      default:
        return ServerFailure(
            errMessage: 'Opps There was an Error, Please try again');
    }
  }
  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 402) {
      return ServerFailure(errMessage: response['error']['message']);
    } else if (statusCode == 404) {
      return ServerFailure(
          errMessage: 'Your request not found, Please try later!');
    } else if (statusCode == 500) {
      return ServerFailure(
          errMessage: 'Internal server error, Please try later!');
    } else {
      return ServerFailure(
          errMessage: 'Opps there was an Error, Please try again');
    }
  }
}
