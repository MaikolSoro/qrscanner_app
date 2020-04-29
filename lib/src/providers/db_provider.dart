import 'dart:io';
import 'package:path/path.dart';
import 'package:qrscanner_app/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
class DBProvider {

  static Database _dataBase;
  static final DBProvider db = DBProvider._(); // constructor privado

  DBProvider._();

  // configurar la base de datos
  Future<Database> get database async{

    if(_dataBase != null ) return _dataBase;
      _dataBase = await initDB();

      return _dataBase;
  }

// Crear la base datos y la tabla scans
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'ScanDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {

        await db.execute(
          'CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')'
        );

      }
    );

  }

  // Crear registros  de la base de datos
  nuevoScanRaw(ScanModel nuevoScan) async{

    final db = await database;

    final res = await db.rawInsert(

      "INSERT Into Scans(id, tipo, valor) "
      "VALUES (${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor}' )"
    );
    return res;
  }

  // Insertar en la BD
  nuevoScan( ScanModel nuevoScan) async{
    final db = await database;
    final res = db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  //SELECT -Obtener información por id

 Future<ScanModel> getScanId( int id ) async{
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id] );

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }


  // obtengo todos los scans de BD
  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel>list = res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    
    return list;
  }

  //Obtengo los scans por tipo
  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    List<ScanModel>list = res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    
    return list;
  }

// Actualizo  registros
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);

    return res;
  }

  //Eliminar registros

 Future<int> deleteScan(int id ) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }
 Future<int> deleteAll(int id ) async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
  
}