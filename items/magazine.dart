/**
 * use inhertance concept to inherit from libraryItem class 
 * use encapsulation concept to protect the data form modification by make it private and use setter/getter
 * use polymorphism by override the abstract methods in LibraryItem 
 */
import '../enums.dart';
import 'library_item.dart';
import '../validation_helper.dart';

class Magazine extends LibraryItem {
  Months _month;
  int _issueNumber;

  Magazine({
    required String title,
    required int publishYear,
    required Months month,
    required int issueNumber,
  }) : _month = month,
       _issueNumber = issueNumber,
       super(
         title: title,
         publishYear: publishYear,
         category: ItemCategory.magazine,
       ){
         ValidationHelper.positiveValidation(issueNumber, "issue number");
       }

  Months get month => _month;
  int get issueNumber => _issueNumber;

  set month(Months month) => _month = month;
  set issueNumber(int issueNumber) {
      ValidationHelper.positiveValidation(issueNumber, "issue number");    
     _issueNumber = issueNumber;}

  @override
  int loanPeriodDays() {
    int days = 7;
    return days;
  }

  @override
  double finePerDay() {
    double fine = 3;
    return fine;
  }

  @override
  void displayInfo() {
    print(
      " Magazine Title :${super.title}\n Issue Number :$issueNumber\n Publish Year : ${super.publishYear}\n Month : $month\n Status : ${super.status}",
    );
  }
}
