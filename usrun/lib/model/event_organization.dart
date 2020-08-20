import 'package:usrun/core/define.dart';
import 'package:usrun/model/mapper_object.dart';
import 'package:usrun/util/reflector.dart';

@reflector
class EventOrganization with MapperObject {
  int organizationId;
  String name;
  String avatar;
  String website;
  String description;
  SponsorType sponsorType;

  EventOrganization({
    this.organizationId,
    this.name,
    this.avatar,
    this.website,
    this.description,
    this.sponsorType,
  });
}
