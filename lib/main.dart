import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Player'),
      actions: Map(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _accessible = false;
  List<BottomNavigationBarItem> _btmNavList;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _checkPermission() {
    setState(() {
      //외부저장소 권한을 체크한다
      _accessible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PermissionWidget(counter: _counter, accessible: _accessible),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined),
            label: '비디오',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_outlined),
            label: '음악',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '마이',
          ),
        ],
      ),
    );
  }
}

class PermissionWidget extends StatelessWidget {
  const PermissionWidget({
    Key key,
    @required int counter,
    @required bool accessible,
  })  : _counter = counter,
        _accessible = accessible,
        super(key: key);

  final int _counter;
  final bool _accessible;

  @override
  Widget build(BuildContext context) {
    if (_accessible == true) {
      Text("show permission granted repository tree");
    } else {
      return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '비디오와 오디오를 재생하고 자막을 보기 위해서는, 장치의 모든 파일에 접근해야 합니다.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              ElevatedButton(
                onPressed: () {
                  AppSettings.openAppSettings();
                },
                child: Text("접근 권한 요청"),
              ),
            ],
          ),
        ),
      );
    }
  }
}
