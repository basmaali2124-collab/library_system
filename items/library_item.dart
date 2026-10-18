import '../searchable.dart';
import '../validation_helper.dart';
import '../enums.dart';

abstract class LibraryItem with Searchable implements Comparable<LibraryItem> {
  static int _counter = 0;
  final int _id;
  String title;
  int publishYear;
  ItemCategory category;
  ItemStatus status;

  LibraryItem({
    required this.title,
    required this.publishYear,
    required this.category,
    this.status= ItemStatus.available
  })  : _id = ++_counter {
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
  

  

  int loanPeriodDays();
  double finePerDay();
  void displayInfo();

  void markBorrowed() => status = ItemStatus.borrowed;
  void markReserved() => status = ItemStatus.reserved;
  void markAvailable() => status = ItemStatus.available;

  bool get isAvailable => status == ItemStatus.available;
}