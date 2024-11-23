import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  DatabaseHelper._();
  static Database? _database;
  static const String DATABASE_NAME = 'pdf_reader.db';
  static const String BOOKMARK_TABLE_NAME = 'bookmarks';
  static const String HISTORY_TABLE_NAME = 'history';
  static const String ID = 'id';
  static const String FILE_PATH = 'file_path';

  static final DatabaseHelper _instance = DatabaseHelper._();

  // factory DatabaseHelper() {
  //   return DatabaseHelper._();
  // }

  static Future<DatabaseHelper> getInstance() async {
    var applicationPath = await getDatabasesPath();
    String filePath = applicationPath +'/'+ DATABASE_NAME;
    if(_database == null){
      try{
        _database = await openDatabase(filePath,version: 1,onCreate: (database,version){
          database.execute('CREATE TABLE $BOOKMARK_TABLE_NAME ( $ID INTEGER PRIMARY KEY AUTOINCREMENT, $FILE_PATH TEXT NOT NULL)');
          database.execute('CREATE TABLE $HISTORY_TABLE_NAME ( $ID INTEGER PRIMARY KEY AUTOINCREMENT, $FILE_PATH TEXT  NOT NULL)');});
      }catch(exception,trace){
        _onError(exception.toString(),trace.toString());
      }
    }
    return _instance;
  }

  Future<bool> insertInto({required String table_name,required String filePath}) async{
    var rowEffected = 0;
    var data = <String,String>{
      FILE_PATH : filePath
    };
    try{
      rowEffected = await _database!.insert(table_name, data);
    }catch(exception,trace){
      _onError(exception.toString(), trace.toString());
    }
    if(rowEffected>0){
      return true;
    }
    return false;
  }

  Future<List<Map<String,dynamic>>> getFiles({required String table_name}) async{
    var files = <Map<String,dynamic>>[];
    try{
      files = await _database!.query(table_name);
    }catch(exception,trace){
      _onError(exception.toString(), trace.toString());
    }
    return files;
  }

  Future<bool> update({required String table_name,required String newFilePath,required String oldFilePath}) async{
    var values = <String,dynamic>{
      FILE_PATH : newFilePath
    };
    int rowEffected = 0;
    try{
      rowEffected = await _database!.update(table_name, values,where:'$FILE_PATH = $oldFilePath');
    }catch(exception,trace){
      _onError(exception.toString(), trace.toString());
    }
    if(rowEffected > 0){
      return true;
    }
    return false;
  }

  Future<bool> deleteFrom({required String table_name,required String filePath}) async{
    var rowEffected = 0;
    try{
      rowEffected = await _database!.delete(table_name,where:'$FILE_PATH = ?',whereArgs: [filePath]);
    }catch(exception,trace){
      _onError(exception.toString(), trace.toString());
    }
    if(rowEffected>0){
      return true;
    }
    return false;
  }

  Future<void> close() async{
    try{
      await _database!.close();
    }catch(exception,trace){
      _onError(exception.toString(), trace.toString());
    }
  }


  static _onError(String exception,String trace){
    print(exception + ' ' + trace);
  }

}