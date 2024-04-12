import 'dart:convert';
import 'dart:developer';
import 'package:hand_tracking/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../contant/urls.dart' as urls;

Future<http.Response> registerRequest(
    String fName, String lName, String email, String pwd) async {
  http.Response response;

  final SharedPreferences pref = await SharedPreferences.getInstance();

  try {
    response = await http.post(Uri.parse(urls.register),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "first_name": fName,
          "last_name": lName,
          "email": email,
          "password": pwd
        }));

    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['jwt'];
      pref.setString('token', token);
    }

    return response;
  } catch (e) {
    log(e.toString());
    return e as http.Response;
  }
}

Future<http.Response> loginRequest(String email, String password) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  http.Response response;
  try {
    response = await http.post(Uri.parse(urls.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": email, "password": password}));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      String token = body["jwt"];

      log("login:$token");
      pref.setString("token", token);
    }
    return response;
  } catch (e) {
    log("error $e");

    return e as http.Response;
  }
}

Future<void> viewRequest() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();

  try {
    String? token = pref.getString("token");
    log("token: $token");
    if (token == null) {
      log('Token not found');
      return;
    }

    http.Response response = await http.get(
      Uri.parse(urls.view),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      log('Request successful');

      pref.setString('user', jsonEncode(jsonDecode(response.body)));

      User user = User.fromJson(jsonDecode(pref.getString('user')!));

      log('${user.toJson()}');

      //await pref.setStringList("user", user);
    } else {
      log('Request failed with status: ${response.statusCode}');
      log('Error: ${response.body}');
    }
  } catch (e) {
    log("error : " + e.toString());
  }
}

Future<int> changeNameRequest(String first_name, String last_name) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');
  log("token: $token");

  try {
    var response =
        await http.post(Uri.parse(urls.change_name), headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      "first_name": first_name,
      "last_name": last_name,
    });

    if (response.statusCode == 200) {
      return 0;
    } else {
      log("error: ${jsonDecode(response.body)}");
      return 1;
    }
  } catch (e) {
    log('$e');
  }
  return 1;
}

Future<void> verifPwdRequest(String oldPwd) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');
  try {
    http.Response responce =
        await http.post(Uri.parse(urls.verif_pwd), headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'old_password': oldPwd
    });

    if (responce.statusCode == 200) {
      log(responce.body);
    } else {
      log('${responce.statusCode}\n${responce.body}');
    }
  } catch (e) {
    log(e.toString());
  }

  //return false;
}

Future<int> changePwdRequest(String new_password) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');

  try {
    var response =
        await http.post(Uri.parse(urls.chnage_pwd), headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      "new_password": new_password,
    });
    if (response.statusCode == 200) {
      return 0;
    } else {
      (log(jsonDecode(response.body).toString()));
      return 1;
    }
  } catch (e) {
    log('$e');
  }
  return 1;
}

Future<void> logoutRequest() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString("token", "");
  try {
    http.post(Uri.parse(urls.logout));
  } catch (e) {
    log('$e');
  }
}
