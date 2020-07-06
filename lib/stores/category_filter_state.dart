// This is the main state that will hold the lists that we need to manipulate
class CategoryFilterState {
// This list holds the selected categories in a flattened state
  final List<CategoryListItemState> selectedFilters;
// The master copy of the data
  final List<AlphabetGrouping> masterData;
// The data that will be filtered and presented to the view
  final List<AlphabetGrouping> viewData;
  CategoryFilterState({
    this.selectedFilters,
    this.masterData,
    this.viewData
  });
  factory CategoryFilterState.initial() =>
      new CategoryFilterState(
          selectedFilters: [],
          masterData: [],
          viewData: []
      );
  CategoryFilterState copyWith() {
    return new CategoryFilterState(
        selectedFilters:
        selectedFilters ?? this.selectedFilters,
        masterData: masterData ?? this.masterData,
        viewData: viewData ?? this.viewData
    );
  }
}
// How we will split out the different alphabetical groupings
class AlphabetGrouping {
  // The letter to display in the view
  final String letter;
  // The list of category items to be displayed under the letter
  final List<CategoryListItemState> items;
  AlphabetGrouping(this.letter, this.items);
}
// The model that holds the selected state and display values of the list items
class CategoryListItemState{
  final String title;
  final String groupValue;
  final bool isSelected;
  final int resultCount;
  CategoryListItemState({
    this.title,
    this.groupValue,
    this.isSelected,
    this.resultCount
  });
}