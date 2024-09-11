part of 'delete_expense_bloc.dart';

sealed class DeleteExpenseEvent extends Equatable {
  const DeleteExpenseEvent();

  @override
  List<Object> get props => [];
}

class DeleteExpenseRequested extends DeleteExpenseEvent {
  final String expenseId;

  const DeleteExpenseRequested(this.expenseId);

  @override
  List<Object> get props => [expenseId];
}
