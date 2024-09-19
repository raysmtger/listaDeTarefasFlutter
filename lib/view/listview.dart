import 'package:flutter/material.dart';
import 'package:teste/models/task_model.dart';
import 'package:teste/services/task_service.dart';
import 'package:teste/view/forms.dart';


class ListViewTasks extends StatefulWidget {
  const ListViewTasks({super.key});

  @override
  State<ListViewTasks> createState() => _ListViewTasksState();
}

class _ListViewTasksState extends State<ListViewTasks> {
 TaskService taskService = TaskService();
 List<Task> tasks = [];

  getAllTasks() async {
    tasks = await taskService.getTasks();
    setState(() {});
  }

  @override
  void initState() {
    getAllTasks();
    super.initState();
  }

  Color getPriorityColor(String? priority) {
    switch (priority) {
      case 'Alta':
        return Color.fromARGB(255, 100, 8, 77);
      case 'Média':
        return Color.fromARGB(255, 160, 78, 142);
      case 'Baixa':
      default:
        return Color.fromARGB(157, 163, 94, 157);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          bool localIsDone = tasks[index].isDone ?? false;
          return Column(
            children: [
              Card(
                color: Color.fromARGB(190, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tasks[index].title.toString(),
                            style: TextStyle(
                              color: localIsDone ? Color.fromARGB(255, 7, 6, 6) : Color.fromARGB(255, 92, 17, 42),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              decoration: localIsDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                                  decorationColor: Colors.red,
                            ),
                          ),
                          Checkbox(
                            value: tasks[index].isDone ?? false,
                            onChanged: (value) async {
                              if (value != null) {
                                await taskService.editTask(
                                  index,
                                  tasks[index].title!,
                                  tasks[index].description!,
                                  value,
                                  priority: tasks[index].priority,
                                );
                                setState(() {
                                  tasks[index].isDone = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Text(
                        tasks[index].description.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prioridade: ${tasks[index].priority}',
                            style: TextStyle(
                              color: getPriorityColor(tasks[index].priority),
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              if (!localIsDone)
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FormsTasks(
                                          task: tasks[index],
                                          index: index,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                  color: Color.fromARGB(255, 13, 119, 19),
                                ),
                              IconButton(
                                onPressed: () async {
                                  await taskService.deleteTask(index);
                                  getAllTasks(); 
                                },
                                icon: const Icon(Icons.delete),
                                color: localIsDone ? Colors.grey : Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}