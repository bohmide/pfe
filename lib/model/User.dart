// ignore_for_file: file_names

class User{

  //int id;
  String firstName;
  String lastName;
  String email;
  String token;


  User.fromJson(Map<String, dynamic> json) :
    //id =  json['id'],
    firstName =  json['first_name'],
    lastName =  json['last_name'],
    email =  json['email'],
    token =  json['token'];
  

  Map<String, dynamic> toJson(){
    return{
    //'id' : id,
    'first_name' : firstName,
    'last_name' : lastName,
    'email' : email,
    'token' : token,
    };
  }
}