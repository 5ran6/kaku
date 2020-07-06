import 'package:kaku/stores/category_filter_state.dart';

class AppState {
  final CategoryFilterState categoryFilters;
  AppState({this.categoryFilters});
  factory AppState.initial() => new AppState(
      categoryFilters: CategoryFilterState.initial()
  );
  AppState copyWith({categoryFilters}) {
    return new AppState(
        categoryFilters:
        categoryFilters ?? this.categoryFilters
    );
  }
}