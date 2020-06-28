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
};

IconData getIcon(String nombreIcono){
  return _icons[nombreIcono];
}