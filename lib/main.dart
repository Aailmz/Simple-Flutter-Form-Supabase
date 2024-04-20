import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://edekwolepixvtzemhxqj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVkZWt3b2xlcGl4dnR6ZW1oeHFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTM0OTI5ODgsImV4cCI6MjAyOTA2ODk4OH0.ZvGpR6WxQEc9XTw-DzufIQPdkhYU3rJTlk5ABs_tjbM',
  );

  runApp(MainApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
              ),
              TextField(
                controller: _descriptionController,
              ),
              ElevatedButton(onPressed: () async {
              
              final title = _titleController.text;
              final description = _descriptionController.text;

              await supabase
                  .from('tabletes')
                  .insert({'title': title, 'description': description});

                  setState(() {});

                  _titleController.clear();
                  _descriptionController.clear();

              }, child: Text('SUBMIT')),

              FutureBuilder(
                future: fetchData(), 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error');
                  } else {
                    final data = snapshot.data as List<dynamic>;
                    return DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Title')),
                        DataColumn(label: Text('Description')),
                      ],
                      rows: data
                          .map((item) => DataRow(cells: [
                                DataCell(Text(item['title'])),
                                DataCell(Text(item['description'])),
                              ]))
                          .toList(),
                    );
                  }
                },
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<dynamic>> fetchData() async {

  final response = await supabase.from('tabletes').select('*');
  return response as List<dynamic>;
}