import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pzilla/credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logo_n_spinner/logo_n_spinner.dart';
import 'logindetails.dart';
import 'items.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> initialuser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("user") != null) {
      var saveduser = prefs.getStringList("user");
      user.loggedin = true;
      user.email = saveduser![0];
      user.password = saveduser[1];
      user.name = saveduser[2];
      user.id = saveduser[3];
    }
    //done any exception/error in logging in or verification simply resets local data
    try {
      final url =
          Uri.parse("${Credentials.rootAddress}/wp-json/wp/v2/users/me");
      final response = await http.get(url, headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode("${user.email}:${user.password}"))}',
      });
      if (response.statusCode != 200) {
        throw Exception("Data not found");
      }
    } catch (e) {
      await prefs.remove("user");
      await prefs.remove("wish_items");
      await prefs.remove("cart_items");
      cart_items = [];
      wish_items = [];
      user.name = "guest";
      user.password = "";
      user.email = "";
      user.loggedin = false;
      return;
    }
    if (prefs.getStringList("cart_items") != null) {
      List<String>? temp = prefs.getStringList("cart_items");
      int? length = temp?.length;
      for (int i = 0; i < length! / 6; i++) {
        Items item = Items(
          id: int.parse(temp![i * 6]),
          name: temp[i * 6 + 1],
          price: temp[i * 6 + 2],
          pic: temp[i * 6 + 3],
          brand: temp[i * 6 + 4],
          description: temp[i * 6 + 5],
        );
        cart_items.add(item);
      }
    }
    if (prefs.getStringList("wish_items") != null) {
      List<String>? temp = prefs.getStringList("wish_items");
      int? length = temp?.length;
      for (int i = 0; i < length! / 6; i++) {
        Items item = Items(
          id: int.parse(temp![i * 6]),
          name: temp[i * 6 + 1],
          price: temp[i * 6 + 2],
          pic: temp[i * 6 + 3],
          brand: temp[i * 6 + 4],
          description: temp[i * 6 + 5],
        );
        wish_items.add(item);
      }
    }
  }

  void getdata() async {
    final currentContext = context;
    try {
      final url = Uri.parse(
          "${Credentials.rootAddress}/wp-json/wc/v3/products?per_page=8&page=$shop_page");
      final response = await http.get(url, headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode("${Credentials.readApiKey}:${Credentials.readApiSecret}"))}',
      });
      if (response.statusCode != 200) {
        throw Exception("Data fetch failed");
      }
      var body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        Items temp = Items(
            id: body[i]['id'],
            name: body[i]['name'],
            description: body[i]['description'],
            brand: body[i]['categories'][0]['name'],
            pic: body[i]['images'][0]['src'],
            price: body[i]['price']);
        shop_items.add(temp);
      }
      shop_page++;
    } catch (e) {
      //DONE do nothing, the array just remains empty
    }
    try {
      final url = Uri.parse(
          "${Credentials.rootAddress}/wp-json/wc/v3/products?per_page=4&page=$category1_page&categories=${pagenames[5]}");
      final response = await http.get(url, headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode("${Credentials.readApiKey}:${Credentials.readApiSecret}"))}',
      });
      if (response.statusCode != 200) {
        throw Exception("Data fetch failed");
      }
      var body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        Items temp = Items(
            id: body[i]['id'],
            name: body[i]['name'],
            description: body[i]['description'],
            brand: body[i]['categories'][0]['name'],
            pic: body[i]['images'][0]['src'],
            price: body[i]['price']);
        category1_items.add(temp);
      }
      category1_page++;
    } catch (e) {
      //DONE do nothing, the array just remains empty
    }
    try {
      final url = Uri.parse(
          "${Credentials.rootAddress}/wp-json/wc/v3/products?per_page=4&page=$category2_page&categories=${pagenames[6]}");
      final response = await http.get(url, headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode("${Credentials.readApiKey}:${Credentials.readApiSecret}"))}',
      });
      if (response.statusCode != 200) {
        throw Exception("Data fetch failed");
      }
      var body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        Items temp = Items(
            id: body[i]['id'],
            name: body[i]['name'],
            description: body[i]['description'],
            brand: body[i]['categories'][0]['name'],
            pic: body[i]['images'][0]['src'],
            price: body[i]['price']);
        category2_items.add(temp);
      }
      category2_page++;
    } catch (e) {
      //DONE do nothing, the array just remains empty
    }
    await initialuser();
    if (!currentContext.mounted) return;
    if (user.loggedin) {
      Navigator.pushReplacementNamed(currentContext, "/home");
    } else {
      Navigator.pushReplacementNamed(currentContext, "/login");
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: LogoandSpinner(
            imageAssets: "assets/pzilla1.png",
            reverse: true,
            arcColor: Colors.blue,
            spinSpeed: Duration(milliseconds: 500),
          ),
        ),
      ),
    );
  }
}
