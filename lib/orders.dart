import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'credentials.dart';
import 'logindetails.dart';
import 'order.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future fetchData() async {
    DateTime newTime = DateTime.now();
    Duration difference = newTime.difference(currentTime);
    if (order_items.isEmpty || difference.inSeconds >= 30) {
      order_items = [];
      currentTime = DateTime.now();
      final url = Uri.parse(
          "${Credentials.rootAddress}/wp-json/wc/v3/orders?customer=${user.id}");
      final response = await http.get(url, headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode("${Credentials.readApiKey}:${Credentials.readApiSecret}"))}',
      });
      if (response.statusCode != 200) {
        throw Exception('Simulated Network Error');
      }
      var body = jsonDecode(response.body);
      for (int i = 0; i < body.length; i++) {
        List<OrderItem> orderitemslist = [];
        for (var e in body[i]['line_items']) {
          OrderItem currOrderItem = OrderItem(
            total: '${e['total']}',
            name: e['name'],
            quantity: '${e['quantity']}',
            image: e['image']['src'],
          );
          orderitemslist.add(currOrderItem);
        }
        Order tempOrder = Order(
            id: body[i]['id'],
            status: body[i]['status'],
            date: body[i]['date_created'],
            payment_method: body[i]['payment_method'],
            total: body[i]['total'],
            orderitems: orderitemslist);
        order_items.add(tempOrder);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if there was an error fetching data
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
        } else if (order_items.isNotEmpty) {
          // Show the data once it's available
          return GridView.builder(
            itemCount: order_items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 110,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        order_items[index].status.toUpperCase() == "PROCESSING"
                            ? const Color.fromRGBO(64, 75, 96, .9)
                            : Colors.green[900],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: const EdgeInsets.only(right: 12.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1.0,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                      child: Text(
                        "#${order_items[index].id}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      "INR ${order_items[index].total}",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Text(
                      order_items[index].status.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right,
                        color: Colors.white, size: 30.0),
                    onTap: () {
                      Navigator.pushNamed(context, "/orderdetails",
                          arguments: order_items[index]);
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
              child: Text(
            "No orders yet!!!",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ));
        }
      },
    );
  }
}
