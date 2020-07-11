import 'dart:async';



class Validators {

  final validarEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      
      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(email)) {
        sink.add(email);
      }else{
        if(email.length>0) sink.addError('Correo no valido');
      }
    }
  );

  final validarPassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      if (password.length>=6) {
        sink.add(password);
      }else{
        if(password.length>0) sink.addError('Mas de 6 caracteres');
      }
    }
  );

  final validarTelefono = StreamTransformer<String,String>.fromHandlers(
    handleData: (telefono,sink){
      if(telefono != null){
        if (telefono.length == 10) {
          sink.add(telefono);
        }else{
          if(telefono.length>0) sink.addError('Debe tener 10 Digitos');
        }
      }else{
        sink.add('');
      }
    }
  );
}