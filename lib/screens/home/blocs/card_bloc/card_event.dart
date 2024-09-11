part of 'card_bloc.dart';

sealed class GetCardEvent extends Equatable {
  const GetCardEvent();

  @override
  List<Object> get props => [];
}

class GetCardExpenses extends GetCardEvent {
  final List<Expense> expenses;

  const GetCardExpenses(this.expenses);

  @override
  List<Object> get props => [expenses];
}

class SetIncome extends GetCardEvent {
  final int income;

  const SetIncome(this.income);
  @override
  List<Object> get props => [income];
}
