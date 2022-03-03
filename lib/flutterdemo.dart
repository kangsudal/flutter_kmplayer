import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
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

  Future<List<FileSystemEntity>> _listFiles() async {
    final List<FileSystemEntity> list = [];
    final directory = await getApplicationDocumentsDirectory();

    await for (var entity
        in directory.list(recursive: false, followLinks: false)) {
      list.add(entity);
      // print("${entity.path} is added");
    }

    // print(list);

    return list;
  } //List the entries of a directory
}

class FlutterDemo extends StatefulWidget {
  final CounterStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter;
  String _path = '경로String';
  int _numOfFiles = -1;
  List<FileSystemEntity> _files = [];

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });

    widget.storage._localPath.then((String value) {
      setState(() {
        _path = value;
      });
    });

    widget.storage._listFiles().then((value) {
      setState(() {
        _files = value;
        _numOfFiles = value.length;
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

  @override
  Widget build(BuildContext context) {
/*    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: Center(
        child: Text(
          'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );

 */
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(child: Text(_files[index].toString()));
        },
        itemCount: _files.length,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
