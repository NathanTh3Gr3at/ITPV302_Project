abstract class MeasurementSystemState{}
class MeasurementSystemInitial extends MeasurementSystemState{}
class MeasurementSystemSelected extends MeasurementSystemState{
  final int system;
  MeasurementSystemSelected(this.system);
}