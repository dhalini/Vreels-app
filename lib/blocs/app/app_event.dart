import 'package:equatable/equatable.dart';


abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}


class AppStarted extends AppEvent {}


class ThemeChanged extends AppEvent {
  final bool isDarkMode;
  const ThemeChanged(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}


class UserUpdated extends AppEvent {
  final String name;
  final String username;
  final String dob;
  final String email;
  final String about;
  final String phone;
  final String? gender;

  const UserUpdated({
    required this.name,
    required this.username,
    required this.dob,
    required this.email,
    required this.about,
  required this.phone,
  required this.gender,

  });

  @override
  List<Object?> get props => [name, username, dob, email, about,phone,gender];
}
class AppReset extends AppEvent {
  const AppReset();
}
