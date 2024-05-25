import 'dart:convert';
import 'dart:developer';

import 'package:hand_tracking/contant/urls.dart';
import 'package:hand_tracking/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../contant/urls.dart' as urls;

Future<int> checkSever() async {
  try {
    log("check ..");
    final responce = await http
        .get(Uri.parse(serverPath))
        .timeout(const Duration(seconds: 5));
    log("checked");
    return responce.statusCode >= 200 && responce.statusCode < 300 ? 0 : 1;
  } catch (e) {
    log('error: ${e.toString()}');
    return 1;
  }
}

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
      final body = jsonDecode(response.body);

      log("registered with success");
      User user = User.fromJson(body);
      pref.setString("user", jsonEncode(user.toJson()));
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

      log("login with success");
      User user = User.fromJson(body);

      pref.setString("user", jsonEncode(user.toJson()));
    }
    return response;
  } catch (e) {
    log("error $e");

    return e as http.Response;
  }
}

Future<void> viewRequest() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? dataUser = pref.getString('user');

  if (dataUser == null) {
    log("user not found");
    //return 1;
  } else {
    User user = User.fromJson(jsonDecode(dataUser));
    try {
      http.Response response = await http.get(
        Uri.parse(urls.view),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        log('Request successful');

        log('${jsonEncode(response.body)}');

        //await pref.setStringList("user", user);
      } else {
        log('Request failed with status: ${response.statusCode}');
        log('Error: ${response.body}');
      }
    } catch (e) {
      log("error : $e");
    }
  }
}

Future<int> changeNameRequest(String first_name, String last_name) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? dataUser = pref.getString("user");

  if (dataUser == null) {
    log("user not found");
    return 1;
  } else {
    User user = User.fromJson(jsonDecode(dataUser));
    try {
      var response = await http
          .post(Uri.parse(urls.change_name), headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user.token}',
      }, body: <String, String>{
        "first_name": first_name,
        "last_name": last_name,
      });

      if (response.statusCode == 200) {
        user.firstName = first_name;
        user.lastName = last_name;
        pref.setString('user', jsonEncode(user.toJson()));
        return 0;
      } else {
        log("error: ${jsonDecode(response.body)}");
        return 1;
      }
    } catch (e) {
      log('$e');
    }
  }

  return 1;
}

Future<int> changePwdRequest(String new_password, String old_password) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  var token = pref.getString('token');

  try {
    var response =
        await http.post(Uri.parse(urls.chnage_pwd), headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      "new_password": new_password,
      "old_password":old_password
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

Future<int> resetSendMailRequest(String email) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();

  try {
    log(urls.resetSendMail);
    http.Response response = await http.post(Uri.parse(urls.resetSendMail),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "email": email,
        }));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      pref.setString("token_code", body["token"]);
      log("seccess\n ${pref.getString('token_code')}");
      return 0;
    } else {
      log(jsonEncode(response.body));
      return 1;
    }
  } catch (e) {
    log("error : ${jsonEncode(e)}");
    return -1;
  }
}

Future<int> verifCodeRequest(token, code) async {
  try {
    http.Response response = await http.post(Uri.parse(urls.verifCode),
        /*headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },*/
        body: <String, String>{
          "token": token,
          "code": code,
        });
    if (response.statusCode == 200) {
      return 0;
    } else if (response.statusCode == 206) {
      return 1;
    } else {
      log("token invalid");
      return -1;
    }
  } catch (e) {
    log("error : ${e.toString()}");
    return -1;
  }
}

Future<int> resetPasswordRequest(token, password, re_password) async {
  try {
    http.Response response = await http.post(Uri.parse(urls.resetPassword),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "token": token,
          "password": password,
          "re_password": re_password,
        }));

    if (response.statusCode == 200) {
      return 0;
    } else if (response.statusCode == 205) {
      return 1;
    } else if (response.statusCode == 206) {
      return 2;
    } else {
      return -1;
    }
  } catch (e) {
    log("error : ${e.toString()}");
    return -1;
  }
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



Future<String?> sendImageToBackend(String imagePath) async {

  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? dataUser = pref.getString("user");

  if(dataUser!=null){
    User user = User.fromJson(jsonDecode(dataUser));
    var request = http.MultipartRequest('POST', Uri.parse(urls.modelPridect));
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    Map<String, dynamic> payload= JwtDecoder.decode(user.token);
    request.fields['id_user'] = payload['id'].toString();
  
    var response = await request.send();
    if (response.statusCode == 200) {
      log('Image uploaded');
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      var prediction = jsonResponse['prediction'];
      return prediction;
      //File(imagePath).delete().then((_)=> log("image deleted"));
    } else if (response.statusCode == 204) {
      return '1';
    }else {
      return '-1';
    }
  }
  return null;
}
