import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asset and Data Handling App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _useNetworkAssets = false;
  late Future<List<dynamic>> _jsonData;

  @override
  void initState() {
    super.initState();
    _jsonData = loadJsonData();
  }


  Future<List<dynamic>> loadJsonData() async {
    if (_useNetworkAssets) {
      return loadJsonFromAssets('assets/data/sample_data.json');
    } else {
      return loadJsonFromAssets('assets/data/sample_data.json');
    }
  }

  Future<List<dynamic>> loadJsonFromAssets(String path) async {
    final String data = await rootBundle.loadString(path);
    return jsonDecode(data);
  }

  Widget loadImage(String imagePath) {
    return _useNetworkAssets
        ? Image.network(
      imagePath,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.error));
      },
    )
        : Image.asset(
      imagePath,
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.error));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset and Data Handling App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SwitchListTile(
                title: const Text('Use Network Assets'),
                value: _useNetworkAssets,
                onChanged: (bool value) {
                  setState(() {
                    _useNetworkAssets = value;
                    _jsonData = loadJsonData();
                  });
                },
              ),
            ),
            _useNetworkAssets
                ? loadImage('https://ik.imagekit.io/yxctvbjvh/IMG-1734950448885_ENFzcDXjkj.jpg?updatedAt=1734950451539') // Placeholder URL
                : loadImage('assets/images/aqil.jpg'),
            FutureBuilder<List<dynamic>>(
              future: _jsonData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Icon(Icons.error));
                } else {
                  final data = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Text(item['email']),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
