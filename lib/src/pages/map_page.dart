import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manos_a_la_obra/src/models/direccion_model.dart';



class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  String search;
  bool _edit;
  Set<Marker> _markers = HashSet<Marker>();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-0.300658, -78.504816),
    zoom: 7.0,
  );

  @override
  Widget build(BuildContext context) {
    _edit = ModalRoute.of(context).settings.arguments;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Elige tu Ubicacion',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.cancel, color: Colors.white,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            zoomControlsEnabled: false,
            onTap: _addMarket,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              
            },
            
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(bottom: 70.0),
              child: FloatingActionButton(
                onPressed: _currentLocation,
                child:Icon(Icons.location_on,color: Colors.white,),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _crearBotonSiguiente(),
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            left: 20.0,
            child: _crearSearch()
          ),
          
        ],
      ),
      
    );
  }

  Widget _crearBotonSiguiente() {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(15.0),
        onPressed: ()async{
          if(_markers.isNotEmpty){
            final ubicacion = await transformarUbicacion();
            final direccion = Direccion(latitud: ubicacion.position.latitude,longitud: ubicacion.position.longitude,ubicacionMap: ubicacion.name);
            if(_edit){
              Navigator.pop(context,ubicacion);
            }else{
              Navigator.popAndPushNamed(context, 'form_direccion',arguments: direccion);
            }
          }
        },
        child: Container(
          child: Text('CONFIRMAR UBICACION', textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 17.0),)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.orangeAccent),
        ),
        color: Colors.orangeAccent,
      ),
    );
  }

  void _addMarket(LatLng argument) {
    final _marker = Marker(
        position: argument, 
        markerId: MarkerId('ubicacion')
      );
      _markers = HashSet<Marker>();
      _markers.add(_marker);
    setState(() {
    });
  }

  Widget _crearSearch() {
    return Container(
      height: 40.0,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Calle , Ciudad',
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 20.0,top: 5.0),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: searchDireccion,
          ),
        ),
        onChanged: (value){
          setState(() {
            search = value;
          });
        },
      ),
    );
  }
  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    Position position ;
    try {
      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } on Exception {
      position = null;
    }
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        zoom: 17.0,
      ),
    ));
  }

  void searchDireccion() async{
    try {
      final location  = await Geolocator().placemarkFromAddress(search);
      final GoogleMapController controller = await _controller.future;
      final latitude = location[0].position.latitude;
      final longitude = location[0].position.longitude;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 17.0,
        )
      ));
      _addMarket(LatLng(latitude, longitude));
    } catch (e) {
      print(e);
    }
    
  }

  Future<Placemark> transformarUbicacion() async{
      final ubicacion = await Geolocator().placemarkFromCoordinates(_markers.first.position.latitude,_markers.first.position.longitude);
      return ubicacion[0];
  }
}