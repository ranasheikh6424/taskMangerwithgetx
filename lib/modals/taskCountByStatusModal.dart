import 'package:taskmanager/modals/taskCountMOdal.dart';

class task_count_by_status {
  String? status;
  List<TaskCountModal>? data;

  task_count_by_status({this.status, this.data});

  task_count_by_status.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TaskCountModal>[];
      json['data'].forEach((v) {
        data!.add(new TaskCountModal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

