import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thyme_to_cook/services/auth/bloc/measurement_system/measurement_system_event.dart';
import 'package:thyme_to_cook/services/auth/bloc/measurement_system/measurement_system_state.dart';

class MeasurementSystemBloc extends Bloc<MeasurementSystemEvent, MeasurementSystemState> {
  MeasurementSystemBloc() : super(MeasurementSystemInitial());

  @override
  // ignore: override_on_non_overriding_member
  Stream<MeasurementSystemState> mapEventToState(MeasurementSystemEvent event) async* {
    if (event is SelectMeasurementSystem) {
      yield MeasurementSystemSelected(event.system);
    }
  }
}