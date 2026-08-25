import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

Future<void> initDatabase() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
