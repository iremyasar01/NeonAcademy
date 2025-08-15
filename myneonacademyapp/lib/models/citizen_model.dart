class Citizen {
  int? id;
  final String name;
  final String surname;
  final int age;
  final String email;
  final String realm;
  final String specialAbility;

  Citizen({
    this.id,
    required this.name,
    required this.surname,
    required this.age,
    required this.email,
    required this.realm,
    required this.specialAbility,
  });

  // Veritabanı haritasına dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'age': age,
      'email': email,
      'realm': realm,
      'specialAbility': specialAbility,
    };
  }

  // Veritabanı kaydından nesne oluşturma
  factory Citizen.fromMap(Map<String, dynamic> map) {
    return Citizen(
      id: map['id'],
      name: map['name'] ?? '', // Null safety için varsayılan değer
      surname: map['surname'] ?? '',
      age: map['age'] ?? 0,
      email: map['email'] ?? '',
      realm: map['realm'] ?? '',
      specialAbility: map['specialAbility'] ?? '',
    );
  }

  // JSON'dan nesne oluşturma (API entegrasyonu için)
  factory Citizen.fromJson(Map<String, dynamic> json) {
    return Citizen(
      id: json['id'],
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      age: json['age'] ?? 0,
      email: json['email'] ?? '',
      realm: json['realm'] ?? '',
      specialAbility: json['specialAbility'] ?? '',
    );
  }

  // JSON'a dönüştürme (API entegrasyonu için)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'age': age,
      'email': email,
      'realm': realm,
      'specialAbility': specialAbility,
    };
  }

  // Nesneyi kopyalama ve güncelleme
  Citizen copyWith({
    int? id,
    String? name,
    String? surname,
    int? age,
    String? email,
    String? realm,
    String? specialAbility,
  }) {
    return Citizen(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      age: age ?? this.age,
      email: email ?? this.email,
      realm: realm ?? this.realm,
      specialAbility: specialAbility ?? this.specialAbility,
    );
  }

}