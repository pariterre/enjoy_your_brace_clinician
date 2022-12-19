enum ExpectedWearingTime { good, bad }

extension ExpectedWearingTimeWithValues on ExpectedWearingTime {
  int get id {
    switch (this) {
      case ExpectedWearingTime.good:
        return 21;
      case ExpectedWearingTime.bad:
        return 12;
      default:
        return -1;
    }
  }
}

enum MoodDataLevel { none, veryBad, poor, medium, good, excellent }

extension MoodDataLevelPath on MoodDataLevel {
  static MoodDataLevel fromDouble(value) {
    return MoodDataLevel.values[value.round()];
  }

  String get path {
    switch (this) {
      case MoodDataLevel.excellent:
        return 'assets/excellent.png';
      case MoodDataLevel.good:
        return 'assets/good.png';
      case MoodDataLevel.medium:
        return 'assets/medium.png';
      case MoodDataLevel.poor:
        return 'assets/poor.png';
      case MoodDataLevel.veryBad:
        return 'assets/veryBad.png';
      default:
        return '';
    }
  }
}
