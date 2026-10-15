
import '../exceptions.dart';
import '../members/member.dart';
import 'item_status.dart';
import 'library_item.dart';

mixin Reserve on LibraryItem {
  Member? _reservedBy;

  Member? get reservedBy => _reservedBy;

  void reserve(Member m) {
    if (status == ItemStatus.available) {
      throw ReservationNotAllowedException();
    }

    if (_reservedBy != null) {
      throw ReservationNotAllowedException();
    }

    _reservedBy = m;
  }

  void cancelReservation() {
    _reservedBy = null;
  }
}
