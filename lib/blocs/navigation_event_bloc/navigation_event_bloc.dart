import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event_event.dart';
part 'navigation_event_state.dart';

class NavigationEventBloc
    extends Bloc<NavigationEventEvent, NavigationEventState> {
  NavigationEventBloc() : super(NavigationEventInitial()) {
    on<NavigationPageChanged>((event, emit) {
      emit(NavigationEventUpdated(event.index));
    });
  }
}
