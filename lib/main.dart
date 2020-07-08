import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Byte Stuffing',
      home: MyHomePage(title: 'Byte Stuffing'),
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
  final flagTextController = TextEditingController();
  final escapeTextController = TextEditingController();
  final frameNumTextController = TextEditingController();
  final frameLengthTextController = TextEditingController();
  List<Frame> frames = [];
  BuildContext scaffoldContext;

  @override
  void initState() {
    super.initState();
    flagTextController.text = '111';
    escapeTextController.text = '110';
    frameNumTextController.text = '100';
    frameLengthTextController.text = '10';
  }

  @override
  void dispose() {
    super.dispose();
    flagTextController.dispose();
    escapeTextController.dispose();
    frameNumTextController.dispose();
    frameLengthTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: new Builder(builder: (BuildContext context) {
          scaffoldContext = context;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(10),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Flag"),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            controller: flagTextController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Escape کد"),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            controller: escapeTextController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              Text('  تولید'),
                              Container(
                                width: 60,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  controller: frameNumTextController,
                                ),
                              ),
                              Text('  فریم'),
                              Container(
                                width: 60,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder()),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  controller: frameLengthTextController,
                                ),
                              ),
                              Text('تایی  ')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            'تهیه شده توسط : امید مسلمانی',
                            style: TextStyle(
                                fontFamily: 'Vazir', color: Colors.blue[900]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: frames.isNotEmpty,
                  child: Container(
                    color: Colors.white70,
                    child: Center(
                      child: Text(
                        'فریم های تولید شده',
                      ),
                    ),
                  ),
                ),
                Column(
                  children: List.generate(frames.length, (int index) {
                    TextEditingController beforeTextController =
                        TextEditingController();
                    TextEditingController afterTextController =
                        TextEditingController();
                    Frame f = frames[index];

                    beforeTextController.text = f.before;

                    afterTextController.text = f.after;

                    return Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'فریم قبل از کد گذاری'),
                              enabled: false,
                              controller: beforeTextController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'فریم بعد از کد گذاری'),
                              enabled: false,
                              controller: afterTextController,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (flagTextController.text == '' ||
                  flagTextController.text == '0')
                createSnackBar('نمیتواند خالی باشد Flag');
              else if (escapeTextController.text == '' ||
                  escapeTextController.text == '0')
                createSnackBar('نمیتواند خالی باشد Escape');
              else if (frameNumTextController.text == '' ||
                  frameNumTextController.text == '0')
                createSnackBar('نمیتواند خالی باشد Frame تعداد');
              else if (frameLengthTextController.text == '' ||
                  frameLengthTextController.text == '0')
                createSnackBar('نمیتواند خالی باشد Frame طول');
              else {
                Random rnd = Random();
                setState(() {
                  frames = [];
                  int fn = int.parse(frameNumTextController.text),
                      fl = int.parse(frameLengthTextController.text);
                  for (int i = 0; i < fn; i++) {
                    Frame f = Frame();
                    f.before = '';
                    for (int j = 0; j < fl; j++) {
                      f.before += rnd.nextInt(2).toString();
                    }
                    String temp = f.before;
                    temp = temp.replaceAll(escapeTextController.text, 'E'); // Esc -> E
                    temp = temp.replaceAll(flagTextController.text, // Flag -> Esc Flag
                        escapeTextController.text + flagTextController.text);
                    temp = temp.replaceAll('E', // E -> Esc Esc
                        escapeTextController.text + escapeTextController.text);
                    f.after = flagTextController.text + // adding flag to start and end of frame
                        temp +
                        flagTextController.text;
                    frames.add(f);
                  }
                });
              }
            },
            label: Text(
              'رشته بیت جدید',
              style: TextStyle(fontFamily: 'Vazir'),
            ),
            icon: Icon(Icons.add)));
  }

  void createSnackBar(String message) {
    final snackBar = new SnackBar(content: new Text(message));
    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }
}

class Frame {
  String before, after;
  Frame({this.before, this.after});
}
