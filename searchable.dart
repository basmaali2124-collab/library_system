import 'items/item_category.dart';

mixin Searchable {
  String get title;
  ItemCategory get category;

  bool matches(String keyword) {
  String k = keyword.toLowerCase();

    if (title.toLowerCase().contains(k)) {
      return true;
    }
    if (category.name.toLowerCase().contains(k)) {
      return true;
    }
    return false; }
}