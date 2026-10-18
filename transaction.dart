enum TransactionType { borrow, returnItem, renew, reserve, finePayment }

class Transaction {
  static int _counter = 0;

  final int id;
  final TransactionType type;
  final int memberId;
  final int itemId;
  final double amount;
  final DateTime date;

  Transaction({
    required this.type,
    required this.memberId,
    required this.itemId,
    required this.amount,
    required this.date,
  }) : id = ++_counter;

  @override
  String toString() =>
      "#$id ${type.name} | member $memberId"
      " | item $itemId"
      " | $amount EGP"
      " | ${date.toString().substring(0, 16)}";
}