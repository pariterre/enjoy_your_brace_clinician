import 'package:enhanced_containers/enhanced_containers.dart';
import 'package:enjoy_your_brace_clinician/models/enums.dart';

class Mood extends ItemSerializable {
  MoodDataLevel value;

  Mood(this.value);

  @override
  Map<String, dynamic> serializedMap() => {'value': value};

  Mood.deserialize(map) : value = map['value'];
}
