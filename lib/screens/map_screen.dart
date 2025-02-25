import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // ใช้หาตำแหน่ง GPS
import 'package:google_maps_flutter/google_maps_flutter.dart'; // ใช้แสดงแผนที่

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  MapsPageState createState() => MapsPageState();
}

class MapsPageState extends State<MapsScreen> {
  //MapsPage เป็น StatefulWidget เพราะตำแหน่งของผู้ใช้เปลี่ยนแปลงได้
  Position? userLocation; // เก็บตำแหน่งปัจจุบันของผู้ใช้
  GoogleMapController? mapController; // ควบคุมแผนที่

  void _onMapCreated(GoogleMapController controller) {
    //_onMapCreated กำหนด GoogleMapController เมื่อแผนที่ถูกโหลด
    mapController = controller; // เก็บ controller เมื่อสร้างแผนที่
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled(); // เช็คว่าเปิด GPS หรือไม่
    if (!serviceEnabled) {
      return;
    }

    permission =
        await Geolocator.checkPermission(); // เช็คสิทธิ์การเข้าถึงตำแหน่ง
    if (permission == LocationPermission.denied) {
      // ขอสิทธิ์หากยังไม่ได้
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ); // ดึงตำแหน่งผู้ใช้

    setState(() {
      userLocation = position;
    });

    // ย้ายกล้องไปที่ตำแหน่งผู้ใช้
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15,
        ),
      );
    }
  }

  @override
  void initState() {
    // initState() ใช้ดึงตำแหน่งของผู้ใช้ทันทีที่หน้าแผนที่โหลด
    super.initState();
    _getLocation(); // เรียกตำแหน่งผู้ใช้เมื่อเปิดหน้า
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userLocation == null
          ? Center(
              child: CircularProgressIndicator()) // โหลดตำแหน่งก่อนแสดงแผนที่
          : GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(userLocation!.latitude, userLocation!.longitude),
                zoom: 15,
              ),
            ),
      floatingActionButton: userLocation ==
              null // ปุ่ม FloatingActionButton ใช้ขยับกล้องไปยังตำแหน่งของผู้ใช้
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                if (mapController != null) {
                  mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(userLocation!.latitude, userLocation!.longitude),
                      18,
                    ),
                  );
                }
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                        'Your location has been sent!\n'
                        'Lat: ${userLocation!.latitude}, '
                        'Long: ${userLocation!.longitude}',
                      ),
                    );
                  },
                );
              },
              label: Text("Send Location"),
              icon: Icon(Icons.near_me),
            ),
    );
  }
}
