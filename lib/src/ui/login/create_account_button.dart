import 'package:flutter/material.dart';
import 'package:manos_a_la_obra/src/repository/user_repository.dart';
import 'package:manos_a_la_obra/src/ui/register/register_screen.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
    :assert(userRepository!= null),
    _userRepository = userRepository,
    super(key: key);


  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Registrate!',
        style: TextStyle(
        color: Color(0xfff79c4f),
        fontSize: 13,
        fontWeight: FontWeight.w600),    
      ),
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context){
            return RegisterScreen(userRepository: _userRepository,);
          })
        );
      },
    );
  }
}