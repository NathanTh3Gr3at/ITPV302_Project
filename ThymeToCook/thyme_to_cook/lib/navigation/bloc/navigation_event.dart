import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NavigationEvent extends Equatable{
  const NavigationEvent();
}

class SelectTabEvent extends NavigationEvent{
  final int selectedTabIndex;
  const SelectTabEvent(this.selectedTabIndex);
  
  @override
  List<Object?> get props => [selectedTabIndex]; 
}
