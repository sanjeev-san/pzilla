import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'credentials.dart';
import 'logindetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final phone = TextEditingController();
  var buttonenabled = true;

  void registerFunction() async {
    if (!buttonenabled) {
      return;
    }
    buttonenabled = false;
    if (formkey.currentState!.validate()) {
      try {
        final url = Uri.parse(
            "${Credentials.rootAddress}/wp-json/wc/v3/customers");
        final response = await http.post(url,
            headers: {
              'Authorization':
                  'Basic ${base64Encode(utf8.encode("${Credentials.writeApiKey}:${Credentials.writeApiSecret}"))}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email.text,
              'username': username.text,
              'password': password.text,
              'billing': {'phone': phone.text}
            }));
        if (response.statusCode < 200 || response.statusCode > 299) {
          //201
          throw Exception("Login failed");
        }
        var body = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList("user",
            [email.text, password.text, username.text, '${body['id']}']);
        user.loggedin = true;
        user.name = username.text;
        user.email = email.text;
        user.password = password.text;
        user.id = '${body['id']}';
        buttonenabled = true;
        Navigator.pushReplacementNamed(context, "/home");
      } catch (e) {
        buttonenabled = true;
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          content: const Text('Registration failed'),
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
    buttonenabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                  controller: username,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Invalid username";
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
                    labelText: 'Username',
                    //label style
                  ),
                ),
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
                      return "Invalid password";
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
                  height: 30,
                ),
                TextFormField(
                  controller: phone,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^(\+91|0)?[789]\d{9}$').hasMatch(value)) {
                      return "Enter valid phone number";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    counterText: "",
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                    labelText: 'Phone',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: registerFunction,
                      label: const Text("Register"),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      icon: const Icon(Icons.question_mark),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      label: const Text("Already Have an account "),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
