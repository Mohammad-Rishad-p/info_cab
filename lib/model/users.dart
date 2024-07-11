class Users {
  final String name;
  final String number;
  final String company;

  Users({required this.name, required this.number, required this.company});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone number': number,
      'company': company
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      name: map['name'] ?? '',
      number: map['phone number'] ?? '',
      company: map['company'] ?? '',
    );
  }
}
