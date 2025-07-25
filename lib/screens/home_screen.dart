import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/helpers/database_helper.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/auth_service.dart';
import 'package:task_manager/screens/auth/login_screen.dart';
import 'history_screen.dart';
import 'package:task_manager/screens/add_task_screen.dart';
import 'package:intl/intl.dart';
import 'settings_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future<bool> onBackPressed() async {
    SystemNavigator.pop();
    return true;
  }

  // Get only incomplete tasks
  List<Task> _getIncompleteTasks(List<Task> allTasks) {
    return allTasks.where((task) => task.status == 0).toList();
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
                decoration: TextDecoration.none,
              ),
            ),
            subtitle: Text(
              '${_dateFormatter.format(task.date)} • ${task.priority}',
              style: TextStyle(
                fontSize: 15.0,
                decoration: TextDecoration.none,
              ),
            ),
            trailing: Checkbox(
              onChanged: (value) {
                _showCompleteTaskDialog(task, value!);
              },
              activeColor: Theme.of(context).primaryColor,
              value: false, // Always false since we only show incomplete tasks
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

  void _showCompleteTaskDialog(Task task, bool isCompleted) {
    if (isCompleted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Text('Complete Task'),
              ],
            ),
            content: Text('Mark "${task.title}" as completed?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  task.status = 1;
                  DatabaseHelper.instance.updateTask(task);
                  Fluttertoast.showToast(
                    msg: "Task completed! 🎉",
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
                child: Text('Complete'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(
                updateTaskList: _updateTaskList,
              ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
          leading: IconButton(
            icon: Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey,
            ),
            onPressed: null,
          ),
          title: Row(
            children: [
              Text(
                "Task",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -1.2,
                ),
              ),
              Text(
                "Manager",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0,
                ),
              )
            ],
          ),
          centerTitle: false,
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.all(0),
              child: IconButton(
                icon: Icon(Icons.history_outlined),
                iconSize: 25.0,
                color: Colors.black,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HistoryScreen())
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6.0),
              child: IconButton(
                icon: Icon(Icons.settings_outlined),
                iconSize: 25.0,
                color: Colors.black,
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => Settings())
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6.0),
              child: PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value),
                icon: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.redAccent,
                  child: Text(
                    AuthService().currentUser?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person_outline, size: 20),
                        SizedBox(width: 8),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<Task>>(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final incompleteTasks = _getIncompleteTasks(snapshot.data!);
            final pendingTaskCount = incompleteTasks.length;
            final totalTaskCount = snapshot.data!.length;
            final completedTaskCount = totalTaskCount - pendingTaskCount;

            if (incompleteTasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 80,
                      color: Colors.green[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'All tasks completed!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Great job! Add new tasks to continue.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTaskScreen(
                            updateTaskList: _updateTaskList,
                          ),
                        ),
                      ),
                      icon: Icon(Icons.add),
                      label: Text('Add New Task'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemCount: 1 + incompleteTasks.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: pendingTaskCount > 0 ? Colors.orange[50] : Colors.green[50],
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        border: Border.all(
                          color: pendingTaskCount > 0 ? Colors.orange[200]! : Colors.green[200]!
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            pendingTaskCount > 0 ? Icons.pending_actions : Icons.check_circle,
                            color: pendingTaskCount > 0 ? Colors.orange[600] : Colors.green[600],
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You have $pendingTaskCount pending task${pendingTaskCount == 1 ? '' : 's'}',
                                  style: TextStyle(
                                    color: pendingTaskCount > 0 ? Colors.orange[700] : Colors.green[700],
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (completedTaskCount > 0)
                                  Text(
                                    '$completedTaskCount completed • $totalTaskCount total',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14.0,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return _buildTask(incompleteTasks[index - 1]);
              },
            );
          },
        ),
      ),
    );
  }

  void _handleMenuAction(String value) async {
    switch (value) {
      case 'profile':
        _showUserProfile();
        break;
      case 'logout':
        await _logout();
        break;
    }
  }

  void _showUserProfile() {
    final user = AuthService().currentUser;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.redAccent,
              child: Text(
                user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(width: 12),
            Text('User Profile'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user?.displayName ?? 'Unknown'}'),
            SizedBox(height: 8),
            Text('Email: ${user?.email ?? 'Unknown'}'),
            SizedBox(height: 8),
            Text('User ID: ${user?.uid ?? 'Unknown'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await AuthService().signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error signing out: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
