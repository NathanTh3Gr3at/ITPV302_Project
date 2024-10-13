abstract class DietaryPreferencesState{}
class DietaryPreferecesInitial extends DietaryPreferencesState{}
class DietaryPreferencesSelected extends DietaryPreferencesState{final int preference;
DietaryPreferencesSelected(this.preference);}