/**
 * use inhertance concept to inherit from Member class 
 * use polymorphism by override the abstract methods in Member
 */

import '../enums.dart';
import 'member.dart';

class StudentMember extends Member{
  StudentMember({
    required super.name,
    required super.phone,
    required super.email,
    super.type=MemberType.studentMember
    });
 
  @override
  double discountOnFines() {
    double discount=0;
    return discount;
    }

  @override
  int maxBorrowLimit() {
     int items=3;
    return items;
      }
}