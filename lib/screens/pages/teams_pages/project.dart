import 'package:flutter/material.dart';

class ProjectPlanScreen extends StatefulWidget {
  const ProjectPlanScreen({Key? key}) : super(key: key);

  @override
  _ProjectPlanScreenState createState() => _ProjectPlanScreenState();
}

class _ProjectPlanScreenState extends State<ProjectPlanScreen> {
  List<String> sprints = [];
  TextEditingController sprintController = TextEditingController();

  void addSprint(String sprintName) {
    setState(() {
      sprints.add(sprintName);
      sprintController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Plan'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text('New Sprint'),
                        content: TextField(
                          controller: sprintController,
                          decoration: const InputDecoration(
                            hintText: 'Enter sprint name',
                          ),
                          onSubmitted: (value) {
                            addSprint(value);
                            Navigator.pop(context);
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('New Sprint'),
              ),
              const SizedBox(width: 10),
              Text('Sprints: ${sprints.length}'),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('Added Sprints'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children:
                          sprints.map((sprint) => Text('- $sprint')).toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Add New Sprint'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ProjectPlanScreen(),
  ));
}
