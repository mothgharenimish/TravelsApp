//Single Lowwr Seats
class SingleLower {
 final String seatnumber;

  SingleLower({required this.seatnumber});
}

List<SingleLower> singleLowerList = [
  SingleLower(seatnumber: "LS1"),
  SingleLower(seatnumber: "LS2"),
  SingleLower(seatnumber: "LS3"),
  SingleLower(seatnumber: "LS4"),
  SingleLower(seatnumber: "LS5"),
];

//Double Lower Seats
class DoubleLowerSeat {
  final String leftSeatNumber;
  final String rightSeatNumber;

  DoubleLowerSeat({
    required this.leftSeatNumber,
    required this.rightSeatNumber,
  });
}

List<DoubleLowerSeat> doubleLowerList = [

  DoubleLowerSeat(leftSeatNumber: "LD6", rightSeatNumber: "LD7"),
  DoubleLowerSeat(leftSeatNumber: "LD8", rightSeatNumber: "LD9"),
  DoubleLowerSeat(leftSeatNumber: "LD10", rightSeatNumber: "LD11"),
  DoubleLowerSeat(leftSeatNumber: "LD12", rightSeatNumber: "LD13"),
  DoubleLowerSeat(leftSeatNumber: "LD14", rightSeatNumber: "LD15"),
];

//Single Upper Seats
class SingleUpper {
  final String seatnumber;

  SingleUpper({required this.seatnumber});

}
List<SingleUpper> singleUpperList = [
  SingleUpper(seatnumber: "US1"),
  SingleUpper(seatnumber: "US2"),
  SingleUpper(seatnumber: "US3"),
  SingleUpper(seatnumber: "uS4"),
  SingleUpper(seatnumber: "US5"),
];

//Double Upper Seats
class DoubleUpperSeat {
  final String leftSeatNumber;
  final String rightSeatNumber;

  DoubleUpperSeat({
    required this.leftSeatNumber,
    required this.rightSeatNumber,
  });
}


List<DoubleUpperSeat> doubleUpperList = [

  DoubleUpperSeat(leftSeatNumber: "UD6", rightSeatNumber: "UD7"),
  DoubleUpperSeat(leftSeatNumber: "UD8", rightSeatNumber: "UD9"),
  DoubleUpperSeat(leftSeatNumber: "UD10", rightSeatNumber: "UD11"),
  DoubleUpperSeat(leftSeatNumber: "UD12", rightSeatNumber: "UD13"),
  DoubleUpperSeat(leftSeatNumber: "UD14", rightSeatNumber: "UD15"),
];