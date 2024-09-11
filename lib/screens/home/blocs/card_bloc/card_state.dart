part of 'card_bloc.dart';

sealed class GetCardState extends Equatable {
  const GetCardState();

  @override
  List<Object> get props => [];
}

final class GetCardInitial extends GetCardState {}

final class CardFailure extends GetCardState {}

final class GetCardSuccess extends GetCardState {
  final int? totalAmount;
  final int? income;

  const GetCardSuccess({this.totalAmount, this.income});

  @override
  List<Object> get props => [totalAmount!, income!];
}

final class GetCardLoading extends GetCardState {}
