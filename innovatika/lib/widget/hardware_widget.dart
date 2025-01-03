// No of gardens
import 'package:realm/realm.dart';
import 'package:innovatika/database/informer_hardware.dart';

class HardwareManager {
  Future<List> listDevices() async {
    final realm =
        await Realm.open(Configuration.local([HardwareInformerr.schema]));
    var devices = realm.all<HardwareInformerr>().toList();
    if (devices.isEmpty) {
      return [];
    }
    return devices;
  }

  Future<void> addHardware(Hardware hardware) async {
    final realm =
        await Realm.open(Configuration.local([HardwareInformerr.schema]));
    var garData = HardwareInformerr(
      hardware.name,
      hardware.passwd,
      hardware.devName,
      hardware.plantAssociated,
      hardware.id,
    );
    realm.write(() {
      realm.add(garData);
    });
  }

  Future<void> addGarden(int id, int plantID) async {
    final realm =
        await Realm.open(Configuration.local([HardwareInformerr.schema]));
    var garData = realm.find<HardwareInformerr>(id);
    if (garData != null) {
      realm.write(() {
        garData.plantAssociated = plantID;
      });
    }
  }

  Future<void> removeHardware(int id) async {
    final realm =
        await Realm.open(Configuration.local([HardwareInformerr.schema]));
    var garData = realm.find<HardwareInformerr>(id);
    if (garData != null) {
      realm.write(() {
        realm.delete(garData);
      });
    }
  }

  Future<Hardware> accessHardware(int id) async {
    final realm =
        await Realm.open(Configuration.local([HardwareInformerr.schema]));
    var idData = realm.find<HardwareInformerr>(id);
    if (idData != null) {
      return Hardware(
        name: idData.name,
        passwd: idData.passwd,
        devName: idData.devName,
        plantAssociated: idData.plantAssociated,
        id: idData.id,
      );
    } else {
      throw Exception('Hardware not found');
    }
  }
}
