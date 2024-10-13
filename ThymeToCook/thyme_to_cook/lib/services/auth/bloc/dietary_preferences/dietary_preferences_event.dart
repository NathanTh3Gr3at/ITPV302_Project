abstract class DietaryPreferencesEvent {}

class SelectDietaryPreference extends DietaryPreferencesEvent {
  final int preference;
  SelectDietaryPreference(this.preference);
}
