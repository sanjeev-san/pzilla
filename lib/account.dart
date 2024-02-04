import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pzilla/items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logindetails.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Image(
                image: AssetImage("assets/pzilla1.png"),
                height: 250,
              ),
              Divider(
                  color: Colors.grey[300],
                  height: 5,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.transparent,
                    textStyle: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  child: Text(user.name),
                ),
              ),
              Divider(
                  color: Colors.grey[300],
                  height: 5,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.transparent,
                    textStyle: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  child: Text(user.email),
                ),
              ),
              Divider(
                  color: Colors.grey[300],
                  height: 5,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/contact");
                  },
                  style: TextButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.transparent,
                    textStyle: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  child: RichText(
                    text: const TextSpan(children: [
                      WidgetSpan(
                          child: Icon(Icons.contact_page_rounded),
                          alignment: PlaceholderAlignment.middle),
                      WidgetSpan(
                          child: Text(" Help"),
                          alignment: PlaceholderAlignment.middle),
                    ]),
                  ),
                ),
              ),
              Divider(
                  color: Colors.grey[300],
                  height: 5,
                  thickness: 2,
                  indent: 5,
                  endIndent: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextButton(
                  onPressed: () async {
                    final prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove("user");
                    await prefs.remove("wish_items");
                    await prefs.remove("cart_items");
                    cart_items=[];
                    wish_items=[];
                    user.name="guest";
                    user.password="";
                    user.email="";
                    user.loggedin=false;
                    Navigator.pushReplacementNamed(context, "/login");

                  },
                  style: TextButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.transparent,
                    textStyle: GoogleFonts.ptSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  child: RichText(
                    text: const TextSpan(children: [
                      WidgetSpan(
                          child: Icon(Icons.logout_rounded),
                          alignment: PlaceholderAlignment.middle),
                      WidgetSpan(
                          child: Text(" Logout"),
                          alignment: PlaceholderAlignment.middle),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  }
}
