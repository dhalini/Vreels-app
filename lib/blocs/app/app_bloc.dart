import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppStarted>((event, emit) {
      
    });

    on<ThemeChanged>((event, emit) {
      emit(state.copyWith(isDarkMode: event.isDarkMode));
    });

    on<UserUpdated>((event, emit) {
      emit(
        state.copyWith(
          name: event.name,
          username: event.username,
          dob: event.dob,
          gender: event.gender,
          email: event.email,
          about: event.about,
          phone: event.phone

        ),
      );
    });
    on<AppReset>((event, emit) {
      
      emit(const AppState());
    });
  }
}
