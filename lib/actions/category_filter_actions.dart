import 'package:kaku/repositories/filter_repository.dart';
import 'package:kaku/stores/category_filter_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

FilterRepository _filterRepository = new FilterRepository();

ThunkAction loadCategoryFiltersForResults() {
  return ((Store store) {
    // I like using a repository to abstract the API calls away from my actions
    _filterRepository.fakeCategoryFiltersForResultsApiCall().then((results) {
      // We need to pass the results to the master data action to hydrate the list
      store.dispatch(CategoryFiltersMasterDataLoadedAction(results));
// We need to pass the results to the view data action to hydrate the list
      store.dispatch(CategoryFiltersViewDataLoadedAction(results));
    }).catchError((error) {
      print(error);
    });
  });
}

class CategoryFiltersMasterDataLoadedAction {
  final List<AlphabetGrouping> results;

  CategoryFiltersMasterDataLoadedAction(this.results);
}

class CategoryFiltersViewDataLoadedAction {
  final List<AlphabetGrouping> results;

  CategoryFiltersViewDataLoadedAction(this.results);
}
