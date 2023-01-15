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

class GoogleSearchParcelPage extends StatefulWidget {
  String parcelAddress;

  GoogleSearchParcelPage({Key? key, required this.parcelAddress})
      : super(key: key);

  @override
  State<GoogleSearchParcelPage> createState() => _GoogleSearchParcelState();
}

class _GoogleSearchParcelState extends State<GoogleSearchParcelPage> {
  late GoogleMapController mapController;
  CameraPosition? cameraPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  LatLng? _parcelPosition;
  bool _isLoading = true;

  @override
  void initState() {
    getParcelLocation();

    super.initState();
  }

  getParcelLocation() async {
    webservice.GoogleMapsPlaces _places =
        webservice.GoogleMapsPlaces(apiKey: dotenv.env['googleAPIKey']);

    final res = await _places.searchByText(widget.parcelAddress);

    var parcel = res.results[0];

    double lat = parcel.geometry!.location.lat;
    double long = parcel.geometry!.location.lng;
    LatLng location = LatLng(lat, long);

    setState(() {
      _parcelPosition = location;
      _isLoading = false;

      MarkerId markerId = MarkerId(widget.parcelAddress);

      Marker marker = Marker(
          markerId: markerId,
          position: location,
          icon: BitmapDescriptor.defaultMarker);

      markers[markerId] = marker;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.findingParcelMachine),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? CustomCircularProgressIndicator(
              color: Theme.of(context).primaryColor)
          : Stack(children: [
              GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _parcelPosition!,
                    zoom: 14.0,
                  ),
                  markers: Set<Marker>.of(markers.values)),
            ]),
    );
  }
}
