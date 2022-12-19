import 'package:enhanced_containers/enhanced_containers.dart';

import 'mood.dart';

class MoodList extends ListSerializable<Mood> {
  @override
  Mood deserializeItem(data) => Mood.deserialize(data);
}
