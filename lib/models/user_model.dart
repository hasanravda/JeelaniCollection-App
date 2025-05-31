class UserModel {
  final String uid;
  final String phoneNumber;
  final String email;
  final String name;
  final String address;
  final String city;
  final String state;
  final String pincode;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.email, 
    required this.state, 
    required this.name,
    required this.address,
    required this.city,
    required this.pincode,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'phoneNumber': phoneNumber,
    'email': email,
    'name': name,
    'address': address,
    'city': city,
    'state': state,
    'pincode': pincode,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'],
    phoneNumber: map['phoneNumber'],
    email: map['email'],
    name: map['name'],
    address: map['address'],
    city: map['city'],
    state: map['state'],
    pincode: map['pincode'],
  );
}
