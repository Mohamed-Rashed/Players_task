import 'package:dio/dio.dart';
import 'package:fluttertask/api/api_path.dart';
import 'package:fluttertask/api/api_service.dart';
import 'package:fluttertask/response/users_response.dart';

class UsersRepo{

  static Future<UsersResponse> getAllUsers() async {
    final Response<dynamic>? response = await ApiService.getApi(
      "${ApiPaths.users}?limit=10",
    );

    return UsersResponse(
      json: response?.data,
      isList: true,
    );
  }


}