import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namer_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:namer_app/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:namer_app/screens/budgets/blocs/bloc/budget_bloc.dart';
import 'package:namer_app/screens/savings/blocs/bloc/savings_bloc.dart';
import 'simple_bloc_observer.dart';
import 'firebase_options.dart';

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
        BlocProvider(
          create: (context) => BudgetBloc(),
        ),
        BlocProvider(
          create: (context) => SavingsBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
