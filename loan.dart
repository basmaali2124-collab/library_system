
import 'exceptions.dart';
import 'items/reserve.dart';
import 'loan_status.dart';
import 'items/library_item.dart';
import 'members/member.dart';
import 'renewable.dart';

class Loan implements Renewable {
  static int _counter = 0;

  int _loanId;
  LibraryItem _item;
  Member _member;
  DateTime _borrowDate;
  late DateTime _dueDate;
  DateTime? _returnDate;
  LoanStatus _status;
  int _renewCount;

  Loan({
    required LibraryItem item,
    required Member member,
    DateTime? borrowDate,
  })  : _loanId = ++_counter,
        _item = item,
        _member = member,
        _borrowDate = borrowDate ?? DateTime.now(),
        _status = LoanStatus.active,
        _renewCount = 0 {
    _dueDate = _borrowDate.add(
      Duration(days: item.loanPeriodDays()),
    );
  }

  int get loanId => _loanId;
  LibraryItem get item => _item;
  Member get member => _member;
  DateTime get borrowDate => _borrowDate;
  DateTime? get returnDate => _returnDate;
  DateTime get dueDate => _dueDate;
  LoanStatus get status => _status;
  int get renewCount => _renewCount;

  set item(LibraryItem item) => _item = item;
  set member(Member member) => _member = member;

  DateTime returnedItemDate([DateTime? returnDate]) {
    if (_returnDate != null) {
      throw ValidationException(
        "This loan has already been returned",
      );
    }

    _returnDate = returnDate ?? DateTime.now();
    _status = LoanStatus.returned;

    return _returnDate!;
  }

  bool get isOverdue {
    DateTime checkDate = _returnDate ?? DateTime.now();

    return checkDate.difference(_dueDate).inDays > 0;
  }

  int daysLate() {
    DateTime checkDate = _returnDate ?? DateTime.now();

    if (!isOverdue) {
      return 0;
    }

    return checkDate.difference(_dueDate).inDays;
  }

  double calculateFine() {
    return item.finePerDay() * daysLate();
  }

  @override
  bool renew() {
    if (_status != LoanStatus.active) {
      throw ValidationException(
        "Only active loans can be renewed",
      );
    }

    if (isOverdue) {
      throw ValidationException(
        "Cannot renew an overdue loan",
      );
    }

    if (_renewCount >= 2) {
      throw ValidationException(
        "A loan can be renewed at most 2 times",
      );
    }

    LibraryItem currentItem = item;

    if (currentItem is Reserve &&
        currentItem.reservedBy != null) {
      throw ReservationNotAllowedException();
    }

    _renewCount++;

    _dueDate = _dueDate.add(
      Duration(days: item.loanPeriodDays()),
    );

    return true;
  }

  @override
  String toString() =>
      "Loan #$_loanId: ${_item.title} (due: $_dueDate)";
}
