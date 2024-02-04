import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'credentials.dart';
import 'items.dart';
import 'logindetails.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  BuildContext? dialog_context;
  GlobalKey<State> _dialogKey = GlobalKey<State>();

  Future<void> removeItemFromCart(Items item) async {
    cart_items.remove(item);
    final prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    for (Items item in cart_items) {
      temp.addAll([
        "${item.id}",
        item.name,
        item.price,
        item.pic,
        item.brand,
        item.description
      ]);
    }
    prefs.setStringList("cart_items", temp);
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        dialog_context = context;
        _dialogKey = GlobalKey<State>();
        return Dialog(
          key: _dialogKey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          child: SizedBox(
            width: 100,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const Text(
                  "You will be redirected to checkout once server responds...",
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back"))
              ],
            ),
          ),
        );
      },
    );
  }

  void _closeLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void checkout(BuildContext context) async {
    _showLoadingDialog(context);
    var sendItem = {};
    Items item;
    for (item in cart_items) {
      if (sendItem.containsKey(item.id)) {
        sendItem[item.id]++;
      } else {
        sendItem[item.id] = 1;
      }
    }
    try {
      var url = Uri.parse(
          "${Credentials.rootAddress}/wp-json/cocart/v2/cart/clear");
      var response = await http.post(
        url,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode("${user.email}:${user.password}"))}',
        },
      );
      if (response.statusCode < 200 || response.statusCode > 299) {
        //200
        throw Exception("Cart clear failure");
      }
      for (var entry in sendItem.entries) {
        int key = entry.key;
        int value = entry.value;
        var url = Uri.parse(
            "${Credentials.rootAddress}/wp-json/cocart/v2/cart/add-item");
        var response = await http.post(
          url,
          headers: {
            'Authorization':
                'Basic ${base64Encode(utf8.encode("${user.email}:${user.password}"))}',
          },
          body: {
            'id': '$key',
            'quantity': '$value',
          },
        );
        if (response.statusCode < 200 || response.statusCode > 299) {
          //200
          throw Exception("Data send failure");
        }
      }
      cart_items = [];
      final prefs = await SharedPreferences.getInstance();
      prefs.remove("cart_items");
      _closeLoadingDialog(context);
      final uri = Uri.parse(
          "${Credentials.rootAddress}/wp-login.php?a1=${user.name}&a2=${user.password}");
      launchUrl(uri);
      setState(() {});
    } catch (e) {
      _closeLoadingDialog(context);
      const snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        content: Text('Failed to establish secure connection'),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar)
          .closed
          .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cart_items.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/noitems.png")),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Cart empty!!!",
                  style: GoogleFonts.acme(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        // appBar: AppBar(
        //   title: const Text("cart"),
        // ),
        body: ListView(
          children: cart_items
              .map(
                (e) => Cart_item(
                    context: context,
                    item: e,
                    delete: () async {
                      await removeItemFromCart(e);
                      final snackBar = SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 8),
                        content: const Text('Item removed from cart'),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar)
                          .closed
                          .then((value) =>
                              ScaffoldMessenger.of(context).clearSnackBars());
                      setState(() {});
                    }),
              )
              .toList(),
        ),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.blue.shade900,
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          height: 40,
          margin: const EdgeInsets.only(left: 60.0, right: 60, bottom: 8),
          child: InkWell(
            onTap: () async {
              checkout(context);
            },
            child: Center(
              child: Wrap(children: [
                Text(
                  'Checkout ',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.shopping_cart_checkout,
                  size: 35,
                  color: Colors.white,
                ),
              ]),
            ),
          ),
        ),
      );
    }
  }
}
