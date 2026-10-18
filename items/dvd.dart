/**
 * use inhertance concept to inherit from libraryItem class and implement from Reservable interface
 * use encapsulation concept to protect the data form modification by make it private and use setter/getter
 * use polymorphism by override the abstract methods in LibraryItem and Reservable
 */
import '../enums.dart';
import '../reservable.dart';
import 'library_item.dart';
import '../validation_helper.dart';
import 'reserve.dart';

class Dvd extends LibraryItem with Reserve implements Reservable {
  String director;
  int durationMinutes;

  Dvd({
    required super.title,
    required super.publishYear,
    super.category=ItemCategory.dvd,
    required this.director,
    required this.durationMinutes})
    {
      ValidationHelper.positiveValidation(durationMinutes, "duration minutes");
    }
 
  @override
 int loanPeriodDays() {
    int days=3;
    return days;
   }
   @override
 double finePerDay() {
    double fine =10;
    return fine;
    }
  @override
 void displayInfo() {
   print(" Dvd Title :${super.title}\n Dvd Director :$director\n Publish Year : ${super.publishYear}\n Duration Minutes : $durationMinutes\n Status : ${super.status}");
  }
  
  @override
bool matches(String keyword) {
  return super.matches(keyword) ||
         director.toLowerCase().contains(keyword.toLowerCase());
}
  
}