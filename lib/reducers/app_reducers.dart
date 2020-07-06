import 'package:kaku/actions/app_state.dart';
import 'package:kaku/reducers/category_filter_reducers.dart';
import 'package:kaku/stores/category_filter_state.dart';

AppState appReducer(AppState state, action) {
  return state.copyWith(
      categoryFilters: new CategoryFilterState(
          // Holds the persisted state of the list
          masterData: categoryFilterMasterDataReducer(
              state.categoryFilters.masterData, action),
          // Holds the view portion of the list that can be filtered against
          viewData: categoryFilterViewDataReducer(
              state.categoryFilters.viewData, action)));
}
