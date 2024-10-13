abstract class MeasurementSystemEvent {}
class SelectMeasurementSystem extends MeasurementSystemEvent{
  final int system;
  SelectMeasurementSystem(this.system);
}