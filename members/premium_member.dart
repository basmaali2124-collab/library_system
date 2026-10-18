
import '../enums.dart';
import '../exceptions.dart';
import 'member.dart';

class PremiumMember extends Member {
  DateTime subscriptionEndDate;

  PremiumMember({
    required this.subscriptionEndDate,
    required super.name,
    required super.phone,
    required super.email,
    super.type=MemberType.premiumMember
  });


  @override
  double discountOnFines() {
    return 0;
  }

  @override
  int countdaysLate(int daysLate) {
    if (daysLate < 0) {
      throw ValidationException("Days cannot be negative");
    }

    if (daysLate > 2) {
      return daysLate - 2;
    }

    return 0;
  }

  @override
  int maxBorrowLimit() {
    return 10;
  }
}
