import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exp/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:expense_repository/expense_repository.dart';

part 'delete_expense_event.dart';
part 'delete_expense_state.dart';

class DeleteExpenseBloc extends Bloc<DeleteExpenseEvent, DeleteExpenseState> {
  final ExpenseRepository expenseRepository;
  final GetExpensesBloc getExpensesBloc;

  DeleteExpenseBloc(this.expenseRepository, this.getExpensesBloc)
      : super(DeleteExpenseInitial()) {
    on<DeleteExpenseRequested>((event, emit) async {
      emit(DeleteExpenseLoading());
      try {
        await expenseRepository.deleteExpense(event.expenseId);
        getExpensesBloc.add(GetExpenses());
        emit(DeleteExpenseSuccess(event.expenseId));
      } catch (e) {
        emit(DeleteExpenseFailure());
      }
    });
  }
}
