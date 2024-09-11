part of 'navigation_event_bloc.dart';

sealed class NavigationEventState extends Equatable {
  const NavigationEventState();

  @override
  List<Object> get props => [];
}

final class NavigationEventInitial extends NavigationEventState {}

class NavigationEventUpdated extends NavigationEventState {
  final int pageIndex;

  const NavigationEventUpdated(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}
