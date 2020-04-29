
import 'dart:async';

import 'package:qrscanner_app/src/providers/db_provider.dart';


class ScansBloc {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }
  ScansBloc._internal(){
    // Obtener todos los  Scans de la Base de datos
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream; 

  dispose() {
    _scansController?.close();
  }

// obtengo todos los scans
  obtenerScans() async {

    _scansController.sink.add( await DBProvider.db.getTodosScans());
  }
  // agregar scan // metodo async para asegurar que inserte primero y después ejecute obtenerScans()
  agregarScan(ScanModel scan ) async {
   await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  // borror el registro del scan
    borrarScan(int id) async {
        await DBProvider.db.deleteScan(id);
        obtenerScans();
    }

    // borro todos los scan 
    borrarScanTODOS() async {

      await DBProvider.db.deleteAll();
      obtenerScans();
    }
}