class Product {
  String? name;
  String? measurement;
  double? price;

  Product({this.name, this.measurement, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    measurement = json['measurement'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['measurement'] = measurement;
    data['price'] = price;
    return data;
  }
}
