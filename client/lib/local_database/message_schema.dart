import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'message_schema.g.dart';

class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get senderId => text().nullable()();
  TextColumn get receiverId => text().nullable()();
  TextColumn get content => text().withLength(min: 1, max: 200)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openconnection());
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openconnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
