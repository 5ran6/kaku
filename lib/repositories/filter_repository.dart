import 'dart:async';

import 'package:kaku/stores/category_filter_state.dart';
class FilterRepository {
// Creating a fake API call utilizing Futures
  Future fakeCategoryFiltersForResultsApiCall() {
// Fake API response data
    List<AlphabetGrouping> results = [
      new AlphabetGrouping(
          'A',
          [
            new CategoryListItemState(
                title: 'Accessories',
                groupValue: '',
                isSelected: false,
                resultCount: 2
            ),
            new CategoryListItemState(
                title: 'Antennas',
                groupValue: '',
                isSelected: false,
                resultCount: 1
            ),
            new CategoryListItemState(
                title: 'App Gaming & Strategy Guides',
                groupValue: '',
                isSelected: false,
                resultCount: 2
            )
          ]
      ),
      new AlphabetGrouping(
          'B',
          [
            new CategoryListItemState(
                title: 'Backpacks',
                groupValue: '',
                isSelected: false,
                resultCount: 2
            ),
            new CategoryListItemState(
                title: 'Books',
                groupValue: '',
                isSelected: false,
                resultCount: 7
            )
          ]
      ),
      new AlphabetGrouping(
          'C',
          [
            new CategoryListItemState(
                title: 'Cellphone Accessories',
                groupValue: '',
                isSelected: false,
                resultCount: 1
            ),
            new CategoryListItemState(
                title: 'Computer Software',
                groupValue: '',
                isSelected: false,
                resultCount: 2
            ),
            new CategoryListItemState(
                title: 'Connected Home',
                groupValue: '',
                isSelected: false,
                resultCount: 6
            )
          ]
      ),
      new AlphabetGrouping(
          'D',
          [
            new CategoryListItemState(
                title: 'Dining Sets',
                groupValue: '',
                isSelected: false,
                resultCount: 3
            ),
            new CategoryListItemState(
                title: 'Dual Action Polishers',
                groupValue: '',
                isSelected: false,
                resultCount: 1
            )
          ]
      )
    ];
// Utilizing completer so that we can fake using .then on our call
    Completer completer = new Completer();
// Delaying the response to simulate a call to an API
    Future.delayed(const Duration(seconds: 2), () {
// Loading the Future with the fake data
      completer.complete(results);
    });
//Returning the Future instance
    return completer.future;
  }
}