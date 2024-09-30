import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int selectedTabIndex;
  const NavigationState(this.selectedTabIndex);
  @override
  // What we using to decide wheather our tabs are equal or not and should rebuild
  List<Object?> get props => [selectedTabIndex];
}