/**
 * use inhertance concept to inherit from Member class 
 * use encapsulation concept to protect the data form modification by make it private and use setter/getter
 * use polymorphism by override the abstract methods in Member
 */
import 'member_type.dart';
import 'member.dart';

class StaffMember extends Member{
  String _department;
  StaffMember({
    required  String department,
    required String name,
    required String phone,
    required String email,
    }):_department=department,super(name: name,phone: phone,email: email,type: MemberType.staffMember);
 
  String get department=>_department;
  set department(String department){
    _department=department;
  }
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