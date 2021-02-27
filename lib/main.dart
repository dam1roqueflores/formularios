import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:mysql1/mysql1.dart';

void main() => runApp(MyApp());
const miPadding=10.0;
final miFontSize=30.0;
// creamos controller de los textfield para recuperar su valor
final userController = TextEditingController();
final pwdController = TextEditingController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Validación de texto';

// formulario de login
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar( title: Text(appTitle),
        ),
        body: SingleChildScrollView(child: MyCustomForm()),
      ),
    );
  }
}

// Crea un Widget Form
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() { return MyCustomFormState();
  }
}

// Crea una clase State correspondiente. Esta clase contendrá los datos relacionados con
// el formulario.
class MyCustomFormState extends State<MyCustomForm> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  final _formKey = GlobalKey<FormState>();

  // nos aseguramos de disposar los texteditingcontrollrs
  @override
  void dispose() {
    userController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override Widget build(BuildContext context) {
    // Crea un widget Form usando el _formKey que creamos anteriormente
    return Form(
      key: _formKey,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
      // Stroked text as border.
      Stack(
      children: <Widget> [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: miPadding),
          child: Text(
            'Usuario',
            style: TextStyle(
                fontSize: miFontSize,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.blue[900],
            ),
          ),
        ),
      // Solid text as fill.
      Padding(
        padding: const EdgeInsets.symmetric(vertical: miPadding),
        child: Text(
            'Usuario',
            style: TextStyle(
              fontSize: miFontSize,
              foreground: Paint()
                ..shader = ui.Gradient.linear (
                  const Offset(100, 50),
                  const Offset(170, 20),
                  <Color>[
                    Colors.blue,
                    Colors.purpleAccent,
                  ],
                )
            ),
          ),
        ),
      ],
    ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: miPadding,),
          child:TextFormField(
            controller: userController,
            decoration: InputDecoration(
              labelText: 'Escriba su Usuario',
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Debe de introducir algún texto';
              }
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        // Stroked text as border.
        Stack(
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: miPadding),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: miFontSize,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 5
                    ..color = Colors.blue[900],
                ),
              ),
            ),
            // Solid text as fill.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: miPadding),
              child: Text(
                'Login',
                style: TextStyle(
                    fontSize: miFontSize,
                    foreground: Paint()
                      ..shader = ui.Gradient.linear (
                        const Offset(200, 20),
                        const Offset(150, 20),
                        <Color>[
                          Colors.blue,
                          Colors.purpleAccent,
                        ],
                      )
                ),
              ),
            ),
          ],
        ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: miPadding,),
            child:TextFormField(
              controller: pwdController,
              decoration: InputDecoration(
                labelText: 'Escriba su login',
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Debe de introducir algún texto';
                }
              },
              keyboardType: TextInputType.emailAddress,
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: miPadding),
          child: ElevatedButton(
            onPressed: () {
              // devolverá true si el formulario es válido, o falso si
              // el formulario no es válido.
              if (_formKey.currentState.validate()) {
                // Si el formulario es válido, queremos mostrar un Snackbar
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Conectando a la base de datos...')));
                // llama al login BD
                login();

              } else {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Login incorrecto')));
              }
            },
            child: Text('Login'),
          ),
        ),
      ],
      ),
    );
  }

  // conectar a BD
  Future login() async {
    // Open a connection
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost', port: 3306, user: 'usuario_hibernate', db: '1234'));

    // Query the database using a parameterized query
    var results = await conn
        .query('select nombre, password from usuarios where nombre = ? and password = ?;', [userController.text, pwdController.text]);
    for (var row in results) {
      print('Nombre: ${row[0]}, password: ${row[1]}');
      if (row.length>0) {

      }
    }

    // Finally, close the connection
    await conn.close();
  }
}