import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<GetCardEvent, GetCardState> {
  final ExpenseRepository _expenseRepository;
  int _income = 12;
  CardBloc(this._expenseRepository) : super(GetCardInitial()) {
    on<GetCardExpenses>((event, emit) async {
      try {
        emit(GetCardLoading());

        final expenses = await _expenseRepository.getExpenses();
        final totalAmount =
            expenses.fold<int>(0, (sum, expense) => sum + expense.amount);
        emit(GetCardSuccess(
          totalAmount: totalAmount,
          income: _income,
        ));
      } catch (_) {
        emit(CardFailure());
      }
    });
    on<SetIncome>((event, emit) {
      _income = event.income;
      add(const GetCardExpenses([]));
    });
  }
}
