class OrderItem {
  String name;
  String total;
  String quantity;
  String image;

  OrderItem({
    required this.total,
    required this.name,
    required this.quantity,
    required this.image,
  });
}

class Order {
  int id;
  String status;
  String total;
  String date;
  String payment_method;
  List<OrderItem> orderitems;

  Order(
      {required this.id,
      required this.status,
      required this.total,
      required this.date,
      required this.payment_method,
      required this.orderitems});
}

List<Order> order_items = [];
DateTime currentTime = DateTime.now();
