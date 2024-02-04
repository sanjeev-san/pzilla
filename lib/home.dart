import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'credentials.dart';
import 'logindetails.dart';
import 'items.dart';
import 'cart.dart';
import 'wishlist.dart';
import 'account.dart';
import 'orders.dart';
import 'shop.dart';
import 'category1.dart';
import 'category2.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  int _pageindex = 0;

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void selectDestination(int index) {
    //drawer bar
    _closeDrawer();
    if (index == 0) {
      setState(() {
        _selectedIndex = 4;
        _pageindex = _selectedIndex;
      });
    } else if (index == 1) {
      ScaffoldMessenger.of(context).clearSnackBars();
      setState(() {
        _pageindex = 5;
      });
    } else if (index == 3) {
      Navigator.pushNamed(context, "/contact");
    } else if (index == 4) {
      Navigator.pushNamed(context, "/policy");
    } else if (index == 6) {
      final uri = Uri.parse("https://youtube.com");
      launchUrl(uri);
    } else if (index == 2) {
      ScaffoldMessenger.of(context).clearSnackBars();
      setState(() {
        _pageindex = 6;
      });
    }
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  void _onItemTapped(int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
    setState(() {
      _selectedIndex = index;
      _pageindex = _selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Shop(onItemTapped: _onItemTapped),
      Wishlist(onItemTapped: _onItemTapped),
      const Cart(),
      const Orders(),
      const Account(),
      Category1(onItemTapped: _onItemTapped),
      Category2(onItemTapped: _onItemTapped),
    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu_open_outlined,
            color: Colors.black,
          ),
          onPressed: _openDrawer,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pageindex >= 5
                ? Text(
                    pagenames[_pageindex]!,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue.shade900,
                    ),
                  )
                : const SizedBox(
                    height: 50,
                    child: Image(
                      image: AssetImage("assets/pzilla1.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              //todo the view is not updating on return
              // method to show the search bar
              await showSearch(
                context: context,
                // delegate to customize the search bar
                delegate: CustomSearchDelegate(),
              );
              setState(() {});
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 16),
          //   child: Icon(Icons.shopping_cart),
          // ),
          // Icon(Icons.account_box),
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        )),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        backgroundColor: Colors.blue,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: const EdgeInsets.only(top: 30),
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80,
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: const Image(
                      image: AssetImage("assets/pzilla1.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      "Hi , ${user.name} ",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: Text(
                'Account',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconColor: Colors.white,
              onTap: () => {
                selectDestination(0),
              },
            ),
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: Text(
                'Electronics',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconColor: Colors.white,
              onTap: () => {
                selectDestination(1),
              },
            ),
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: Text(
                'Gadgets',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconColor: Colors.white,
              onTap: () => {
                selectDestination(2),
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_page),
              title: Text(
                'Contact',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconColor: Colors.white,
              onTap: () => {
                selectDestination(3),
              },
            ),
            ListTile(
              leading: const Icon(Icons.policy),
              title: Text(
                'Policy',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconColor: Colors.white,
              onTap: () => {
                selectDestination(4),
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text(
                'FAQs',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconColor: Colors.white,
              onTap: () => {
                selectDestination(5),
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 16,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Page not available",
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
                ),
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(
                'Share app',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              iconColor: Colors.white,
              onTap: () => {
                selectDestination(6),
              },
            )
          ],
        ),
      ),
      body: pages[_pageindex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue.shade900,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              label: 'Shop',
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Wishlist',
              icon: Icon(Icons.favorite_border_outlined),
              activeIcon: Icon(Icons.favorite_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Cart',
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Track',
              icon: Icon(Icons.location_on_outlined),
              activeIcon: Icon(Icons.location_on),
            ),
            BottomNavigationBarItem(
              label: 'Me',
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<Items> searchTerms = [];

  Future<void> getsearchterms() async {
    //todo do we need to limit items fetched and call loadmore?
    searchTerms.clear();
    if (query.length < 3) {
      return;
    }

    final url = Uri.parse(
        "${Credentials.rootAddress}/wp-json/wc/v3/products?search=$query");
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
      searchTerms.add(temp);
    }
  }

  Future<void> removeItemFromWishlist(Items item, BuildContext context) async {
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
      content: const Text('Item removed from wishlist'),
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

  Future<void> addItemToWishlist(Items item, BuildContext context) async {
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
      content: const Text('Item added to wishlist'),
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

  Future<void> addItemToCart(Items item, BuildContext context) async {
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
      content: const Text('Item added to cart'),
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

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error fetching data.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "Try again after some time. If the issue remains, you can contact our support team.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (searchTerms.isEmpty) {
              return const Center(
                child: Text("No results found"),
              );
            } else {
              return GridView.builder(
                  itemCount: searchTerms.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Shop_item(
                        context: context,
                        item: searchTerms[index],
                        addtocart: (int listnum) async {
                          Items item = shop_items[index];
                          if (listnum == 0) {
                            await addItemToCart(item, context);
                          } else if (wish_items.any((wishItem) =>
                              wishItem.id == shop_items[index].id)) {
                            await removeItemFromWishlist(item, context);
                          } else {
                            await addItemToWishlist(item, context);
                          }
                          return;
                        });
                  });
            }
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: getsearchterms(),
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text("Search to get results"),
    );
  }
}
