import 'data_point.dart';

class TemperatureDataPoint extends DataPoint {
  TemperatureDataPoint(super.value, {super.date});

  static const double threshold = 25;

  @override
  bool get isBraceOn => value >= threshold;
}
