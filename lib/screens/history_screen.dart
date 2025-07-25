import 'package:flutter/material.dart';
import 'package:task_manager/helpers/database_helper.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/screens/add_task_screen.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List<Task>>? _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  // Get only completed tasks
  List<Task> _getCompletedTasks(List<Task> allTasks) {
    return allTasks.where((task) => task.status == 1).toList();
  }

  Widget _buildTask(Task task) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 18.0,
                decoration: TextDecoration.lineThrough,
                color: Colors.grey[600],
              ),
            ),
            subtitle: Text(
              '${_dateFormatter.format(task.date)} • ${task.priority}',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.grey[500],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.restore,
                    color: Colors.green,
                  ),
                  tooltip: 'Restore Task',
                  onPressed: () {
                    _showRestoreDialog(task);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  tooltip: 'Delete Permanently',
                  onPressed: () {
                    _showDeleteDialog(task);
                  },
                ),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(
                  updateTaskList: _updateTaskList,
                  task: task,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }

  void _showRestoreDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Restore Task'),
          content: Text('Do you want to restore "${task.title}" to your active tasks?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                task.status = 0;
                DatabaseHelper.instance.updateTask(task);
                Fluttertoast.showToast(
                  msg: "Task restored to active list",
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
                _updateTaskList();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Restore'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Delete Task'),
          content: Text('Are you sure you want to permanently delete "${task.title}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseHelper.instance.deleteTask(task.id!);
                Fluttertoast.showToast(
                  msg: "Task deleted permanently",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                _updateTaskList();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Clear All History'),
          content: Text('Are you sure you want to delete all completed tasks? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final tasks = await DatabaseHelper.instance.getTaskList();
                final completedTasks = tasks.where((task) => task.status == 1).toList();
                
                for (Task task in completedTasks) {
                  await DatabaseHelper.instance.deleteTask(task.id!);
                }
                
                Fluttertoast.showToast(
                  msg: "All history cleared",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                _updateTaskList();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => HomeScreen())
          ),
        ),
        title: Row(
          children: [
            Text(
              'Completed Tasks',
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear_all,
              color: Colors.red,
            ),
            tooltip: 'Clear All History',
            onPressed: _showClearAllDialog,
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: FutureBuilder<List<Task>>(
        future: _taskList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final completedTasks = _getCompletedTasks(snapshot.data!);
          final completedTaskCount = completedTasks.length;

          if (completedTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No completed tasks yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complete some tasks to see them here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            itemCount: 1 + completedTasks.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[600],
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You have completed $completedTaskCount task${completedTaskCount == 1 ? '' : 's'}',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return _buildTask(completedTasks[index - 1]);
            },
          );
        },
      ),
    );
  }
}
