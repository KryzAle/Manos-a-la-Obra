import 'package:flutter/material.dart';

final _icons = <String,IconData>{
  'laptop'     : Icons.laptop,
  'shopping_cart' : Icons.shopping_cart,
  'kitchen'   : Icons.kitchen,
  'tv'   : Icons.tv,
  'motorcycle' : Icons.motorcycle,
  'pet' : Icons.pets,
  'lock' : Icons.lock_outline,
  'mail' : Icons.mail_outline,
  'build': Icons.build,
  'book' : Icons.book,
  'gavel' : Icons.gavel,
  'face' : Icons.face,
  'fitness_center' : Icons.fitness_center,
  'fastfood' : Icons.fastfood,
  'format_paint' : Icons.format_paint,
  'local_car_wash' : Icons.local_car_wash,
  'local_dining' : Icons.local_dining,
  'local_florist' : Icons.local_florist,
  'local_laundry_service' : Icons.local_laundry_service,
  'local_mall' : Icons.local_mall,
  'local_hospital' : Icons.local_hospital,
  'local_grocery_store' : Icons.local_grocery_store,
  'local_shipping' : Icons.local_shipping,
  'local_taxi' : Icons.local_taxi,
};

IconData getIcon(String nombreIcono){
  return _icons[nombreIcono];
}