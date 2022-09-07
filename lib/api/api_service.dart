import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertask/api/api_path.dart';
import 'package:fluttertask/api/shared.dart';

import 'app_config.dart';


class ApiService {
  static const String urlEncodedType = 'multipart/form-data';
  static const String jsonType = 'application/json';
  static const int unAuthorizedCode = 403;
  static const int internalServerErrorCode = 500;
  static const String authorizationParameter = 'Authorization';
  static const String bearer = 'Bearer';



  static Future<Response<T>?> getApi<T>(
      String path,
      {bool isAuth = true}
      ) async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
      ),
    );

    //call api
    if (isAuth) {
      await AppShared.getToken();
      final String token = AppShared.token;
      dio.options.headers[authorizationParameter] = '$bearer $token';
    }

    final Response<T> response = await dio.get(
      path,
      options: Options(
        validateStatus: (int? status) {
          if (status != null) return status < internalServerErrorCode;
          return false;
        },
      ),
    );

    //check the status
    if (response.statusCode == unAuthorizedCode) {
      //await refreshToken();
      return null;
    } else {
      return response;
    }
  }


  static Future<Response<T>?> postApi<T>(
      String path, {
        Map<String, dynamic> body = const <String, dynamic>{},
        bool isJson = true,
        bool isAuth = false,
      }) async {
    // dio init
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.getAppBaseUrl(),
      ),
    );
    //call api
    String token;
    if (isAuth) {
      await AppShared.getToken();
      token = AppShared.token;
      dio.options.headers[authorizationParameter] = '$bearer $token';
    }

    final Response<T> response = await dio.post(
      path,
      data: body,
      options: Options(
        validateStatus: (int? status) {
          if (status != null) {
            return status < internalServerErrorCode;
          }
          return false;
        },
        contentType: isJson ? jsonType : urlEncodedType,
      ),
    );

    if (response.statusCode == unAuthorizedCode) {
      //await refreshToken();
      return null;
    } else {
      return response;
    }
  }

  static Future<Response<T>?> deleteApi<T>(
      String path, {
        bool isJson = true,
        bool isAuth = false,
      }) async {
    // dio init
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.getAppBaseUrl(),
      ),
    );

    //call api
    if (isAuth) {
      await AppShared.getToken();
      final String token = AppShared.token;
      dio.options.headers[authorizationParameter] = '$bearer $token';
    }

    final Response<T> response = await dio.delete(path,
      options: Options(
        validateStatus: (int? status) {
          if (status != null) return status < internalServerErrorCode;
          return false;
        },
        contentType: isJson ? jsonType : urlEncodedType,
      ),
    );
    if (response.statusCode == unAuthorizedCode) {
      //await refreshToken();
      return null;
    } else {
      return response;
    }
  }

  static Future<Response<T>?> patchApi<T>(
      String path, {
        Map<String, dynamic> body = const <String, dynamic>{},
        bool isJson = true,
        bool isAuth = false,
      }) async {
    // dio init
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.getAppBaseUrl(),
      ),
    );

    //call api
    String token;
    if (isAuth) {
      await AppShared.getToken();
      token = AppShared.token;
      dio.options.headers[authorizationParameter] = '$bearer $token';
    }

    final Response<T> response = await dio.patch(path,
      data: body,
      options: Options(
        validateStatus: (int? status) {
          if (status != null) return status < internalServerErrorCode;
          return false;
        },
        contentType: isJson ? jsonType : urlEncodedType,
      ),
    );

    // return response;
    //check the status
    if (response.statusCode == unAuthorizedCode) {
      //await refreshToken();
      return null;
    } else {
      return response;
    }
  }


}