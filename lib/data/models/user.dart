class User {
  String name;
  String gender;
  int age;
  User({required this.name, required this.gender, required this.age});

  factory User.fromJson(Map<String, dynamic> map) {
    return User(name: map["name"], gender: map["gender"], age: map["gender"]);
  }

  copyWith({String? name, String? gender, int? age}) {
    return User(
        name: name ?? this.name,
        gender: gender ?? this.gender,
        age: age ?? this.age);
  }
}
