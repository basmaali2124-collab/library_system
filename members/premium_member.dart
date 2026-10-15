
import '../exceptions.dart';
import 'member_type.dart';
import 'member.dart';

class PremiumMember extends Member {
  DateTime _subscriptionEndDate;

  PremiumMember({
    required DateTime subscriptionEndDate,
    required String name,
    required String phone,
    required String email,
  })  : _subscriptionEndDate = subscriptionEndDate,
        super(
          name: name,
          phone: phone,
          email: email,
          type: MemberType.premiumMember,
        );

  DateTime get subscriptionEndDate => _subscriptionEndDate;

  set subscriptionEndDate(DateTime subscriptionEndDate) {
    _subscriptionEndDate = subscriptionEndDate;
  }

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
