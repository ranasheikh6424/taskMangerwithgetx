import 'package:flutter/material.dart';
import 'package:taskmanager/api/apiClient.dart';
import 'package:taskmanager/modals/taskCountMOdal.dart';

class NewTaskList extends StatefulWidget {
  const NewTaskList({Key? key}) : super(key: key);

  @override
  State<NewTaskList> createState() => _NewTaskListState();
}

class _NewTaskListState extends State<NewTaskList> {
  List<TaskCountModal> taskCounts = [];
  List<dynamic> newTasks = [];
  bool isLoadingCounts = true;
  bool isLoadingTasks = true;
  String status = "New";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchTaskCounts();
    fetchNewTasks();
  }

  fetchTaskCounts() async {
    setState(() => isLoadingCounts = true);
    try {
      taskCounts = await TaskStatusCountListRequest();
    } catch (e) {
      print("Error fetching task counts: $e");
    } finally {
      setState(() => isLoadingCounts = false);
    }
  }

  fetchNewTasks() async {
    setState(() => isLoadingTasks = true);
    try {
      newTasks = await TaskListRequest("New");
    } catch (e) {
      print("Error fetching new tasks: $e");
    } finally {
      setState(() => isLoadingTasks = false);
    }
  }

  updateStatus(id) async {
    setState(() => loading = true);
    await TaskUpdateRequest(id, status);
    await fetchNewTasks(); // Fetch new tasks after status update
    await fetchTaskCounts(); // Refresh task counts after status update
    setState(() => status = "New");
    setState(() => loading = false); // Ensure loading is false after update
  }

  statusChange(id) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.all(30),
          height: 360,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...["New", "Progress", "Completed", "Cancelled"].map(
                (value) => RadioListTile(
                  title: Text(value),
                  value: value,
                  groupValue: status,
                  onChanged: (newValue) =>
                      setState(() => status = newValue.toString()),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  updateStatus(id); // Update task status and refresh counts
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteItem(id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Delete!"),
        content: Text("Once deleted, you can't get it back"),
        actions: [
          OutlinedButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => loading = true);
                await TaskDeleteRequest(id);
                await fetchNewTasks(); // Refresh tasks after deletion
                await fetchTaskCounts(); // Refresh task counts after deletion
                setState(() =>
                    loading = false); // Ensure loading is false after delete
              },
              child: Text('Yes')),
          OutlinedButton(
              onPressed: () => Navigator.pop(context), child: Text('No')),
        ],
      ),
    );
  }

  Widget buildTaskCountWidget() {
    List<String> allowedStatuses = [
      "New",
      "Cancelled",
      "Completed",
      "Progress"
    ];

    // Filter the task counts and sort them by predefined order
    var filteredCounts =
        taskCounts.where((task) => allowedStatuses.contains(task.sId)).toList();

    // Sort the filtered counts to maintain a fixed order
    filteredCounts.sort((a, b) {
      int indexA = allowedStatuses.indexOf(a.sId ?? "");
      int indexB = allowedStatuses.indexOf(b.sId ?? "");
      return indexA.compareTo(indexB);
    });

    return filteredCounts.isEmpty
        ? const Center(child: Text("No task counts available !...."))
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredCounts.length,
            itemBuilder: (context, index) {
              var count = filteredCounts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.20,
                  decoration: BoxDecoration(
                    color: count.sId == "New"
                        ? Colors.redAccent
                        : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(count.sum.toString(),
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(count.sId ?? "Unknown",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget buildNewTaskListWidget() {
    return newTasks.isEmpty
        ? Center(child: Text("No new tasks available."))
        : ListView.builder(
            itemCount: newTasks.length,
            itemBuilder: (context, index) {
              var task = newTasks[index];
              return Container(
                color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
                child: ListTile(
                  title: Text(task['title'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(task['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => statusChange(task['_id'])),
                      IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteItem(task['_id'])),
                    ],
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.all(8.0),
            child: isLoadingCounts
                ? Center(child: CircularProgressIndicator())
                : buildTaskCountWidget(),
          ),
          Divider(),
          Expanded(
            child: isLoadingTasks
                ? Center(child: CircularProgressIndicator())
                : buildNewTaskListWidget(),
          ),
        ],
      ),
    );
  }
}
