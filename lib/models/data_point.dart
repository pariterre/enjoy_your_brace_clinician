import 'package:enhanced_containers/enhanced_containers.dart';

abstract class DataPoint extends ItemSerializable {
  final DateTime date;
  final double value;

  DataPoint(this.value, {DateTime? date}) : date = date ?? DateTime.now();

  DataPoint.deserialize(map)
      : value = map['value'],
        date = DateTime.fromMillisecondsSinceEpoch(map['date']);

  @override
  Map<String, dynamic> serializedMap() {
    return {
      'date': date.millisecondsSinceEpoch ~/ 1000 ~/ 60,
      'value': value,
    };
  }

  ///
  /// This method interprets the data to evaluate if the scoliosis brace is on
  bool get isBraceOn;
}
