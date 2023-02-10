import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parcel_app/widgets/progress_widget.dart';
import 'package:google_maps_webservice/places.dart' as webservice;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GooglePage extends StatefulWidget {
  const GooglePage({Key? key}) : super(key: key);

  @override
  State<GooglePage> createState() => _GooglePageState();
}

class _GooglePageState extends State<GooglePage> {
  late GoogleMapController mapController;
  CameraPosition? cameraPosition;
  List<webservice.PlacesSearchResult> places = [];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng? _firstPosition;
  bool _isLoading = true;
  String? address;
  late String locationSearch;

  @override
  void initState() {
    getFirstLocation();

    super.initState();
  }

  getFirstLocation() async {
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    LatLng location = LatLng(lat, long);

    setState(() {
      _firstPosition = location;
      _isLoading = false;
    });
    _getNearbyPlaces(lat, long);
  }

  void _getNearbyPlaces(double lat, double lng) async {
    var x = dotenv.env["googleAPIKey"];
    final location = webservice.Location(lat: lat, lng: lng);
    webservice.GoogleMapsPlaces _places =
        webservice.GoogleMapsPlaces(apiKey: dotenv.env['googleAPIKey']);

    final result = await _places.searchNearbyWithRadius(location, 15000,
        name: "Paczkomat");

    setState(() {
      if (result.status == "OK") {
        places = result.results;
        places.forEach((element) {
          MarkerId markerId = MarkerId(element.vicinity!);

          final Marker marker = Marker(
              markerId: markerId,
              position: LatLng(element.geometry!.location.lat,
                  element.geometry!.location.lng),
              infoWindow:
                  InfoWindow(title: element.name, snippet: element.vicinity),
              icon: BitmapDescriptor.defaultMarker,
              onTap: () {
                address = element.vicinity;
              });

          setState(() {
            markers[markerId] = marker;
          });
        });
      }
      print(result.status);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    locationSearch = AppLocalizations.of(context)!.searchLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chooseParcelMachine),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? CustomCircularProgressIndicator(
              color: Theme.of(context).primaryColor)
          : Stack(children: [
              GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _firstPosition!,
                    zoom: 12.0,
                  ),
                  onCameraMove: (CameraPosition cameraPositiona) {
                    cameraPosition = cameraPositiona;
                  },
                  onCameraIdle: () async {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        cameraPosition!.target.latitude,
                        cameraPosition!.target.longitude);
                    setState(() {
                      locationSearch =
                          '${placemarks.first.administrativeArea.toString()},${placemarks.first.street.toString()}';
                    });
                  },
                  markers: Set<Marker>.of(markers.values)),
              Positioned(
                  //search input bar
                  top: 10,
                  child: InkWell(
                      onTap: () async {
                        var place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: dotenv.env['googleAPIKey'],
                            mode: Mode.overlay,
                            language: 'en',
                            types: [],
                            strictbounds: false,
                            components: [
                              webservice.Component(
                                  webservice.Component.country, "pl"),
                            ],
                            //google_map_webservice package
                            onError: (err) {
                              print(err);
                            });

                        if (place != null) {
                          setState(() {
                            locationSearch = place.description.toString();
                          });

                          //form google_maps_webservice package
                          final plist = webservice.GoogleMapsPlaces(
                            apiKey: dotenv.env['googleAPIKey'],
                            apiHeaders:
                                await const GoogleApiHeaders().getHeaders(),
                            //from google_api_headers package
                          );
                          String placeid = place.placeId ?? "0";
                          final detail =
                              await plist.getDetailsByPlaceId(placeid);
                          final geometry = detail.result.geometry!;
                          final lat = geometry.location.lat;
                          final lang = geometry.location.lng;
                          var newlatlang = LatLng(lat, lang);

                          //move map camera to selected place with animation
                          mapController.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: newlatlang, zoom: 14)));

                          markers.clear();

                          _getNearbyPlaces(lat, lang);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Card(
                          child: Container(
                              padding: const EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width - 40,
                              child: ListTile(
                                title: Text(
                                  locationSearch,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                trailing: const Icon(Icons.search),
                                dense: true,
                              )),
                        ),
                      )))
            ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Navigator.pop(context, address);
          }),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
