import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'credentials.dart';
import 'items.dart';

class Shop extends StatefulWidget {
  final Function(int) onItemTapped;

  const Shop({super.key, required this.onItemTapped});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  Future<void> getNextPage() async {
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
      setState(() {});
    } catch (e) {
      const snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        content: Text('Failed to fetch data'),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar)
          .closed
          .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
    }
  }

  Future<void> removeItemFromWishlist(Items item) async {
    final prefs = await SharedPreferences.getInstance();
    wish_items.removeWhere((obj) => obj.id == item.id);
    List<String> temp = [];
    for (Items item in wish_items) {
      temp.addAll([
        "${item.id}",
        item.name,
        item.price,
        item.pic,
        item.brand,
        item.description
      ]);
    }
    prefs.setStringList("wish_items", temp);
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      content: const Text('Item removed '),
      action: SnackBarAction(
        label: 'Wishlist',
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          widget.onItemTapped(1);
        },
      ),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  Future<void> addItemToWishlist(Items item) async {
    final prefs = await SharedPreferences.getInstance();
    wish_items.add(item);
    List<String> temp = [];
    for (Items item in wish_items) {
      temp.addAll([
        "${item.id}",
        item.name,
        item.price,
        item.pic,
        item.brand,
        item.description
      ]);
    }
    prefs.setStringList("wish_items", temp);
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      content: const Text('Item added '),
      action: SnackBarAction(
        label: 'Wishlist',
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          widget.onItemTapped(1);
        },
      ),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  Future<void> addItemToCart(Items item) async {
    final prefs = await SharedPreferences.getInstance();
    cart_items.add(item);
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
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      content: const Text('Item added '),
      action: SnackBarAction(
        label: 'Go to Cart',
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          widget.onItemTapped(2);
        },
      ),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: shop_items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 250,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Shop_item(
              context: context,
              item: shop_items[index],
              addtocart: (int listnum) async {
                Items item = shop_items[index];
                if (listnum == 0) {
                  await addItemToCart(item);
                } else if (wish_items
                    .any((wishItem) => wishItem.id == shop_items[index].id)) {
                  await removeItemFromWishlist(item);
                } else {
                  await addItemToWishlist(item);
                }
                setState(() {});
                return;
              });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade900,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        height: 40,
        margin: const EdgeInsets.only(left: 60.0, right: 60, bottom: 8),
        child: InkWell(
          onTap: getNextPage,
          child: Center(
            child: Wrap(children: [
              Text(
                'Load More ',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              const Icon(
                Icons.arrow_forward,
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
