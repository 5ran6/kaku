class stockList {
  List<items> itemsList;

  stockList(this.itemsList);

  Map toJson() {
    List<Map> itemListed = this.itemsList != null
        ? this.itemsList.map((i) => i.toJson()).toList()
        : null;

    return {'stockList': itemListed};
  }
}

class items {
  String stock_id;
  int quantity;

  items(this.stock_id, this.quantity);

  Map toJson() => {
        'stock_id': stock_id,
        'quantity': quantity,
      };
}
