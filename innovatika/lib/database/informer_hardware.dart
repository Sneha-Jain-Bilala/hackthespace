import 'package:realm/realm.dart';
part 'informer_hardware.realm.dart';

@RealmModel()
class _HardwareInformerr {
  late String name;
  late String passwd;
  late String devName;
  late int plantAssociated;
  @PrimaryKey()
  late int id;
}

class Hardware {
  late int id;
  late String name;
  late String passwd;
  late String devName;
  late int plantAssociated;
  Hardware({
    required this.id,
    required this.name,
    required this.passwd,
    required this.devName,
    this.plantAssociated = -1,
  });

  factory Hardware.fromJson(Map<String, dynamic> json) {
    return Hardware(
      id: json['id'],
      name: json['name'],
      passwd: json['passwd'],
      devName: json['devName'],
      plantAssociated: json['plantAssociated'] ?? -1,
    );
  }
}
