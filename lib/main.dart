import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';



void main() async {

  Map _data = await getData();
  List _features = _data['features'];

  //var date = _features[0]['properties']['time'];
 // var dateFormatted = _formatDate(date);

  //print('The formatted date is $dateFormatted');

  //debugPrint('the features is $_features');

  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        title: new Text(
          'Quakes',
          style: new TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
      ),
      body: new Center(
        child: new ListView.builder(
           padding: const EdgeInsets.all(8.0),
            itemCount: _features.length,
            itemBuilder: (BuildContext context, int position){

             int index = position ~/ 2;

             var date = _features[index]['properties']['time'];

             var dateString = _formatDate(date);

             if(position.isOdd)
               {
                 return new Divider();
               }

               return new ListTile(

                 leading: new CircleAvatar(
                   backgroundColor: Colors.lightGreen,
                   child: new Text('${_features[index]['properties']['mag']}',
                   style: new TextStyle(color: Colors.white),),
                 ),

                 title: new Text('$dateString',
                 style: new TextStyle(color: Colors.orange[300],
                 fontWeight: FontWeight.w600,
                 fontSize: 15.0),),

                 subtitle: new Text('${_features[index]['properties']['place']}',
                 style: new TextStyle(
                   color: Colors.grey[400],
                   fontStyle: FontStyle.italic
                 ),),

                 onTap: () => _showAlert(context, '${_features[index]['properties']['place']}'),

               );
            })
      ),
    ),
  ));
}

Future<Map> getData() async
{
  String url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(url);

  return json.decode(response.body);
}

String _formatDate(int input)
{
  var formatter = new DateFormat('LLL d, y hh:mm a');

  var dateTime = new DateTime.fromMillisecondsSinceEpoch(input);

  String formatted = formatter.format(dateTime);

  return formatted;

}

void _showAlert(BuildContext context, String message)
{
  var alert = new AlertDialog(

    title: new Text('Quake'),
    content: new Text('$message'),
    actions: <Widget>[
      new FlatButton(
        onPressed: (){
          Navigator.pop(context);
        },
        child: new Text('Ok'),
      )
    ],
  );

  showDialog(context: context, builder: (context) => alert);
}
