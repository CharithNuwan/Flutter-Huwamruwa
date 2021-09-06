class Cart {

  int id;
  double price;
  int qty;
  String name;
  String photo;
  String des;

  Cart();

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    qty = json['qty'];
    name = json['name'];
    name = json['photo'];
    des = json['des'];
  }
}
