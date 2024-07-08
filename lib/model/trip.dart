class Trip {
  final String startPoint;
  final String endPoint;
  final String date;
  final String vehicleDetail;
  final String seat;

  Trip({
    required this.startPoint,
    required this.endPoint,
    required this.date,
    required this.vehicleDetail,
    required this.seat,
  });

  Map<String, dynamic> toMap() {
    return {
      'start point': startPoint,
      'end point': endPoint,
      'date': date,
      'vehicle detail': vehicleDetail,
      'seat': seat,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      startPoint: map['start point'] ?? '',
      endPoint: map['end point'] ?? '',
      date: map['date'] ?? '',
      vehicleDetail: map['vehicle detail'] ?? '',
      seat: map['seat'] ?? '',
    );
  }
}
