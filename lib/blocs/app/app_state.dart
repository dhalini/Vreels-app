import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final bool isDarkMode;
  final String name;
  final String username;
  final String dob;
  final String email;
  final String about;
  final String phone;
  final String gender;

  const AppState({
    this.isDarkMode = false,
    this.name = '',
    this.username = '',
    this.dob = '',
    this.email = '',
    this.about = '',
    this.phone = '',
    this.gender = '',
  });

  AppState copyWith({
    bool? isDarkMode,
    String? name,
    String? username,
    String? dob,
    String? email,
    String? about,
    String? phone, 
    String? gender,
  }) {
    return AppState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      name: name ?? this.name,
      username: username ?? this.username,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      about: about ?? this.about,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, name, username, dob, email, about, phone,gender];
}
