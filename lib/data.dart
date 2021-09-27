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
  final String? image;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
      category: json['category'] as String,
      image: json['image'] as String?,
    );
  }
}

// Create a Table object
class Tablee {
  final int id;
  final int number;
  final String total;

  const Tablee({
    required this.id,
    required this.number,
    required this.total,
  });

  factory Tablee.fromJson(Map<String, dynamic> json) {
    return Tablee(
      id: json['id'] as int,
      number: json['number'] as int,
      total: json['total'] as String,
    );
  }
}

// Create a Tbill object
class Tbill {
  final int id;
  final int? tnumber;
  final String item;
  final int units;
  final String iprice;
  final String total;

  const Tbill({
    required this.id,
    required this.tnumber,
    required this.item,
    required this.units,
    required this.iprice,
    required this.total,
  });

  factory Tbill.fromJson(Map<String, dynamic> json) {
    return Tbill(
      id: json['id'] as int,
      tnumber: json['tnumber'] as int?,
      item: json['item'] as String,
      units: json['units'] as int,
      iprice: json['iprice'] as String,
      total: json['total'] as String,
    );
  }
}

// Create a CashCount object
class CashCount {
  final String day;
  final String? netSale;
  final String? cardPayments;
  final String? cashPayments;
  final int? numberSales;
  final String? averageTicket;
  final String? income;
  final String? outflow;

  const CashCount({
    required this.day,
    required this.netSale,
    required this.cardPayments,
    required this.cashPayments,
    required this.numberSales,
    required this.averageTicket,
    required this.income,
    required this.outflow,
  });

  factory CashCount.fromJson(Map<String, dynamic> json) {
    return CashCount(
      day: json['day'] as String,
      netSale: json['net_sale'] as String?,
      cardPayments: json['card_payments'] as String?,
      cashPayments: json['cash_payments'] as String?,
      numberSales: json['number_sales'] as int?,
      averageTicket: json['average_ticket'] as String?,
      income: json['income'] as String?,
      outflow: json['outflow'] as String?,
    );
  }
}
