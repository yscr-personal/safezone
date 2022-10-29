import 'package:equatable/equatable.dart';

class UserAddressGeoModel extends Equatable {
  final String lat;
  final String lng;

  const UserAddressGeoModel({required this.lat, required this.lng});

  @override
  List<Object> get props => [lat, lng];
}

class UserAddressModel extends Equatable {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final UserAddressGeoModel geo;

  const UserAddressModel({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  @override
  List<Object> get props => [street, suite, city, zipcode, geo];
}

class UserModel extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final UserAddressModel? address;

  const UserModel({
    required this.id,
    this.name,
    this.email,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'].toString(),
        name: json['name'],
        email: json['email'],
        address: UserAddressModel(
          street: json['address']['street'],
          suite: json['address']['suite'],
          city: json['address']['city'],
          zipcode: json['address']['zipcode'],
          geo: UserAddressGeoModel(
            lat: json['address']['geo']['lat'],
            lng: json['address']['geo']['lng'],
          ),
        ),
      );

  factory UserModel.empty() => const UserModel(id: '');

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'address': {
          'street': address?.street,
          'suite': address?.suite,
          'city': address?.city,
          'zipcode': address?.zipcode,
          'geo': {
            'lat': address?.geo.lat,
            'lng': address?.geo.lng,
          },
        },
      };

  @override
  List<Object?> get props => [id, name, email, address];
}
