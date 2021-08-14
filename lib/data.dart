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