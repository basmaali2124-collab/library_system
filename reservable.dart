import 'members/member.dart';

abstract interface class Reservable {
void reserve(Member m );
void cancelReservation();
}