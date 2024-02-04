
class loginDetails{
  String id;
  String email;
  String name;
  String password;
  bool loggedin;

  loginDetails({required this.email,required this.name,required this.password,required this.loggedin,required this.id}) ;
}

loginDetails user= loginDetails(id: "0",email: "", name: "guest", password: "", loggedin: false);


