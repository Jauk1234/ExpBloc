part of 'navigation_event_bloc.dart';

sealed class NavigationEventEvent extends Equatable {
  const NavigationEventEvent();

  @override
  List<Object> get props => [];
}

class NavigationPageChanged extends NavigationEventEvent {
  final int index;

  const NavigationPageChanged(this.index);

  @override
  List<Object> get props => [index];
}
