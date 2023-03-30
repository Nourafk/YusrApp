import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String googleApikey = "AIzaSyBrMEnPRhkwUkMAwxVZtFHOA7e3w2Mj9bA";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(24.724945, 46.768963);
  String location = "حرك لتحديد موقعك";
  String selectedLocation = "";
  double lat = 0.0;
  double long = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'حرك لتحديد موقعك',
            style: TextStyle(
                color: Color(0XFFd7ab65),
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'Tajawal'),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0XFFd7ab65),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          // backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Stack(children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: startLocation, //initial position
              zoom: 12.0, //initial zoom level
            ),
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (CameraPosition cameraPositiona) {
              cameraPosition = cameraPositiona; //when map is dragging
            },
            onCameraIdle: () async {
              //when map drag stops
              setState(() {
                lat = 0.0;
                long = 0.0;
              });

              List<Placemark> placemarks = await placemarkFromCoordinates(
                  cameraPosition!.target.latitude,
                  cameraPosition!.target.longitude);
              setState(() {
                //get place name from lat and lang
                location = placemarks.first.administrativeArea.toString() +
                    ", " +
                    placemarks.first.street.toString();
                lat = cameraPosition!.target.latitude;
                long = cameraPosition!.target.longitude;
              });
            },
          ),
          Center(
            //picker image on google map
            child: Image.asset(
              "assets/picker.png",
              width: 50,
            ),
          ),
          Positioned(
              //widget to display location name
              bottom: 70,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            leading: Image.asset(
                              "assets/picker.png",
                              width: 25,
                            ),
                            title: Text(
                              location,
                              style: TextStyle(fontSize: 18),
                            ),
                            dense: true,
                          )),
                      InkWell(
                        onTap: lat != 0.0 && long != 0.0
                            ? () {
                                List<dynamic> list = [lat, long, location];
                                Navigator.pop(context, list);
                              }
                            : null,
                        child: Container(
                            padding: EdgeInsets.all(0),
                            color: lat != 0.0 && long != 0.0
                                ? Color(0XFFd7ab65)
                                : Colors.grey,
                            width: MediaQuery.of(context).size.width - 40,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'موافق',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Tajawal'),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ))
        ]));
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: CupertinoActivityIndicator(animating: true),
          ),
        );
      },
    );
  }
}
