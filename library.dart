import 'exceptions.dart';
import 'items/book.dart';
import 'items/item_category.dart';
import 'items/item_status.dart';
import 'items/library_item.dart';
import 'items/reserve.dart';
import 'loan.dart';
import 'loan_status.dart';
import 'loggable.dart';
import 'members/member.dart';
import 'transaction.dart';

class Library with Loggable {
  String _name;
  final List<LibraryItem> _items;
  final List<Member> _members;
  final List<Loan> _loans;
  final List<Transaction> _transactions;

  Library({required String name})
      : _name = name,
        _items = [],
        _loans = [],
        _members = [],
        _transactions = [];

  String get name => _name;
  List<LibraryItem> get items => List.unmodifiable(_items);
  List<Member> get members => List.unmodifiable(_members);
  List<Loan> get loans => List.unmodifiable(_loans);
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  List<LibraryItem> get reservations =>
      _items.where((i) => i is Reserve && i.reservedBy != null).toList();

  set name(String name) => _name = name;

  double get totalFines =>
      _members.fold(0.0, (sum, member) => sum + member.finesBalance);

  void _record(
    Member member,
    TransactionType type, {
    LibraryItem? item,
    double? amount,
    DateTime? date,
  }) {
    final t = Transaction(
      type: type,
      memberId: member.id,
      itemId: item?.id,
      amount: amount,
      date: date,
    );
    _transactions.add(t);
    member.recordTransaction(t);
  }

  void addItem(LibraryItem item) {
    _items.add(item);
    log("Item added: ${item.title} (ID ${item.id})");
  }

  void registerMember(Member member) {
    _members.add(member);
    log("Member registered: ${member.name} (ID ${member.id})");
  }

  LibraryItem findItem(int id) {
    for (LibraryItem item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    throw ItemNotFoundException();
  }

  Member findMember(int id) {
    for (Member member in _members) {
      if (member.id == id) {
        return member;
      }
    }
    throw ValidationException("This member was not found");
  }

  List<LibraryItem> search({
    String? title,
    String? author,
    ItemCategory? category,
    String? keyword,
  }) {
    final found = _items.where((item) {
      if (title != null &&
          !item.title.toLowerCase().contains(title.toLowerCase())) {
        return false;
      }
      if (author != null) {
        if (item is! Book ||
            !item.author.toLowerCase().contains(author.toLowerCase())) {
          return false;
        }
      }
      if (category != null && item.category != category) {
        return false;
      }
      if (keyword != null && !item.matches(keyword)) {
        return false;
      }
      return true;
    }).toList();

    log("Search found ${found.length} item(s)");
    return found;
  }

  void borrowItem(Member member, LibraryItem item) {
    bool isReservedForMember() {
      return item is Reserve &&
          item.status == ItemStatus.reserved &&
          item.reservedBy == member;
    }

    if (!item.isAvailable && !isReservedForMember()) {
      throw ItemNotAvailableException();
    }

    if (member.finesBalance > 100) {
      throw UnpaidFinesException();
    }

    if (member.loans.length >= member.maxBorrowLimit()) {
      throw BorrowLimitExceededException();
    }

    item.markBorrowed();

    if (item is Reserve && isReservedForMember()) {
      item.cancelReservation();
    }

    Loan loan = Loan(item: item, member: member);

    member.addLoan(loan);
    _loans.add(loan);
    _record(member, TransactionType.borrow, item: item);

    log(
      "${member.name} borrowed ${item.title}, "
      "due ${loan.dueDate.toString().substring(0, 10)}",
    );
  }

  void returnItem(Member member, Loan loan, {DateTime? returnDate}) {
    if (!_loans.contains(loan)) {
      throw ValidationException("This loan does not exist in this library");
    }

    if (loan.member != member) {
      throw ValidationException(
        "${member.name} did not borrow ${loan.item.title}",
      );
    }

    loan.returnedItemDate(returnDate);

    if (loan.daysLate() > 0) {
      member.addFine(loan.item.finePerDay(), loan.daysLate());
      log("Fine added to ${member.name}, balance: ${member.finesBalance}");
    }

    member.removeLoan(loan);

    LibraryItem item = loan.item;

    if (item is Reserve && item.reservedBy != null) {
      item.markReserved();
      log("${item.title} is now reserved for ${item.reservedBy!.name}");
    } else {
      item.markAvailable();
    }

    _record(member, TransactionType.returnItem, item: item, date: returnDate);

    log(
      "${member.name} returned ${item.title}, "
      "days late: ${loan.daysLate()}",
    );
  }

  void reserveItem(Member member, LibraryItem item) {
    if (item is! Reserve) {
      throw ReservationNotAllowedException();
    }

    if (item.reservedBy == member) {
      throw ReservationNotAllowedException();
    }

    if (item.reservedBy != null) {
      throw ReservationNotAllowedException();
    }

    for (Loan loan in _loans) {
      if (loan.member == member &&
          loan.item == item &&
          loan.status == LoanStatus.active) {
        throw ReservationNotAllowedException();
      }
    }

    item.reserve(member);
    _record(member, TransactionType.reserve, item: item);
    log("${member.name} reserved ${item.title}");
  }

  void renewLoan(Loan loan) {
    if (!_loans.contains(loan)) {
      throw ValidationException("This loan was not found");
    }

    loan.renew();
    _record(loan.member, TransactionType.renew, item: loan.item);

    log(
      "${loan.member.name} renewed ${loan.item.title}, "
      "new due ${loan.dueDate.toString().substring(0, 10)}",
    );
  }

  void payFine(Member member, double amount) {
    member.payFine(amount);
    _record(member, TransactionType.finePayment, amount: amount);
    log("${member.name} paid $amount EGP, remaining: ${member.finesBalance}");
  }

  List<Loan> overdueLoans() => _loans
      .where((l) => l.status == LoanStatus.active && l.isOverdue)
      .toList();

  void displayReport() {
    final available = _items.where((i) => i.status == ItemStatus.available);
    final borrowed = _items.where((i) => i.status == ItemStatus.borrowed);
    final reserved = _items.where((i) => i.status == ItemStatus.reserved);
    final overdue = overdueLoans().map((l) => l.item);

    String names(Iterable<LibraryItem> xs) =>
        xs.isEmpty ? "-" : xs.map((i) => i.title).join(', ');

    print("_____Library Report_____");
    print("Available: ${names(available)}");
    print("Borrowed : ${names(borrowed)}");
    print("Reserved : ${names(reserved)}");
    print("Overdue  : ${names(overdue)}");
    print("Total fines: $totalFines EGP");
  }
}