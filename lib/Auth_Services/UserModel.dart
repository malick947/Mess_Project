

class Users {
  late String uid;
  String ImgUrl="www.him/her_picture.com";
  int balance=0;
  late String email;
  String fingerPrint="------";
  late String first_name;
  late String last_name;
  late String password;
  late String role;




  Users({required this.uid,required this.first_name,required this.last_name,required this.email,required this.password,required this.role,this.balance=0});

  Map<String,dynamic> toMap(){
    return {
      'uid' : uid,
      'firstName' : first_name,
      'lastName' : last_name,
      'email' : email,
      'password' : password,
      'role' : role,
      'balance' : balance,
      'fingerPrint' : fingerPrint,
      'img_url' : ImgUrl

    };
  }

}