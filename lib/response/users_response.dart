import 'package:fluttertask/models/users_model.dart';
import 'package:fluttertask/response/error_response.dart';

class UsersResponse {
  late final String message;
  late final int total;
  late final int skip;
  late final int limit;
  List<Error>? error;
  UsersModel? result;
  List<UsersModel>? results;

  UsersResponse({
    Map<String, dynamic>? json,
    bool isList = false,
  }) {
    if (json != null) {
      total = json['total'] ?? 0;
      skip = json['skip'] ?? 0;
      limit = json['limit'] ?? 0;

      if (json['errors'] != null) {
        error = <Error>[];
        json['errors'].forEach((dynamic v) {
          error!.add(Error.fromJson(v as Map<String, dynamic>));
        });
      }

      if (resultMap(json) != null) {
        if (isList) {
          results = (resultMap(json) as List<dynamic>).map((dynamic e) {
            return UsersModel.fromJson(e as Map<String, dynamic>);
          }).toList();
        } else {
          result =
              UsersModel.fromJson(resultMap(json) as Map<String, dynamic>);
        }
      } else {
        result = null;
      }
    } else {
      error = <Error>[Error(message: 'Not authorized')];
    }
  }

  dynamic resultMap(Map<String, dynamic> json) {
    if (json['users'] == null) return json['users'];
    return json['users'];
  }

  dynamic resultError(Map<String, dynamic> json) {
    if (json['errors'] == null) return json['errors'];
    return json['errors'];
  }
}
