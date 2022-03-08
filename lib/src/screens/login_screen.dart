import 'package:cookbook/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/user.dart';

class LoginScreen extends StatefulWidget {
  ServerController serverController;
  BuildContext context;

  LoginScreen(this.serverController, this.context, {Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//********************************************************************
//*************** Iniciación de variables ****************************
//********************************************************************
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userName = "";
  String password = "";
  String _errorMessage = "";

//********************************************************************
//*************** Init State *****************************************
//********************************************************************
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.serverController.init(widget.context);
  }

//********************************************************************
//********************* Pantalla *************************************
//********************************************************************
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
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
                height: mediaQuery.size.height * 0.25,
              ),
            ),
            Transform.translate(
              offset: Offset(0, -60),
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 3,
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, top: 260),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: "Usuario: "),
                            onSaved: (value) {
                              userName = value == null ? "" : value;
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
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: "Contraseña: "),
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
                          ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _loading
                                    ? Container(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        height: 20,
                                        width: 20,
                                      )
                                    : Icon(Icons.login),
                                SizedBox(
                                  width: 40,
                                ),
                                Text('Iniciar sesión'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff4dd0e1),
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () => _login(context),
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
                              TextButton(
                                child: Text(
                                  'Registrarse',
                                  style: TextStyle(color: Color(0xff4dd0e1)),
                                ),
                                onPressed: () => _showRegister(context),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//********************************************************************
//********************* Métodos **************************************
//********************************************************************
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
    Navigator.of(context).pushNamed('/register');
  }
}
