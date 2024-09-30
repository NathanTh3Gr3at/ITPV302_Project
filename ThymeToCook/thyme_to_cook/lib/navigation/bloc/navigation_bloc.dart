import 'package:bloc/bloc.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_event.dart';
import 'package:thyme_to_cook/navigation/bloc/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc () : super(const NavigationState(0)) {
    on<SelectTabEvent> ((event, emit) {
      emit(NavigationState(event.selectedTabIndex));
    });
  }
}