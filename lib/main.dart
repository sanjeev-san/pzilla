import 'package:flutter/material.dart';
import 'loading.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'cart.dart';
import 'account.dart';
import 'contact.dart';
import 'policy.dart';
import 'product.dart';
import 'orders.dart';
import 'orderdetails.dart';


void main() async {
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const Loading(),
        '/login': (context) => const Login(),
        '/register':(context) => const Register(),
        '/home': (context) => const Home(),
        '/cart': (context) => const Cart(),
        '/account': (context) => const Account(),
        '/contact': (context) => const Contact(),
        '/policy': (context) => const Policy(),
        '/product': (context) => const Product(),
        '/orders': (context) => const Orders(),
        '/orderdetails':(context) => const OrderDetails(),
      },
    ),
  );
}
