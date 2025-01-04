import 'package:flutter/material.dart';
import 'package:innovatika/database/informer_hardware.dart';
import 'package:innovatika/database/informer_plant.dart';
import 'package:innovatika/widget/appbar.dart';
import 'package:innovatika/widget/loading.dart';
import 'package:realm/realm.dart';

class ViewDevice extends StatefulWidget {
  final Hardware hardware;
  const ViewDevice({super.key, required this.hardware});

  @override
  State<ViewDevice> createState() => _ViewDeviceState();
}

class _ViewDeviceState extends State<ViewDevice> {
  int moisture = 0;
  int temperature = 0;
  int humidity = 0;
  String _message = "Moderately Wet";

  Future<PlantInformer?> fetchPlantById(int plantId) async {
    print(plantId);
    print(widget.hardware.id);
    // Open a Realm instance
    var config =
        await Realm.open(Configuration.local(([PlantInformer.schema])));

    // Fetch the plant with the given ID from MongoDB Realm
    var plant = config.find<PlantInformer>(plantId);
    return plant;
  }

  @override
  Widget build(BuildContext context) {
    if (moisture > 0 && moisture < 500) {
      _message = "Very Wet";
    } else if (moisture > 500 && moisture < 1200) {
      _message = "Moderately Wet";
    } else if (moisture > 1200 && moisture < 2500) {
      _message = "Moist";
    } else if (moisture > 2500 && moisture < 3800) {
      _message = "Dry";
    } else if (moisture > 3800) {
      _message = "Very Dry";
    }
    return Scaffold(
      appBar: commonApp(
        context: context,
        title: widget.hardware.name,
      ),
      body: FutureBuilder(
        future: fetchPlantById(widget.hardware.plantAssociated),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return emptyLoading("No Plants found");
          }
          if (snapshot.hasData) {
            var plant = snapshot.data;
            if (plant == null) {
              return emptyLoading("No Plants found");
            }
            // if (widget.hardware.id == widget.hardware.plantAssociated) {
            return ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.network(
                                plant.image,
                                fit: BoxFit.cover,
                                height: 200, // Set a fixed height
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _message,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.network(
                                plant.image,
                                fit: BoxFit.cover,
                                height: 200, // Set a fixed height
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _message,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.network(
                                plant.image,
                                fit: BoxFit.cover,
                                height: 200, // Set a fixed height
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _message,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.network(
                                plant.image,
                                fit: BoxFit.cover,
                                height: 200, // Set a fixed height
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plant.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _message,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
            // } else {
            //   return emptyLoading("Not Found!");
            // }
          } else {
            return LoadingDeviceAnimation();
          }
        },
      ),
    );
  }
}
