// Creating a User Object
class User {
  final int id;
  final String login;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.login,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      login: json['login'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

// Creating a Product object
class Product {
  final int id;
  final String name;
  final String price;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(
        id: json['id'] as int,
        name: json['name'] as String,
        price: json['price'] as String,
        category: json['category'] as String,
    );
  }
}

// Create a Table object
class Tablee {
  final int id;
  final int number;

  const Tablee({
    required this.id,
    required this.number,
  });

  factory Tablee.fromJson(Map<String, dynamic> json) {
    return Tablee(
      id: json['id'] as int,
      number: json['number'] as int,
    );
  }
}

// Create a Tbill object
class Tbill {
  final int tnumber;
  final String item;
  final int units;
  final String iprice;
  final String total;

  const Tbill({
    required this.tnumber,
    required this.item,
    required this.units,
    required this.iprice,
    required this.total,
  });

  factory Tbill.fromJson(Map<String, dynamic> json) {
    return Tbill(
        tnumber: json['tnumber'] as int,
        item: json['item'] as String,
        units: json['units'] as int,
        iprice: json['iprice'] as String,
        total: json['total'] as String,
    );
  }
}