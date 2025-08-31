import 'package:flutter/material.dart';

void main() {
  runApp(TransportRouteGame());
}

class TransportRouteGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Transport Route Game",
      theme: ThemeData.dark(),
      home: VehicleSelectionScreen(),
    );
  }
}

class VehicleSelectionScreen extends StatelessWidget {
  final vehicles = [
    {"name": "Bike", "icon": Icons.pedal_bike, "multiplier": 0.5},
    {"name": "Car", "icon": Icons.directions_car, "multiplier": 1.0},
    {"name": "Truck", "icon": Icons.local_shipping, "multiplier": 1.5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Choose Your Vehicle 🚘")),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final v = vehicles[index];
          return Card(
            color: Colors.blueGrey.shade900,
            child: ListTile(
              leading: Icon(v["icon"] as IconData,
                  color: Colors.orange, size: 40),
              title: Text(v["name"] as String,
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              subtitle: Text(
                  "Cost x${v["multiplier"]}, Speed factor x${(2 - (v["multiplier"] as double))}",
                  style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RouteGameScreen(vehicle: v),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class RouteGameScreen extends StatefulWidget {
  final Map vehicle;
  RouteGameScreen({required this.vehicle});

  @override
  _RouteGameScreenState createState() => _RouteGameScreenState();
}

class _RouteGameScreenState extends State<RouteGameScreen> {
  Offset vehiclePos = Offset(100, 150); // starting pos at city A
  String currentCity = "A";

  final cities = {
    "A": Offset(100, 150),
    "B": Offset(280, 120),
    "C": Offset(180, 300),
    "D": Offset(350, 280),
  };

  void moveVehicle(String city) {
    setState(() {
      vehiclePos = cities[city]!;
      currentCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Route Game - ${widget.vehicle["name"]}"),
      ),
      body: Stack(
        children: [
          // Cities
          ...cities.entries.map((entry) {
            return Positioned(
              left: entry.value.dx - 25,
              top: entry.value.dy - 25,
              child: GestureDetector(
                onTap: () => moveVehicle(entry.key),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(entry.key,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }),

          // Vehicle (animated)
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            left: vehiclePos.dx - 20,
            top: vehiclePos.dy - 20,
            child: Icon(widget.vehicle["icon"] as IconData,
                size: 40, color: Colors.yellowAccent),
          ),

          // HUD
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white10,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text("Current City: $currentCity",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text("Vehicle: ${widget.vehicle["name"]}",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
