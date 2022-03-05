// ignore_for_file: prefer_const_constructors

import 'package:cookbook/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/user.dart';

class LoginScreen extends StatefulWidget {
  ServerController serverController;
  BuildContext context;

  LoginScreen(this.serverController, this.context, {Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userName = "";
  String password = "";

  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 60),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff4dd0e1),
                      Color(0xff00838f),
                    ],
                  ),
                ),
                child: Image.asset(
                  "assets/logo.png",
                  color: Colors.white,
                  height: 200,
                )),
            Transform.translate(
              offset: Offset(0, -60),
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 15,
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 260, bottom: 20),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                InputDecoration(label: Text("Usuario:")),
                            onSaved: (value) {
                              userName = value == null ? "" : value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text("Contraseña:"),
                            ),
                            obscureText: true,
                            onSaved: (value) {
                              password = value == null ? "" : value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Este campo es obligatorio";
                              }
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: Colors.white),
                            child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                textColor: Colors.white,
                                onPressed: () => _login(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.login),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("Iniciar Sesión"),
                                    if (_loading)
                                      (Container(
                                        height: 20,
                                        width: 20,
                                        margin: const EdgeInsets.only(left: 20),
                                        child: CircularProgressIndicator(),
                                      ))
                                  ],
                                )),
                          ),
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("¿No estás registrado?"),
                              SizedBox(
                                width: 20,
                              ),
                              FlatButton(
                                  onPressed: () {
                                    _showRegister(context);
                                  },
                                  textColor: Theme.of(context).primaryColor,
                                  child: Text("Registrarse")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    if (!_loading) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          _loading = true;
          _errorMessage = "";
        });
        User user = await widget.serverController.login(userName, password);
        if (user != null) {
          Navigator.of(context).pushReplacementNamed("/home", arguments: user);
        } else {
          setState(() {
            _errorMessage = "Usuario o contraseña incorrectos";
            _loading = false;
          });
        }
      }
    }
  }

  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/register',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.serverController.init(widget.context);
  }
}
