import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class SearchFunctionEvent {
  const SearchFunctionEvent();
}

// event when user types in search bar
class SelectSearchEvent extends SearchFunctionEvent {
  final String search;
  const SelectSearchEvent(this.search);


}

class SearchEventInitial extends SearchFunctionEvent {
  final String search;
  const SearchEventInitial(this.search);
}

class SearchEventLoading extends SearchFunctionEvent {
  final String recipes;
  const SearchEventLoading({required this.recipes});

}

