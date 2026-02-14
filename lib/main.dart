import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(home: BikeApp(), debugShowCheckedModeBanner: false));

class BikeApp extends StatefulWidget {
  @override
  _BikeAppState createState() => _BikeAppState();
}

class _BikeAppState extends State<BikeApp> {
  List _d = [];
  int _id = 1, _c = 0;
  bool _a = false;
  String _dev = "BK-${DateTime.now().millisecond}";

  @override
  void initState() { super.initState(); _l(); }

  _l() async {
    String s = await rootBundle.loadString('assets/data.json');
    setState(() => _d = json.decode(s));
  }

  _go(int n) {
    if (!_a) _c++;
    if (_c > 3 && !_a) {
      showDialog(context: context, builder: (c) => AlertDialog(
        title: Text("تفعيل النسخة"),
        content: Text("رقمك: $_dev"),
        actions: [ElevatedButton(onPressed: () => launchUrl(Uri.parse("https://wa.me/249999240574?text=$_dev")), child: Text("واتساب"))],
      ));
    } else { setState(() => _id = n); }
  }

  @override
  Widget build(BuildContext context) {
    if (_d.isEmpty) return Scaffold(body: Center(child: CircularProgressIndicator()));
    var item = _d.firstWhere((i) => i['id'] == _id);
    return Scaffold(
      appBar: AppBar(title: Text("صيانة العجلة (${_c}/3)"), backgroundColor: Colors.blueGrey),
      body: Center(child: item['isFinal'] == true 
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(item['solution'], style: TextStyle(fontSize: 20)), ElevatedButton(onPressed: () => setState(()=> _id=1), child: Text("عودة"))])
        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(item['question'], style: TextStyle(fontSize: 22)), Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(onPressed: () => _go(item['yes']), child: Text("نعم")), SizedBox(width: 20),
            ElevatedButton(onPressed: () => _go(item['no']), child: Text("لا"))])])),
    );
  }
}
