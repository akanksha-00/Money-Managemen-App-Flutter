import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:money_manage_project/consts/formField.dart';
import 'package:money_manage_project/logic/bloc/authentication/authentication_bloc.dart';
import 'package:money_manage_project/logic/bloc/authentication/authentication_event.dart';
import 'package:money_manage_project/logic/bloc/authentication/authentication_state.dart';
import 'package:money_manage_project/logic/cubit/user_cubit.dart';

// ignore: must_be_immutable
class AuthBuilder extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);

    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthFail) {
        print('Listening AuthFail');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          state.error,
          softWrap: true,
        )));
      } else if (state is AuthSuccess) {
        userCubit.changeUID(state.user.uid);
      }
    }, builder: (context, state) {
      print('Rebuiding');
      //print(state.isValidEmail);
      //print(state.isValidPassword);
      return KeyboardDismisser(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: Colors.redAccent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 50.0),
                    child: Column(
                      children: [
                        Text(
                          authBloc.isLogin ? 'Login ' : 'Register ',
                          style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Money Mangement App!',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0))),
                    padding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 50.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.0,
                        ),
                        TextFormField(
                            controller: email,
                            decoration: textFormFieldDecoration.copyWith(
                                hintText: 'Email',
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email)),
                            validator: (val) {},
                            onChanged: (val) {
                              authBloc.add(EmailModified(email: val.trim()));
                            }),
                        SizedBox(
                          height: 5.0,
                        ),
                        state is AppStarted
                            ? Container()
                            : Text(
                                authBloc.isValidEmail ? "" : "Invalid Email",
                                style: TextStyle(color: Colors.red[900]),
                              ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                            obscureText: true,
                            controller: password,
                            decoration: textFormFieldDecoration.copyWith(
                                hintText: 'Password',
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock)),
                            validator: (val) {},
                            onChanged: (val) {
                              authBloc
                                  .add(PasswordModified(password: val.trim()));
                            }),
                        SizedBox(
                          height: 10.0,
                        ),
                        state is AppStarted
                            ? Container()
                            : Text(
                                authBloc.isValidPassword
                                    ? ""
                                    : "Password must consist of atleast 8 characters.",
                                style: TextStyle(color: Colors.red[900])),
                        SizedBox(
                          height: 35.0,
                        ),
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: MaterialButton(
                            color: Colors.tealAccent[700],
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 30.0),
                              child: button(context.read<AuthBloc>().isLogin
                                  ? 'Login'
                                  : 'Register'),
                            ),
                            onPressed: () {
                              if (context.read<AuthBloc>().isLogin == true) {
                                authBloc.add(LoginSubmit());
                              } else {
                                authBloc.add(RegisterSubmit());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 17.0,
                  ),
                  authBloc.isLoading
                      ? CircularProgressIndicator()
                      : MaterialButton(
                          child: Text(
                            context.read<AuthBloc>().isLogin
                                ? "New User? Register Here."
                                : "Existing user? Login Here.",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                          onPressed: () {
                            authBloc.add(ToggleIsLogin());
                          },
                        )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
