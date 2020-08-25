import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kaku/actions/app_state.dart';
import 'package:kaku/actions/category_filter_actions.dart';
import 'package:kaku/reducers/app_reducers.dart';
import 'package:kaku/widgets/category_filters_widget.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
class Make_Sale extends StatefulWidget {
String name;
String phone;
String email;

Make_Sale(this.name, this.email, this.phone);

  final Store<AppState> store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState.initial()
  );
  @override
  _Make_SaleState createState() => _Make_SaleState();
}

class _Make_SaleState extends State<Make_Sale> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    widget.store.dispatch(loadCategoryFiltersForResults());
    return StoreProvider(
        store: widget.store,
        child: MaterialApp(
          title: 'Searchable, Selectable List',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: CategoryFilterWidget(),
        )
    );
  }
}