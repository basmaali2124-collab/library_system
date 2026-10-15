enum TransactionType { borrow, returnItem, renew, reserve, finePayment }

class Transaction {
  static int _counter = 0;

  final int id;
  final TransactionType type;
  final int memberId;
  final int? itemId;
  final double? amount;
  final DateTime date;

  Transaction({
    required this.type,
    required this.memberId,
    this.itemId,
    this.amount,
    DateTime? date,
  })  : id = ++_counter,
        date = date ?? DateTime.now();

  @override
  String toString() =>
      "#$id ${type.name} | member $memberId"
      "${itemId != null ? ' | item $itemId' : ''}"
      "${amount != null ? ' | $amount EGP' : ''}"
      " | ${date.toString().substring(0, 16)}";
}