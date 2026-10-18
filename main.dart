import 'enums.dart';
import 'items/book.dart';
import 'items/dvd.dart';
import 'items/library_item.dart';
import 'items/magazine.dart';
import 'library.dart';
import 'loan.dart';
import 'members/member.dart';
import 'members/premium_member.dart';
import 'members/staff_member.dart';
import 'members/student_member.dart';

void main() {
  Library library = Library(name: "City Library");

  LibraryItem cleanCode = Book(
    title: "Clean Code",
    publishYear: 2000,
    author: "author1",
    isbn: "isbn1",
    pages: 180,
  );
  LibraryItem nationalGeographic = Magazine(
    title: "National Geographic",
    publishYear: 2001,
    month: Months.april,
    issueNumber: 1234567,
  );
  LibraryItem inception = Dvd(
    title: "Inception",
    publishYear: 2002,
    director: "director3",
    durationMinutes: 20,
  );
  library.addItem(cleanCode);
  library.addItem(nationalGeographic);
  library.addItem(inception);

  Member ahmed = StudentMember(
    name: "Ahmed",
    phone: "01000000000",
    email: "ahmed123@gmail.com",
  );
  Member mona = StaffMember(
    department: "department1",
    name: "Mona",
    phone: "01100000000",
    email: "mona123@gmail.com",
  );
  Member omar = PremiumMember(
    subscriptionEndDate: DateTime.now().add(Duration(days: 30)),
    name: "Omar",
    phone: "01110000000",
    email: "omar123@gmail.com",
  );
  library.registerMember(ahmed);
  library.registerMember(mona);
  library.registerMember(omar);

  library.borrowItem(ahmed, cleanCode);
  Loan ahmedLoan = ahmed.loans.first;

  try {
    library.borrowItem(mona, cleanCode);
  } catch (e) {
    print("Error: $e");
  }

  library.reserveItem(mona, cleanCode);

  library.borrowItem(omar, inception);
  Loan omarDvdLoan = omar.loans.first;
  library.borrowItem(omar, nationalGeographic);

  library.returnItem(
    ahmed,
    ahmedLoan,
    returnDate: ahmedLoan.dueDate.add(Duration(days: 4)),
  );
  print("Days late: ${ahmedLoan.daysLate()}");
  print("Fine balance: ${ahmed.finesBalance}");

  library.borrowItem(mona, cleanCode);

  try {
    library.reserveItem(omar, nationalGeographic);
  } catch (e) {
    print("Error: $e");
  }

  library.payFine(ahmed, 15);
  print("Fine balance: ${ahmed.finesBalance}");

  library.renewLoan(omarDvdLoan);

  print(library.search(keyword: "code").map((i) => i.title).toList());
  print(
    library
        .search(author: "author1", category: ItemCategory.book)
        .map((i) => i.title)
        .toList(),
  );

  print("_____All Library Members_____");
  final membersSorted = [...library.members]..sort();
  for (final member in membersSorted) {
    member.displayInfo();
    print("");
  }

  print("_____All Library Items (by title)_____");
  final itemsByTitle = [...library.items]..sort(LibraryItem.byTitle);
  for (final item in itemsByTitle) {
    item.displayInfo();
    print("");
  }

  print("_____All Library Items (by year)_____");
  final itemsByYear = [...library.items]..sort(LibraryItem.byYear);
  for (final item in itemsByYear) {
    item.displayInfo();
    print("");
  }

  print("_____Library Transactions_____");
  library.transactions.forEach(print);

  print("_____Ahmed Transactions_____");
  ahmed.transactions.forEach(print);

  print("");
  library.displayReport();
}