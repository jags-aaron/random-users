class User {
  String gender;
  String nationality;
  String name;
  String location;
  String email;
  String dob;
  String phone;
  String id;
  String picture;

  User({
    required this.gender,
    required this.nationality,
    required this.name,
    required this.location,
    required this.email,
    required this.dob,
    required this.phone,
    required this.id,
    required this.picture,
  });

  User copyWith({
    String? gender,
    String? nationality,
    String? name,
    String? location,
    String? email,
    String? dob,
    String? phone,
    String? id,
    String? picture,
  }) {
    return User(
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      name: name ?? this.name,
      location: location ?? this.location,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      phone: phone ?? this.phone,
      id: id ?? this.id,
      picture: picture ?? this.picture,
    );
  }

}
