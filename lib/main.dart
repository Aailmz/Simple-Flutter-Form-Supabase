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
  final TextEditingController _descriptionEditController = TextEditingController();
  final TextEditingController _titleEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Form'),
          backgroundColor: Colors.grey[100],
        ),
        body: Container(
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFFF5F5F5))
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFF858585))
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFFF5F5F5))
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFFF5F5F5))
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFF858585))
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Color(0xFFF5F5F5))
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final title = _titleController.text;
                    final description = _descriptionController.text;
                    
                    await supabase
                        .from('tabletes')
                        .insert({'title': title, 'description': description});
                    

                    setState(() {});

                    _titleController.clear();
                    _descriptionController.clear();

                    
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'TAMBAH',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Expanded(
                  child: FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error'));
                      } else {
                        final data = snapshot.data as List<dynamic>;
                        return DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Judul',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Deskripsi',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Aksi',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: data
                              .map((item) => DataRow(cells: [
                                    DataCell(Text(item['title'])),
                                    DataCell(Text(item['description'])),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.orange,),
                                          onPressed: () async {
                                            showDialog(context: context, builder: (BuildContext context) {
                                              _descriptionEditController.text = item['description'];
                                              _titleEditController.text = item['title'];
                                              return AlertDialog(
                                                title: Text('Edit Barang'),
                                                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.2,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                          controller: _titleEditController,
                                                          decoration: InputDecoration(
                                                            labelText: 'Judul',
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(8.0),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors.grey[200],
                                                          ),
                                                        ),
                                                        SizedBox(height: 20,),
                                                        TextField(
                                                          controller: _descriptionEditController,
                                                          decoration: InputDecoration(
                                                            labelText: 'Deskripsi',
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(8.0),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors.grey[200],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {

                                                    await supabase
                                                      .from('tabletes')
                                                      .update({ 'title': _titleEditController.text, 'description': _descriptionEditController.text })
                                                      .eq('id', item['id']);


                                                      setState(() {});

                                                    Navigator.of(context).pop();
                                                    showDialog(context: context, builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Sukses!'),
                                                        content: SizedBox(
                                                          height: MediaQuery.of(context).size.height * 0.05,
                                                          child: Text('Data berhasil di edit!')
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Ok'),
                                                        ),
                                                        
                                                        ],
                                                      );
                                                    });
                                                  },
                                                  child: Text('Simpan'),
                                                ),
                                                ],
                                              );
                                            });
                
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red,),
                                          onPressed: () async {
                                            showDialog(context: context, builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Hapus Barang'),
                                                content: SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.05,
                                                  child: Text('Yakin ingin Hapus Data?')
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {

                                                    await supabase
                                                        .from('tabletes')
                                                        .delete()
                                                        .eq('id', item['id']);
                                                        
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                    showDialog(context: context, builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Sukses!'),
                                                        content: SizedBox(
                                                          height: MediaQuery.of(context).size.height * 0.05,
                                                          child: Text('Data berhasil di hapus!')
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text('Ok'),
                                                        ),
                                                        
                                                        ],
                                                      );
                                                    });
                                                  },
                                                  child: Text('Hapus'),
                                                ),
                                                ],
                                              );
                                            });
                
                                          },
                                          
                                        ),
                                      ],
                                    )),
                                  ]))
                              .toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Future<List<dynamic>> fetchData() async {

  final response = 
  
  await supabase
    .from('tabletes')
    .select('*');

  return response as List<dynamic>;
}