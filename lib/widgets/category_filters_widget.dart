import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kaku/actions/app_state.dart';
import 'package:kaku/stores/category_filter_state.dart';
import 'package:redux/redux.dart';

// The main widget that will contain all of the nested sub-widgets
class CategoryFilterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            backgroundColor: Colors.white,
            bottomOpacity: 0,
            elevation: 0,
            toolbarOpacity: 0,
            title: AppBarTitleWidget()),
        body: Builder(builder: (BuildContext context) {
          return CategoryFilterBodyWidget();
        }));
  }
}

// Creating and styling the TextFormField we will use for filtering later
class AppBarTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: TextFormField(
            onChanged: (value) => true, //todo> search
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: new BorderSide(color: Colors.grey)),
                fillColor: Colors.white10,
                labelText: 'Search category')));
  }
}

// The body of the page that handles loading all of the sub-widgets into the body
class CategoryFilterBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //We need to create whitespace for the optimum UI so I am using SizedBox for this
        SizedBox(height: 20),
        CategoryFilterListTitleWidget(),
        SizedBox(height: 20),
        CategoryFilterListViewContainerWidget(),
        CategoryFilterActionButtonWidget(),
        SizedBox(height: 40)
      ],
    );
  }
}

// Displays the title of our list
class CategoryFilterListTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 20),
        child: Text('Category', style: TextStyle(fontSize: 16)));
  }
}

// Wraps the list of AlphabetGroupings
class CategoryFilterListViewContainerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store>(
        converter: (store) => store,
        builder: (context, store) {
          return Expanded(
              child: ListView.builder(
                  itemCount: store.state.categoryFilters.viewData.length,
                  itemBuilder: (context, index) {
                    return CategoryFilterListSectionWidget(
                        store.state.categoryFilters.viewData[index]);
                  }));
        });
  }
}

// Takes the AlphabetGrouping object from the CategoryListViewContainerWidget ListView.builder
// Handles creating and styling the individual list sections
class CategoryFilterListSectionWidget extends StatelessWidget {
  final AlphabetGrouping _alphabetGrouping;

  CategoryFilterListSectionWidget(this._alphabetGrouping);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: 60),
      Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(_alphabetGrouping.letter,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)))
        ],
      ),
      ListView.builder(
          // We need to shrinkwrap this ListView to prevent vertical space overrun issues
          shrinkWrap: true,
          // We want these list items to expand vertically and to not be scrollable since the parent already is
          physics: NeverScrollableScrollPhysics(),
          itemCount: _alphabetGrouping.items.length,
          itemBuilder: (context, index) {
            return CategoryFilterListItemWidget(_alphabetGrouping.items[index]);
          })
    ]);
  }
}

// Takes the CategoryListItemState object from the CategoryFilterListSectionWidget ListView builder
// Handles formatting and user interactions on the individual filters
class CategoryFilterListItemWidget extends StatelessWidget {
  final CategoryListItemState _categoryListItem;

  CategoryFilterListItemWidget(this._categoryListItem);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 8),
        StoreConnector<AppState, Store>(
          converter: (store) => store,
          builder: (context, store) {
            return Checkbox(
              onChanged: (value) {
                return value;
              },
              value: _categoryListItem.isSelected,
            );
          },
        ),
        Text('${_categoryListItem.title} (${_categoryListItem.resultCount})')
      ],
    );
  }
}

// Handles formatting and user interactions of the buttons for the widget
class CategoryFilterActionButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Spacer(),
        FlatButton(
            onPressed: () => true, //TODO
            textColor: Colors.blue,
            child: Text('Cancel')),
        FlatButton(
            onPressed: () => true, //TODO
            textColor: Colors.blue,
            child: Text('Reset')),
        RaisedButton(
            onPressed: () => true, //TODO: Make invoice
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Apply')),
        SizedBox(width: 20)
      ],
    );
  }
}
