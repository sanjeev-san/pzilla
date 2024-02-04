import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import 'items.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late BuildContext scaffoldContext;
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
    const snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      content: Text('Item removed from wishlist '),
    );
    ScaffoldMessenger.of(scaffoldContext)
        .showSnackBar(snackBar)
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
    setState(() {});
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
    const snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      content: Text('Item added to wishlist'),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
    setState(() {});
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
    const snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      content: Text('Item added to cart'),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;
    Items item = ModalRoute.of(context)!.settings.arguments as Items;
    return WillPopScope(
      onWillPop: () async {
        // Clear all snack bars when navigating away from this page
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            item.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .35,
              padding: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              child: Image.network(item.pic),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 40, right: 14, left: 14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.brand,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'INR ${item.price}',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Html(
                            data: item.description,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  if (wish_items.any((wish_item) => wish_item.id == item.id)) {
                    await removeItemFromWishlist(item);
                  } else {
                    await addItemToWishlist(item);
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: Colors.red),
                  ),
                  child: Icon(
                    wish_items.any((wish_item) => wish_item.id == item.id)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_outlined,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    await addItemToCart(item);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '+ Add to Cart',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
