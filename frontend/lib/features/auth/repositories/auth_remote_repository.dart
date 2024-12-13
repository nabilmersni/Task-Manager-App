import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/constants.dart';
import 'package:task_app/core/services/sp_service.dart';
import 'package:task_app/models/user_model.dart';

class AuthRemoteRepository {
  final SpService spService = SpService();
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "name": name,
            "email": email,
            "password": password,
          },
        ),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['msg'];
      }
      return UserModel.fromJson(res.body);
      // return UserModel.fromMap(jsonDecode(res.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['msg'];
      }
      final user = UserModel.fromJson(res.body);
      await spService.setToken(user.token);
      return user;
      // return UserModel.fromMap(jsonDecode(res.body));
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spService.getToken();
      if (token == null) {
        return null;
      }
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/tokenIsValid'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }

      final response = await http.get(
        Uri.parse('${Constants.backendUri}/auth'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      return UserModel.fromJson(response.body);
      // return UserModel.fromMap(jsonDecode(response.body)['user']);
    } catch (e) {
      throw e.toString();
    }
  }
}
