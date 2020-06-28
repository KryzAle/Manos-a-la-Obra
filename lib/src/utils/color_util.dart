import 'package:flutter/material.dart';

final _colors = <String,Color>{
  'purple'     : Colors.purpleAccent,
  'green' : Colors.greenAccent,
  'blue'   : Colors.blueAccent,
  'pink'   : Colors.pinkAccent,
  'yellow'   : Colors.yellowAccent,
  'red'   : Colors.redAccent,

};

Color getColor(String nombreColor){
  return _colors[nombreColor];
}