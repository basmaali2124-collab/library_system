import '../searchable.dart';
import 'item_category.dart';
import 'item_status.dart';
import '../validation_helper.dart';

abstract class LibraryItem with Searchable implements Comparable<LibraryItem> {
  static int _counter = 0;
  final int _id;
  String _title;
  int _publishYear;
  ItemCategory _category;
  ItemStatus _status;

  LibraryItem({
    required String title,
    required int publishYear,
    required ItemCategory category,
  })  : _id = ++_counter,
        _title = title,
        _category = category,
        _status = ItemStatus.available,
        _publishYear = publishYear {
    ValidationHelper.positiveValidation(publishYear, "publish year");
    ValidationHelper.yearValidation(publishYear);
  }

  static int byTitle(LibraryItem a, LibraryItem b) =>
      a.title.toLowerCase().compareTo(b.title.toLowerCase());

  static int byYear(LibraryItem a, LibraryItem b) =>
      a.publishYear.compareTo(b.publishYear);

  @override
  int compareTo(LibraryItem other) => byTitle(this, other);

  @override
  bool operator ==(Object other) => other is LibraryItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => "$runtimeType #$id: $title ($publishYear)";

  int get id => _id;
  String get title => _title;
  int get publishYear => _publishYear;
  ItemCategory get category => _category;
  ItemStatus get status => _status;

  set title(String title) {
    _title = title;
  }

  set publishYear(int publishYear) {
    ValidationHelper.positiveValidation(publishYear, "publish year");
    ValidationHelper.yearValidation(publishYear);
    _publishYear = publishYear;
  }

  int loanPeriodDays();
  double finePerDay();
  void displayInfo();

  void markBorrowed() => _status = ItemStatus.borrowed;
  void markReserved() => _status = ItemStatus.reserved;
  void markAvailable() => _status = ItemStatus.available;

  bool get isAvailable => status == ItemStatus.available;
}