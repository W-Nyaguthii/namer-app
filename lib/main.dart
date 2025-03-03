import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
//import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namer_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:namer_app/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'simple_bloc_observer.dart';
import 'firebase_options.dart';
//import 'screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateExpenseBloc(FirebaseExpenseRepo()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

//FOR INTEGRATING CHATGPT: 
     // OTHER FILES+FOLDERS; chat_screen.dart, services folder
//class MyApp extends StatelessWidget {
  //@override
  //Widget build(BuildContext context) {
    //return MaterialApp(
      //debugShowCheckedModeBanner: false,
      //title: 'Financial Suite',
      //theme: ThemeData(primarySwatch: Colors.blue),
      //home: ChatScreen(), // Set ChatScreen as the home screen
    //);
 // }
//}
