import 'package:exp/blocs/navigation_event_bloc/navigation_event_bloc.dart';
import 'package:exp/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:exp/screens/home/views/home_screen.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          primary: const Color(0xFF00B2B7),
          secondary: const Color(0xFFE064F7),
          tertiary: const Color(0xFFFFF8D6C),
          outline: Colors.grey,
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GetExpensesBloc(SupabaseExpenseRepo())..add(GetExpenses()),
          ),
          BlocProvider(
            create: (context) => NavigationEventBloc(),
          ),
          // BlocProvider(
          //   create: (context) => DeleteExpenseBloc(SupabaseExpenseRepo()),
          // ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
