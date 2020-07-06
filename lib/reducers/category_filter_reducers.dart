import 'package:kaku/actions/category_filter_actions.dart';
import 'package:kaku/stores/category_filter_state.dart';
import 'package:redux/redux.dart';

// Using combineReducers so that we can group all the necessary reducers into a single entity
final Reducer<List<AlphabetGrouping>> categoryFilterMasterDataReducer =
    combineReducers([
  TypedReducer<List<AlphabetGrouping>, CategoryFiltersMasterDataLoadedAction>(
      _loadCategoryFilterMasterDataReducer)
]);

// Using combineReducers so that we can group all the necessary reducers into a single entity
final Reducer<List<AlphabetGrouping>> categoryFilterViewDataReducer =
    combineReducers([
  TypedReducer<List<AlphabetGrouping>, CategoryFiltersViewDataLoadedAction>(
      _loadCategoryFilterViewDataReducer)
]);

// Reducer to pass input value on through
List<AlphabetGrouping> _loadCategoryFilterMasterDataReducer(
    List<AlphabetGrouping> state,
    CategoryFiltersMasterDataLoadedAction action) {
  return action.results;
}

// Reducer to pass input value on through
List<AlphabetGrouping> _loadCategoryFilterViewDataReducer(
    List<AlphabetGrouping> state, CategoryFiltersViewDataLoadedAction action) {
  return action.results;
}
