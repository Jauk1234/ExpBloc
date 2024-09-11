import 'package:exp/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exp/blocs/navigation_event_bloc/navigation_event_bloc.dart';
import 'package:exp/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:exp/screens/add_expense/blocs/get_category_bloc/get_category_bloc.dart';
import 'package:exp/screens/add_expense/views/add_expense_screen.dart';
import 'package:exp/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:exp/screens/home/views/main_screen.dart';
import 'package:exp/screens/stats/stats_screen.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        return BlocBuilder<NavigationEventBloc, NavigationEventState>(
          builder: (context, navState) {
            int currentIndex = 0;
            if (navState is NavigationEventUpdated) {
              currentIndex = navState.pageIndex;
            }

            return Scaffold(
              backgroundColor: Colors.grey[200],
              bottomNavigationBar:
                  _buildBottomNavigationBar(context, currentIndex),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: _buildFloatingActionButton(context),
              body: state is GetExpensesLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state is GetExpensesSuccess
                      ? (currentIndex == 0
                          ? MainScreen(state.expenses)
                          : const StatsScreen())
                      : state is GetExpensesFailure
                          ? const Center(
                              child: Text(
                                  'Failed to load expenses. Tap the button to retry.'))
                          : const Center(child: Text('Unexpected state.')),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          context.read<NavigationEventBloc>().add(NavigationPageChanged(index));
        },
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 3.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home,
                color: currentIndex == 0 ? Colors.blue : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search,
                color: currentIndex == 1 ? Colors.blue : Colors.grey),
            label: 'Stats',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        var newExpense = await Navigator.push(
          context,
          MaterialPageRoute<Expense>(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (context) =>
                        CreateCategoryBloc(SupabaseExpenseRepo())),
                BlocProvider(
                    create: (context) => GetCategoryBloc(SupabaseExpenseRepo())
                      ..add(GetCategories())),
                BlocProvider(
                    create: (context) =>
                        CreateExpenseBloc(SupabaseExpenseRepo())),
              ],
              child: const AddExpenseScreen(),
            ),
          ),
        );
        if (newExpense != null) {
          context.read<GetExpensesBloc>().add(GetExpenses());
        }
      },
      shape: const CircleBorder(),
      child: const Icon(CupertinoIcons.add),
    );
  }
}
