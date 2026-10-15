import '../exceptions.dart';
import '../validation_helper.dart';
import '../loan.dart';
import '../transaction.dart';
import 'member_type.dart';
import 'student_member.dart';

abstract class Member implements Comparable<Member> {
  static int _counter = 0;

  final int _id;
  String _name;
  String _phone;
  String _email;
  MemberType _type;
  final List<Loan> _loans;
  final List<Transaction> _transactions;
  double _finesBalance;

  Member({
    required String name,
    required String phone,
    required String email,
    required MemberType type,
  })  : _id = ++_counter,
        _name = name,
        _phone = phone,
        _email = email,
        _type = type,
        _loans = [],
        _transactions = [],
        _finesBalance = 0.0 {
    ValidationHelper.phoneVlidation(phone);
    ValidationHelper.emailValidation(email);
  }

  factory Member.guest({
    required String name,
    required String phone,
  }) {
    return StudentMember(
      name: name,
      phone: phone,
      email: "guest123@gmail.com",
    );
  }

  @override
  int compareTo(Member other) =>
      name.toLowerCase().compareTo(other.name.toLowerCase());

  @override
  bool operator ==(Object other) => other is Member && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => "$runtimeType #$id ($name)";

  int get id => _id;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  MemberType get type => _type;
  List<Loan> get loans => List.unmodifiable(_loans);
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  double get finesBalance => _finesBalance;

  set name(String name) {
    _name = name;
  }

  set phone(String phone) {
    ValidationHelper.phoneVlidation(phone);
    _phone = phone;
  }

  set email(String email) {
    ValidationHelper.emailValidation(email);
    _email = email;
  }

  void addLoan(Loan loan) => _loans.add(loan);
  void removeLoan(Loan loan) => _loans.remove(loan);
  void recordTransaction(Transaction t) => _transactions.add(t);

  int maxBorrowLimit();

  double discountOnFines();

  bool canBorrow() {
    if (_loans.length >= maxBorrowLimit() || _finesBalance > 100) {
      return false;
    }
    return true;
  }

  int countdaysLate(int daysLate) {
    if (daysLate < 0) {
      throw ValidationException("Days cannot be negative");
    }
    return daysLate;
  }

  double addFine(double finePerDay, int daysLate) {
    ValidationHelper.positiveValidation(finePerDay, "fine");

    double days = countdaysLate(daysLate).toDouble();

    double totalFine =
        (finePerDay * days) - ((finePerDay * days * discountOnFines()) / 100);

    _finesBalance += totalFine;

    return _finesBalance;
  }

  double payFine(double fine) {
    if (fine <= 0 || fine > _finesBalance) {
      throw InvalidPaymentException();
    }

    _finesBalance -= fine;

    return _finesBalance;
  }

  void displayInfo() {
    print(
      "Member ID : $_id\n"
      "Type : ${_type.name}\n"
      "Name : $_name\n"
      "Phone : $_phone\n"
      "Email : $_email\n"
      "Loans : ${_loans.isEmpty ? '-' : _loans.join(" , ")}\n"
      "Fines Balance : $_finesBalance",
    );
  }
}