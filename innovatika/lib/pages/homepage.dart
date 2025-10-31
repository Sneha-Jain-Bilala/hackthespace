import 'dart:async';
import 'package:flutter/material.dart';
import 'package:innovatika/database/informer_hardware.dart';
import 'package:innovatika/database/informer_plant.dart';
import 'package:innovatika/pages/view_device.dart';
import 'package:innovatika/widget/associate_plant.dart';
import 'package:innovatika/widget/hardware_widget.dart';
import 'package:innovatika/widget/loading.dart';
import 'package:innovatika/widget/nav.dart';
import 'package:realm/realm.dart';
import 'package:toastification/toastification.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Realm realm;
  late StreamSubscription<RealmResultsChanges<HardwareInformerr>>
      _devicesSubscription;

  // <CHANGE> Updated color scheme to match reference design
  static const Color _primaryOrange = Color(0xFFFF6B35);
  static const Color _backgroundColor = Color(0xFFE8D5B7);
  static const Color _cardBackground = Colors.white;
  static const Color _textDark = Color(0xFF2C2C2C);
  static const Color _textLight = Color(0xFF666666);

  @override
  void initState() {
    super.initState();
    _initializeRealm();
  }

  Future<void> _initializeRealm() async {
    final openedRealm =
        await Realm.open(Configuration.local([HardwareInformerr.schema]));
    setState(() {
      realm = openedRealm;
      final devices = realm.all<HardwareInformerr>().changes;
      _devicesSubscription = devices.listen((event) => _onDevicesChanged());
    });
  }

  @override
  void dispose() {
    _devicesSubscription.cancel();
    realm.close();
    super.dispose();
  }

  void _onDevicesChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // <CHANGE> Updated background to beige color
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        // <CHANGE> Added modern app bar with orange accent
        backgroundColor: _backgroundColor,
        elevation: 0,
        title: const Text(
          'My Garden Devices',
          style: TextStyle(
            color: _textDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<RealmResultsChanges<HardwareInformerr>>(
        stream: realm.all<HardwareInformerr>().changes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var devices = snapshot.data!.results;
            if (devices.isEmpty) {
              return emptyLoading("No devices found");
            }
            // <CHANGE> Updated grid layout with better spacing and padding
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: devices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final device = devices[index];
                return _buildDeviceCard(context, device);
              },
            );
          } else {
            return LoadingDeviceAnimation();
          }
        },
      ),
    );
  }

  // <CHANGE> Extracted device card into separate method with improved design
  Widget _buildDeviceCard(BuildContext context, HardwareInformerr device) {
    return GestureDetector(
      onTap: () async {
        if (device.plantAssociated == -1) {
          var config = await Realm.open(
              Configuration.local(([PlantInformer.schema])));
          var plantt = config.all<PlantInformer>().toList();
          if (plantt.isEmpty) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flat,
              alignment: Alignment.bottomCenter,
              autoCloseDuration: const Duration(seconds: 5),
              title: const Text(
                "Add a Plant first",
                textAlign: TextAlign.center,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavBar(
                  index: 1,
                ),
              ),
            );
          } else {
            Hardware hardware =
                await HardwareManager().accessHardware(device.id);
            if (!context.mounted) return;
            associatePlant(
              context,
              plantt,
              [
                hardware.name,
                hardware.passwd,
              ],
            );
          }
        } else {
          Hardware hardware =
              await HardwareManager().accessHardware(device.id);
          if (!context.mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewDevice(
                hardware: hardware,
              ),
            ),
          );
        }
      },
      child: Container(
        // <CHANGE> Redesigned card with modern styling matching reference
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(4, 4),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              offset: const Offset(-2, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // <CHANGE> Improved header with delete button
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.spa,
                          color: _primaryOrange,
                          size: 20,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await HardwareManager()
                              .removeHardware(device.id);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // <CHANGE> Device image with better styling
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/device.jpg',
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ),
                // <CHANGE> Device name and status section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _textDark,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: device.plantAssociated != -1
                                  ? Colors.green
                                  : Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            device.plantAssociated != -1
                                ? "Active"
                                : "Unassigned",
                            style: TextStyle(
                              color: _textLight,
                              fontSize: 12,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}