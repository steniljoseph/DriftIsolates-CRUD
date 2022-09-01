import 'dart:io';
import 'dart:isolate';
import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:drift_crud/database/student.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'studentdb.g.dart';

@DriftDatabase(tables: [Student])
class MyDatabase extends _$MyDatabase {
  MyDatabase()
      : super(NativeDatabase.memory(
          logStatements: true,
          setup: (database) => createDriftIsolateAndConnect(),
        ));

  MyDatabase.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;

  Stream<List<StudentData>> getStudents() => select(student).watch();

  Future updateStudent(StudentCompanion entity) =>
      update(student).replace(entity);

  Future<void> insertStudent(StudentCompanion entity) async =>
      await into(student).insert(entity);

  Future deleteStudent(int id) async =>
      await (delete(student)..where((tbl) => tbl.id.equals(id))).go();
}

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'db.sqlite'));
//     return NativeDatabase(file);
//   });
// }

Future<DriftIsolate> _createDriftIsolate() async {
  // this method is called from the main isolate. Since we can't use
  // getApplicationDocumentsDirectory on a background isolate, we calculate
  // the database path in the foreground isolate and then inform the
  // background isolate about the path.
  final dir = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'db.sqlite');
  final receivePort = ReceivePort();

  await Isolate.spawn(
    _startBackground,
    _IsolateStartRequest(receivePort.sendPort, path),
  );

  // _startBackground will send the DriftIsolate to this ReceivePort
  return await receivePort.first as DriftIsolate;
}

void _startBackground(_IsolateStartRequest request) {
  // this is the entry point from the background isolate! Let's create
  // the database from the path we received
  final executor = NativeDatabase(File(request.targetPath));
  // we're using DriftIsolate.inCurrent here as this method already runs on a
  // background isolate. If we used DriftIsolate.spawn, a third isolate would be
  // started which is not what we want!

  final driftIsolate = DriftIsolate.inCurrent(
    () => DatabaseConnection(executor),
  );
  // inform the starting isolate about this, so that it can call .connect()
  request.sendDriftIsolate.send(driftIsolate);
}

DatabaseConnection createDriftIsolateAndConnect() {
  return DatabaseConnection.delayed(
    Future.sync(() async {
      final isolate = await _createDriftIsolate();
      return await isolate.connect();
    }),
  );
}

// used to bundle the SendPort and the target path, since isolate entry point
// functions can only take one parameter.
class _IsolateStartRequest {
  final SendPort sendDriftIsolate;
  final String targetPath;

  _IsolateStartRequest(this.sendDriftIsolate, this.targetPath);
}
