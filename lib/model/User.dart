class User{

  String firstName;
  String lastName;
  String email;
  String token;


  User.fromJson(Map<String, dynamic> json) :
    firstName =  json['first_name'],
    lastName =  json['last_name'],
    email =  json['email'],
    token =  json['token'];
  

  Map<String, dynamic> toJson(){
    return{
    'first_name' : firstName,
    'last_name' : lastName,
    'email' : email,
    'token' : token,
    };
  }
}