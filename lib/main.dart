import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prototype25/blocs/app/app_bloc.dart';
import 'package:prototype25/Registration/cold_start.dart';
import 'package:prototype25/EntryScreen/entry.dart';
import 'package:prototype25/dummy_screen.dart';
import 'login/login_page.dart';
import 'blocs/auth/auth_bloc.dart';
import 'app_bloc_observer.dart'; 
import 'package:firebase_core/firebase_core.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  try {
  await Firebase.initializeApp();
  print('Firebase initialized successfully.');
} catch (e) {
  print('Firebase initialization failed: $e');
}
  

  runApp(const MyApp());
  
}

class ColdStart extends StatelessWidget {
  const ColdStart({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: "cold_start",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true

      ),
      home: const DummyScreen());
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      
      providers: [
        BlocProvider(create: (context) => AppBloc()), 
        BlocProvider(create: (context) => AuthBloc()), 
      ],
      child: MaterialApp(
        title: 'MyApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges() ,
          builder: (context, snapshot)  {
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                return const EntryWidget();
              }
              else if(snapshot.hasError){
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            return const MyLoginPage();

          },
        ),
      ),
    );
  }
}
