import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    Order order = ModalRoute.of(context)!.settings.arguments as Order;
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${order.id}"),
      ),
      body: ListView.builder(
        itemCount: (order.orderitems.length) + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index >= order.orderitems.length) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Time : ${order.date}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Purchase value :  INR ${order.total}',
                          // overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Payment method : ${order.payment_method.toUpperCase()}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Status = ${order.status.toUpperCase()}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
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
            );
          } else {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INR ${order.orderitems[index].total}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${order.orderitems[index].name} (x${order.orderitems[index].quantity})',
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Image.network(order.orderitems[index].image),
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
            );
          }
        },
      ),
    );
  }
}
