import 'dart:io';

import 'package:abacus_simple_anzan/src/model/preset_add_model.dart';
import 'package:abacus_simple_anzan/src/model/preset_multiply_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbClient {
  //constructor
  static final DbClient _instance = DbClient._init();
  DbClient._init();

  factory DbClient() {
    return _instance;
  }

  static String path = '${Directory.current.path}\\save\\preset.db';
  static String addTableName = 'add_presets';
  static String multiplyTableName = 'multiply_presets';

  Future<void> initData() async {
    sqfliteFfiInit();

    var db = await databaseFactoryFfi.openDatabase(path);
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $addTableName (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      colorCode TEXT NOT NULL,
      textColorCode TEXT NOT NULL,
      onlyPlusesIndex INTEGER NOT NULL,
      shuffleIndex INTEGER NOT NULL,
      speedIndex INTEGER NOT NULL,
      digitIndex INTEGER NOT NULL,
      numOfProblemIndex INTEGER NOT NULL,
      notifyIndex INTEGER NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $multiplyTableName (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      colorCode TEXT NOT NULL,
      textColorCode TEXT NOT NULL,
      calculationMode INTEGER NOT NULL,
      speedIndex INTEGER NOT NULL,
      smallDigitIndex INTEGER NOT NULL,
      bigDigitIndex INTEGER NOT NULL,
      notifyIndex INTEGER NOT NULL
    )
    ''');
    db.close();
  }

  static Future<int> saveAddPreset(PresetAddModel addModel) async {
    var db = await databaseFactoryFfi.openDatabase(path);
    var values = addModel.toValues();
    var rowId = db.insert(addTableName, values);

    await db.close();
    return rowId;
  }

  static Future<int> saveMultiplyPreset(
      PresetMultiplyModel multiplyModel) async {
    var db = await databaseFactoryFfi.openDatabase(path);
    var values = multiplyModel.toValues();
    var rowId = db.insert(multiplyTableName, values);

    await db.close();
    return rowId;
  }

  static Future<int> deleteAddPreset(PresetAddModel addModel) async {
    var db = await databaseFactoryFfi.openDatabase(path);
    var deletedId =
        await db.delete(addTableName, where: 'id = "${addModel.id}"');

    await db.close();
    return deletedId;
  }

  static Future<int> deleteMultiplyPreset(
      PresetMultiplyModel multiplyModel) async {
    var db = await databaseFactoryFfi.openDatabase(path);
    var deletedId =
        await db.delete(multiplyTableName, where: 'id = "${multiplyModel.id}"');

    await db.close();
    return deletedId;
  }

  static Future<List<PresetAddModel>> getAddPresets() async {
    var items = List<PresetAddModel>.empty(growable: true);
    var db = await databaseFactoryFfi.openDatabase(path);

    var dbItems = await db.query(addTableName);
    for (var element in dbItems) {
      items.add(PresetAddModel.fromValues(element));
    }

    return items;
  }

  static Future<List<PresetMultiplyModel>> getMultiplyPresets() async {
    var items = List<PresetMultiplyModel>.empty(growable: true);
    var db = await databaseFactoryFfi.openDatabase(path);

    List<Map<String, Object?>> dbItems = await db.query(multiplyTableName);
    for (var element in dbItems) {
      items.add(PresetMultiplyModel.fromValues(element));
    }

    return items;
  }
}
