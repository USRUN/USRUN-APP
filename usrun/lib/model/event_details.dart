import 'package:usrun/model/mapper_object.dart';

class EventDetails with MapperObject {
  String introduction;
  String rewards;
  String additionalInfo;
  String rules;

  EventDetails({
    this.introduction,
    this.rewards,
    this.additionalInfo,
    this.rules,
  });
}
