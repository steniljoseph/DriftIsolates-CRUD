import 'package:drift_crud/database/studentdb.dart';
import 'package:drift_crud/main.dart';
import 'package:drift_crud/views/constants.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d;
import 'package:get/get.dart';

class AddUpdateStudent extends StatefulWidget {
  final bool isUpdate;
  final StudentCompanion? stdDatas;

  const AddUpdateStudent({
    Key? key,
    required this.isUpdate,
    this.stdDatas,
  }) : super(key: key);

  @override
  State<AddUpdateStudent> createState() => _AddUpdateStudentState();
}

class _AddUpdateStudentState extends State<AddUpdateStudent> {
  // String? initialName;
  // String? initialJob;
  // String? initialPlace;
  final _globalKey = GlobalKey<FormState>();

  // late  MyDatabase myDatabase;
  late StudentCompanion std;

  // var nameController = TextEditingController();

  // final jobController = TextEditingController();

  // final locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    std = widget.stdDatas ??
        const StudentCompanion(
          rollNo: d.Value(0),
          name: d.Value(''),
          batch: d.Value(''),
          place: d.Value(''),
        );
    // myDatabase = MyDatabase();
    // initialName = widget.name;
    // initialJob = widget.job;
    // initialPlace = widget.place;
  }

  @override
  void dispose() {
    super.dispose();
    // myDatabase.close();
    // nameController.dispose();
    // jobController.dispose();
    // locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              _globalKey.currentState!.save();
              widget.isUpdate
                  ? await myDatabase.updateStudent(std)
                  : await myDatabase.insertStudent(std);
              Get.back();

              // if (widget.isUpdate) {
              //   log("updated called");
              //   // final entity = EmployeeCompanion(
              //   //   name: d.Value(initialName!),
              //   //   job: d.Value(initialJob!),
              //   //   place: d.Value(initialPlace!),
              //   // );
              //   await myDatabase.updateEmployee(emp);
              //   Get.off(const HomeScreen());
              // } else if (_globalKey.currentState.save()) {
              //   log("add called");
              //   // final entity = EmployeeCompanion(
              //   //   name: d.Value(initialName!),
              //   //   job: d.Value(initialJob!),
              //   //   place: d.Value(initialPlace!),
              //   // );
              //   await myDatabase.insertEmployee(emp);
              //   Get.off(const HomeScreen());
              // }
            },
          ),
          kWidth,
        ],
        elevation: 0,
        centerTitle: true,
        title: widget.isUpdate
            ? const Text("Update Student")
            : const Text("Add Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: std.rollNo.value.toString(),
                // onChanged: (value) {
                //   initialName = value;
                // },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  std = std.copyWith(rollNo: d.Value(int.parse(value!)));
                },
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                // validator: (value) {
                //   if (value!.isEmpty && value.length < 3) {
                //     return 'Please Enter Your Name';
                //   }
                //   return null;
                // },
                // controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Roll Number',
                ),
              ),
              kHeight,
              TextFormField(
                initialValue: std.name.value,
                // onChanged: (value) {
                //   initialName = value;
                // },
                onSaved: (value) {
                  std = std.copyWith(name: d.Value(value!));
                },
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                // validator: (value) {
                //   if (value!.isEmpty && value.length < 3) {
                //     return 'Please Enter Your Name';
                //   }
                //   return null;
                // },
                // controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
              ),
              kHeight,
              TextFormField(
                initialValue: std.batch.value,
                // onChanged: (value) => initialJob = value,
                onSaved: (value) {
                  std = std.copyWith(batch: d.Value(value!));
                },
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                // validator: (value) {
                //   if (value!.isEmpty && value.length < 3) {
                //     return 'Please Enter Your Job';
                //   }
                //   return null;
                // },
                // controller: jobController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Batch',
                ),
              ),
              kHeight,
              TextFormField(
                initialValue: std.place.value,
                // onChanged: (value) => initialPlace = value,
                onSaved: (value) {
                  std = std.copyWith(place: d.Value(value!));
                },
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                // validator: (value) {
                //   if (value!.isEmpty && value.length < 3) {
                //     return 'Please Enter Your Location';
                //   }
                //   return null;
                // },
                // controller: locationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Location',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
