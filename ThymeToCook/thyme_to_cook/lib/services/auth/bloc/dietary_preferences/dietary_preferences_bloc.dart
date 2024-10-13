import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/dietary_preferences/dietary_preferences_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/dietary_preferences/dietary_preferences_state.dart';

class DietaryPreferencesBloc
    extends Bloc<DietaryPreferencesEvent, DietaryPreferencesState> {
  DietaryPreferencesBloc() : super(DietaryPreferecesInitial());
  @override
  // ignore: override_on_non_overriding_member
  Stream<DietaryPreferencesState> mapEventToState(
      DietaryPreferencesEvent event) async* {
    if (event is SelectDietaryPreference) {
      yield DietaryPreferencesSelected(event.preference);
    }
  }
}
