import 'enums.dart';
import 'exceptions.dart';
import 'items/library_item.dart';
import 'items/reserve.dart';
import 'members/member.dart';
import 'renewable.dart';

class Loan implements Renewable {
  static int _counter = 0;

  final int loanId;
  LibraryItem item;
  Member member;
  DateTime borrowDate;
  late DateTime dueDate;
  DateTime? returnDate;
  LoanStatus status;
  int renewCount;

  Loan({
    required this.item,
    required this.member,
    this.status = LoanStatus.active,
    this.renewCount = 0,
    DateTime? borrowDate,
  })  : loanId = ++_counter,
        borrowDate = borrowDate ?? DateTime.now() {
    dueDate = this.borrowDate.add(Duration(days: item.loanPeriodDays()));
  }

  DateTime returnedItemDate([DateTime? date]) {
    if (returnDate != null) {
      throw ValidationException("This loan has already been returned");
    }

    returnDate = date ?? DateTime.now();
    status = LoanStatus.returned;

    return returnDate!;
  }

  bool get isOverdue {
    DateTime checkDate = returnDate ?? DateTime.now();
    return checkDate.difference(dueDate).inDays > 0;
  }

  int daysLate() {
    if (!isOverdue) {
      return 0;
    }
    DateTime checkDate = returnDate ?? DateTime.now();
    return checkDate.difference(dueDate).inDays;
  }

  double calculateFine() {
    return item.finePerDay() * daysLate();
  }

  @override
  bool renew() {
    if (status != LoanStatus.active) {
      throw ValidationException("Only active loans can be renewed");
    }

    if (isOverdue) {
      throw ValidationException("Cannot renew an overdue loan");
    }

    if (renewCount >= 2) {
      throw ValidationException("A loan can be renewed at most 2 times");
    }

    LibraryItem currentItem = item;

    if (currentItem is Reserve && currentItem.reservedBy != null) {
      throw ReservationNotAllowedException();
    }

    renewCount++;
    dueDate = dueDate.add(Duration(days: item.loanPeriodDays()));

    return true;
  }

  @override
  String toString() => "Loan #$loanId: ${item.title} (due: $dueDate)";
}