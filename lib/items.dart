import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

int shop_page = 1;
int category1_page = 1;
int category2_page = 1;
List<Items> shop_items = [];
List<Items> cart_items = [];
List<Items> wish_items = [];
List<Items> category1_items = [];
List<Items> category2_items = [];

Map<int, String> pagenames = {5: "Electronics", 6: "Gadgets"};

class Items {
  int id;
  String name;
  String price;
  String pic;
  String brand;
  String description;
  String short_desc="";

  Items(
      {required this.id,
      required this.name,
      required this.price,
      required this.pic,
      required this.brand,
      required this.description});
}

Widget Shop_item(
    {required Items item,
    required void Function(int) addtocart,
    required BuildContext context}) {
  return InkWell(
    child: Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: 20,
      shadowColor: Colors.blue,
      margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 8.0, 5, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 80,
              child: Image(
                image: NetworkImage(item.pic),
                fit: BoxFit.fitHeight,
              ),
            ),
            Text(
              item.name,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              item.brand,
              style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "INR ${item.price}",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    addtocart(0);
                  },
                  child: Text(
                    "Add to Cart",
                    style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    addtocart(1);
                  },
                  icon: wish_items.any((wishItem) => wishItem.id == item.id)
                      ? const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.red,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    onTap: () {
      Navigator.pushNamed(context, "/product", arguments: item);

    },
  );
}

Widget Cart_item(
    {required BuildContext context,
    required Items item,
    required void Function() delete}) {
  return InkWell(
    child: Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 80,
                  child: Image(
                    image: NetworkImage(item.pic),
                    fit: BoxFit.fitHeight,
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: Text(
                    item.name,
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "INR ${item.price}",
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: delete,
                  child: Text(
                    "Delete",
                    style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    onTap: () {
      Navigator.pushNamed(context, "/product", arguments: item);
    },
  );
}

Widget Wish_item(
    {required BuildContext context,
    required Items item,
    required void Function() delete,
    required void Function() addtocart}) {
  return InkWell(
    child: Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      child: Image(
                        image: NetworkImage(item.pic),
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: Text(
                        item.name,
                        style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "INR ${item.price}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: delete,
                  child: Text(
                    "Delete",
                    style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: addtocart,
                  child: Text(
                    "+Cart",
                    style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    onTap: () {
      Navigator.pushNamed(context, "/product", arguments: item);
    },
  );
}
