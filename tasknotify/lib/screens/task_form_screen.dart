import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../services/notification_service.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  final NotificationService _notificationService = NotificationService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDateTime = widget.task!.scheduledTime;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    if (!mounted) return;
    
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (!mounted) return;

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (!mounted) return;

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate() && !_isSaving) {
      setState(() => _isSaving = true);

      try {
        final task = Task(
          id: widget.task?.id,
          title: _titleController.text,
          description: _descriptionController.text,
          scheduledTime: _selectedDateTime,
          isCompleted: widget.task?.isCompleted ?? false,
        );

        final taskProvider = context.read<TaskProvider>();

        if (widget.task != null) {
          await taskProvider.updateTask(task);
          await _notificationService.cancelNotification(task.id);
        } else {
          await taskProvider.addTask(task);
        }

        if (!task.isCompleted && _selectedDateTime.isAfter(DateTime.now())) {
          await _notificationService.scheduleNotification(
            id: task.id,
            title: 'Task Reminder: ${task.title}',
            body: task.description,
            scheduledTime: task.scheduledTime,
          );
        }

        if (!mounted) return;
        Navigator.pop(context);
      } finally {
        if (mounted) {
          setState(() => _isSaving = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Scheduled Time'),
              subtitle: Text(
                DateFormat('MMM d, y - h:mm a').format(_selectedDateTime),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDateTime,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.task == null ? 'Add Task' : 'Update Task',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
