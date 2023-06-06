import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_plugin_mep/flutter_plugin_mep.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moxo Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Moxo Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isLogedIn = false;
  var _isLoading = false;

  Future<void> _moxoClicked() async {
    //
    if (_isLogedIn == false) {
      setState(() {
        _isLoading = true;
      });
      _moxoLogin();
      return;
    } else {
      FlutterPluginMep.showMEPWindow();
      return;
    }
  }

  _moxoLogin() async {
    var domain = dotenv.env['DOMAIN'];
    final response = await http.post(Uri.https(domain!, 'v1/core/oauth/token'),
        body: jsonEncode({
          'client_id': dotenv.env['CLIENT_ID'],
          'client_secret': dotenv.env['CLIENT_SECRET'],
          'org_id': dotenv.env['ORG_ID'],
          'email': dotenv.env['EMAIL']
        }),
        headers: {'Content-Type': 'application/json'});
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var accessToken = decodedResponse['access_token'];
    FlutterPluginMep.setupDomain(domain);
    FlutterPluginMep.linkUserWithAccessToken(accessToken)
        .then((response) => {
              setState(() {
                _isLoading = false;
              }),
              if (response != null &&
                  response is String &&
                  response == 'success')
                {
                  setState(() {
                    _isLogedIn = true;
                  })
                }
            })
        .onError((error, stackTrace) => {
              setState(() {
                _isLoading = false;
              }),
              handleError(error, stackTrace)
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isLogedIn
                ? Text(
                    'Welcome back, click the icon at bottom right to show Moxo!',
                    style: Theme.of(context).textTheme.headlineSmall)
                : Text(
                    'Welcome to Moxo Demo, click the icon at bottom right to start login!',
                    style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moxoClicked,
        tooltip: 'Increment',
        child: _isLoading
            ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Image.asset('assets/images/logo.png'),
      ),
    );
  }

  handleError(e, stackTrace) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Error code ${e.code}'),
      content: Text(e.message),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
