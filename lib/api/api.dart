import 'package:dio/dio.dart';
import 'package:ipot/models/order_submission_response.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:result_dart/result_dart.dart';
import 'package:ipot/models/menu_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/order_submission.dart';
import 'urls.dart';


class ApiService{
  late final Dio _dio;
  ApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        baseUrl: dotenv.env['API_URL']??''
      )
    );
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get dio => _dio;

  Future<Result<MenuResponse>> getMenu(String tableId) async {
    // String? baseUrl =  dotenv.env['API_URL'];

    try {
      Response response = await _dio.get(getMenuUrl,
          queryParameters: {'table_id': tableId});
      return Success(MenuResponse.fromJson(response.data));
    } on DioException catch(e){
      if(e.type == DioExceptionType.connectionTimeout) {
        return Failure(Exception('Connection timeout. Check your connection and try again later'));
      }
      if(e.type == DioExceptionType.receiveTimeout){
        return Failure(Exception('Server response timeout. Try again later'));
      }
      if(e.response!= null) {
        switch (e.response?.statusCode) {
          case 404:
            return Failure(Exception('Table not found'));
          case 500:
            return Failure(Exception('There is a problem with our server'));
          default:
            return Failure(Exception(
                'Oops! Something went wrong on our end. We’re working on it'));
        }
      } else {
        return Failure(e);
      }
    }
  }

  Future<Result<OrderSubmissionResponse>> submitOrder(OrderSubmission order) async{
    try {
      // Using POST since we are sending data to the server
      Response response = await _dio.post(
        submitOrderUrl,
        data: order.toJson(),
      );

      return Success(OrderSubmissionResponse.fromJson(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return Failure(Exception('Connection timeout. Check your connection and try again later'));
      }
      if (e.type == DioExceptionType.receiveTimeout) {
        return Failure(Exception('Server response timeout. Try again later'));
      }

      if (e.response != null) {
        switch (e.response?.statusCode) {
          case 400:
            return Failure(Exception('Invalid order details. Please check your selection.'));
          case 404:
            return Failure(Exception('Endpoint not found'));
          case 500:
            return Failure(Exception('There is a problem with our server'));
          default:
            return Failure(Exception(
                'Oops! Something went wrong on our end. We’re working on it'));
        }
      } else {
        return Failure(e);
      }
    } catch (e) {
      // Catch any non-Dio errors
      return Failure(Exception('An unexpected error occurred: $e'));
    }
  }
}


