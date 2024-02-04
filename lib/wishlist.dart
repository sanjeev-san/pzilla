import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'items.dart';

class Wishlist extends StatefulWidget {
  final Function(int) onItemTapped;

  const Wishlist({super.key, required this.onItemTapped});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  Future<void> removeItemFromWishlist(Items item) async {
    wish_items.remove(item);
    final prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    for (Items item in wish_items) {
      temp.addAll([
        "${item.id}",
        item.name,
        item.price,
        item.pic,
        item.brand,
        item.description,
      ]);
    }
    prefs.setStringList("wish_items", temp);
  }

  Future<void> addItemToCart(Items item) async {
    final prefs = await SharedPreferences.getInstance();
    cart_items.add(item);
    List<String> temp = [];
    for (item in cart_items) {
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

  @override
  Widget build(BuildContext context) {
    if (wish_items.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/empty_wishlist.png")),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Wishlist empty!!!",
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
        //   title: const Text("Wishlist"),
        // ),
        body: ListView(
          children: wish_items
              .map(
                (e) => Wish_item(
                    context: context,
                    item: e,
                    delete: () async {
                      await removeItemFromWishlist(e);
                      final snackBar = SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 8),
                        content: const Text('Item removed from wishlist'),
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
                    },
                    addtocart: () async {
                      await removeItemFromWishlist(e);
                      await addItemToCart(e);
                      final snackBar = SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 8),
                        content: const Text('Item added to cart'),
                        action: SnackBarAction(
                          label: 'Cart',
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            widget.onItemTapped(2);
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
      );
    }
  }
}
