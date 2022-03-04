import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  } //1.Find the correct local path

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/counter.txt');
  } //2.Create a reference to the file location

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // 파일 읽기
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // 에러가 발생할 경우 0을 반환
      return 0;
    }
  } //4.Read data from the file

  void writeCounter(int counter) async {
    final file = await _localFile;

    // 파일 쓰기
    file.writeAsString('$counter');
  } //3.Write data to the file

//추가 메서드
  Future<List<FileSystemEntity>> readFileListOn(String path) async {
    //path 안에 있는 폴더, 파일등의 이름 전부를 리스트로 반환
    List dirs = Directory(path).listSync(recursive: false, followLinks: false);
    print(dirs);
    return dirs;
  }
}

class FlutterDemo extends StatefulWidget {
  final CounterStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter;
  String _localPath = 'test 내부저장소 초기경로';
  String _currentPath = 'test 현재경로';
  List<FileSystemEntity> _files = [
    File('test1.txt'),
    File('test2.txt'),
    File('test3.txt'),
  ];

  @override
  void initState() {
    super.initState();

    //내부저장소에 만들어놓은 counter.txt 내용 읽기
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });

    widget.storage._localPath.then((String value) {
      setState(() {
        _localPath = value;
        _currentPath = value;
      });
      widget.storage
          .readFileListOn(_localPath)
          .then((List<FileSystemEntity> value) {
        setState(() {
          _files = value;
        });
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    // 파일에 String 타입으로 변수 값 쓰기
    widget.storage.writeCounter(_counter);
  }

  void _resetPath() {
    setState(() {
      _currentPath = _localPath;
      widget.storage
          .readFileListOn(_localPath)
          .then((List<FileSystemEntity> value) {
        setState(() {
          _files = value;
        });
      });
    });
  }

  void _refreshCurrentPath(String newPath) {
    setState(() {
      _currentPath = newPath;
      widget.storage
          .readFileListOn(newPath)
          .then((List<FileSystemEntity> value) {
        setState(() {
          _files = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: Column(
        children: [
          Text("현재 경로:$_currentPath"),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (_files[index] is File) {
                  return Card(
                    child: Text(
                      _files[index].path,
                    ),
                  );
                }
                return GestureDetector(
                  child: Card(
                    child: Text(
                      _files[index].path,
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  onTap: () {
                    _refreshCurrentPath(_files[index].path);
                  },
                );
              },
              itemCount: _files.length,
            ),
          ),
        ],
      ),
      floatingActionButton: homeButton(),
    );
  }

  Widget addCounterButton() {
    return FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }

  Widget homeButton() {
    return FloatingActionButton(
      onPressed: _resetPath,
      tooltip: 'Reset path',
      child: Icon(Icons.home),
    );
  }
}
