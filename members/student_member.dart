/**
 * use inhertance concept to inherit from Member class 
 * use polymorphism by override the abstract methods in Member
 */
import 'member_type.dart';
import 'member.dart';

class StudentMember extends Member{
  StudentMember({
    required String name,
    required String phone,
    required String email,
    }):super(name: name,phone: phone,email: email,type: MemberType.studentMember);
 
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