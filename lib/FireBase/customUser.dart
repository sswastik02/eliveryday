// Custom User Model For Firebase
class User {
  final String id;
  final String fullName;
  final String age;
  final String phoneNumber;
  List<String> cartIds = [];

  User({
    this.id = '',
    this.fullName = '',
    this.age = '',
    this.phoneNumber = '',
  });
  // All of them might not be initialised right now so they are in curly braces

  // Named Constructor to return user from JSON
  User.fromJSON(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        age = data['age'],
        phoneNumber = data['phoneNumber'],
        cartIds = List.from(data['cartIds']);

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'fullName': fullName,
      'age': age,
      'phoneNumber': phoneNumber,
      'cartIds': cartIds,
    };
  }
}

User currentUser = User(); // Stores the currently signed in User
