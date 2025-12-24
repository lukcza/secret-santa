import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';    
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

import 'login_page.dart';

class AuthWrapper extends StatelessWidget {
const AuthWrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
      return BlocBuilder<AuthBloc, AuthState>(builder: (context, state){
        if(state.status == AuthStatus.authenticated){
          return const Scaffold(
            body: Center(child: Text("Jesteś zalogowany! (Tu będzie HomePage)")),
          );
        } 
        if(state.status == AuthStatus.loading){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return LoginPage();
      } 
    );
  }
}