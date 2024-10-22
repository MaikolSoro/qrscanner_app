import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrscanner_app/src/bloc/scan_bloc.dart';
import 'package:qrscanner_app/src/models/scan_model.dart';
import 'package:qrscanner_app/src/pages/direcciones_page.dart';
import 'package:qrscanner_app/src/pages/mapas_page.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrscanner_app/src/utils/utils.dart' as utils;



class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;
  ScanResult scanResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTODOS,
          )
        ],
      ),
      body: _callPage(currentIndex),
        bottomNavigationBar: _crearBottomNavigationBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
       floatingActionButton: FloatingActionButton(
         child: Icon(Icons.filter_center_focus),
         onPressed: () =>  _scanQR(context),
         backgroundColor: Theme.of(context).primaryColor,

       ),
    );
  }

  // metodo para scanner con la camara
  
  Future _scanQR(BuildContext context) async {

    String futureString = 'https://www.google.com';
    
    //  try {
    //   var result = await BarcodeScanner.scan();
    //   setState(() => scanResult = result );
    //   futureString = result.rawContent.toString();
      
    // } catch (e) {
    //   print(e.toString());      
    // }
    // print(futureString);

    if(futureString != null) {
      final scan = ScanModel( valor: futureString );
      scansBloc.agregarScan(scan);

      final scan2 = ScanModel( valor: 'geo:40.724233047051705,-74.00731459101564' );
      scansBloc.agregarScan(scan2);

    if (Platform.isIOS) {
      Future.delayed(Duration( milliseconds: 750), () {
        utils.abrirScan(context,scan);
      });
    } else {

     utils.abrirScan(context,scan);
    }
  }
}

  Widget _callPage(int paginaActual) {

    switch(paginaActual) {

      case 0 : return MapasPage();
      case 1 : return DireccionesPage();
      default:   return MapasPage();
      
    }
  }

  Widget  _crearBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
       items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones'),

        )
      ],
      
        
    );
  }
}