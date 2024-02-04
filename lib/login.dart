import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'credentials.dart';
import 'logindetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  var buttonenabled = true;
  void loginFunction() async {
    if(!buttonenabled){return;}
    buttonenabled=false;
    if (formkey.currentState!.validate()) {
      try {
        final url =
            Uri.parse("${Credentials.rootAddress}/wp-json/wp/v2/users/me");
        final response = await http.get(url, headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("${email.text}:${password.text}"))}',
        });
        if (response.statusCode != 200) {
          throw Exception("Login failed");
        }
        var body = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(
            "user", [email.text, password.text, body['name'], '${body['id']}']);
        user.loggedin = true;
        user.name = body['name'];
        user.email = email.text;
        user.password = password.text;
        user.id = '${body['id']}';
        buttonenabled=true;
        Navigator.pushReplacementNamed(context, "/home");
      } catch (e) {
        buttonenabled=true;
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          content: const Text('Login failed'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
          ),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar)
            .closed
            .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
      }
    }
    buttonenabled=true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const Image(image: AssetImage("assets/pzilla1.png")),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: email,
                autocorrect: false,
                enableSuggestions: false,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                          .hasMatch(value)) {
                    return "Enter correct value";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  counterText: "",
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.grey,
                  ),
                  labelText: 'Email',
                  //lable style
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: password,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter correct value";
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  counterText: "",
                  prefixIcon: Icon(
                    Icons.password,
                    color: Colors.grey,
                  ),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: loginFunction,
                    label: const Text("Login"),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    icon: const Icon(Icons.question_mark),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    label: const Text("Not yet registered "),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
