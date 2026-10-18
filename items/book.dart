/**
 * use inhertance concept to inherit from libraryItem class and implement from Reservable interface
 * use encapsulation concept to protect the data form modification by make it private and use setter/getter
 * use polymorphism by override the abstract methods in LibraryItem and Reservable
 */

import '../reservable.dart';
import '../enums.dart';
import 'library_item.dart';
import '../validation_helper.dart';
import 'reserve.dart';

class Book extends LibraryItem with Reserve implements Reservable{
  String author;
  String isbn;
  int pages;

  Book({
    required super.title,
    required super.publishYear,
    super.category=ItemCategory.book,
    required this.author,
    required this.isbn,
    required this.pages})
   { ValidationHelper.positiveValidation(pages, "pages"); }
  
  Book.fromMap(Map<String,dynamic> bookMap)
      :author=bookMap['author']as String,
       isbn=bookMap['isbn'] as String,
       pages=bookMap['pages'] as int ,
       super(title: bookMap['title']as String,publishYear: bookMap["publishYear"]as int,category: ItemCategory.book ){
          ValidationHelper.positiveValidation(pages, "pages"); 
       }

  @override
 int loanPeriodDays() {
    int days=14;
    return days;
   }
   @override
 double finePerDay() {
    double fine =5;
    return fine;
    }
  @override
 void displayInfo() {
   print(" Book Title :${super.title}\n Book Author :$author\n Publish Year : ${super.publishYear}\n Pages : $pages\n Status : ${super.status}");
  }
  
  @override
bool matches(String keyword) {
  return super.matches(keyword) ||
         author.toLowerCase().contains(keyword.toLowerCase());
}
}
