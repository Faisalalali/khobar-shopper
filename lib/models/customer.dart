class Customer {
  final String uid;
  final String email;
  final String name;
  final String phoneNumber;
  final Map<String, dynamic>
      address; // Consist of city, street, zip code, building

  Customer({
    required this.uid,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.address,
  });

  Customer.fromJson(Map<String, dynamic> data)
      : this(
          uid: data['uid'],
          email: data['email'],
          name: data['name'],
          phoneNumber: data['phoneNumber'],
          address: data['address'],
        );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'phoneNumber': phoneNumber,
        'address': address,
      };
}
