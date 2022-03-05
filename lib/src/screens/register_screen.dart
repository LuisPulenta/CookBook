import 'dart:io';

import 'package:cookbook/connection/server_controller.dart';
import 'package:cookbook/src/components/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/user.dart';

ServerController _serverController = ServerController();

class RegisterScreen extends StatefulWidget {
  ServerController serverController;
  BuildContext context;
  User userToEdit;

  RegisterScreen(this.serverController, this.context,
      {Key key, this.userToEdit})
      : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();

  String userName = "";
  String password = "";
  Genrer genrer = Genrer.MALE;

  String _errorMessage = "";
  File imageFile;
  bool showPassword = false;
  bool editingUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            ImagePickerWidget(
              imageFile: this.imageFile,
              onImageSelected: (File file) {
                setState(() {
                  imageFile = file;
                });
              },
            ),
            SizedBox(
              child: AppBar(
                title: Text("Registrarse"),
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              height: kToolbarHeight + 25,
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, -60),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: 260, bottom: 20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          initialValue: userName,
                          decoration: InputDecoration(
                            label: Text("Usuario:"),
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
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
                          initialValue: password,
                          decoration: InputDecoration(
                            label: Text("Contraseña:"),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: !showPassword,
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
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Género:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RadioListTile(
                                    activeColor: Color(0xff4dd0e1),
                                    title: Text(
                                      "Masculino",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: Genrer.MALE,
                                    groupValue: genrer,
                                    onChanged: (value) {
                                      setState(() {
                                        genrer = value;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    activeColor: Color(0xff4dd0e1),
                                    title: Text(
                                      "Femenino",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: Genrer.FEMALE,
                                    groupValue: genrer,
                                    onChanged: (value) {
                                      setState(() {
                                        genrer = value;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              textColor: Colors.white,
                              onPressed: () => _doProcess(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.person_add),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                      editingUser ? "Actualizar" : "Registrar"),
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
                      ],
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

  void showSnackbar(BuildContext context, String title, Color backColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: backColor,
        // duration: Duration(seconds: 3),
      ),
    );
  }

  _doProcess(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (imageFile == null) {
        showSnackbar(context, "Seleccione una imagen por favor", Colors.red);
        return;
      }

      User user = User(
          id: 0,
          genrer: this.genrer,
          nickname: this.userName,
          password: this.password,
          photo: this.imageFile);
      var state;
      if (editingUser) {
        user.id = widget.serverController.loggedUser.id;
        state = await widget.serverController.updateUser(user);
      } else {
        state = await widget.serverController.addUser(user);
      }
      final action = editingUser ? "actualizar" : "guardar";
      final action2 = editingUser ? "actualizado" : "guardado";

      if (state == false) {
        showSnackbar(context, "No se pudo $action", Colors.orange);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Información"),
              content: Text("Su usuario ha sido $action2 con éxito."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            );
          },
        );
      }
    }
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editingUser = (widget.userToEdit != null);
    if (editingUser) {
      userName = widget.userToEdit.nickname;
      password = widget.userToEdit.password;
      imageFile = widget.userToEdit.photo;
      genrer = widget.userToEdit.genrer;
    }
  }
}
