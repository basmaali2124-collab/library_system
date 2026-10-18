/**
 * use inhertance concept to inherit from Member class 
 * use encapsulation concept to protect the data form modification by make it private and use setter/getter
 * use polymorphism by override the abstract methods in Member
 */

import '../enums.dart';
import 'member.dart';

class StaffMember extends Member{
  String department;
  StaffMember({
    required this.department,
    required super.name,
    required super.phone,
    required super.email,
    super.type=MemberType.staffMember
    });
  @override
  double discountOnFines() {
    double discount=50;
    return discount;
    }

  @override
  int maxBorrowLimit() {
     int items=5;
    return items;
      }

}