/**
 * use inhertance concept to inherit from libraryItem class and implement from Reservable interface
 * use encapsulation concept to protect the data form modification by make it private and use setter/getter
 * use polymorphism by override the abstract methods in LibraryItem and Reservable
 */

import '../reservable.dart';
import 'item_category.dart';
import 'library_item.dart';
import '../validation_helper.dart';
import 'reserve.dart';

class Book extends LibraryItem with Reserve implements Reservable{
  String _author;
  String _isbn;
  int _pages;

  Book({
    required String title,
    required int publishYear,
    required String author,
    required String isbn,
    required int pages})
    :_author=author,
    _isbn=isbn,
    _pages=pages,
    super(title:title,publishYear: publishYear,category: ItemCategory.book ){
       ValidationHelper.positiveValidation(pages, "pages"); }
  
  Book.fromMap(Map<String,dynamic> bookMap)
      :_author=bookMap['author']as String,
       _isbn=bookMap['isbn'] as String,
       _pages=bookMap['pages'] as int ,
       super(title: bookMap['title']as String,publishYear: bookMap["publishYear"]as int,category: ItemCategory.book ){
          ValidationHelper.positiveValidation(pages, "pages"); 
       }

  
 String get author=>_author;
 String get isbn => _isbn;
 int get pages => _pages;
 
  set author (String author)=> _author=author;
  set isbn (String isbn)=> _isbn=isbn;
  set pages (int pages) {
       ValidationHelper.positiveValidation(pages, "pages");    
    _pages=pages;}
 
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
