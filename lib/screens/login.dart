import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passworKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool isloading = false;
  bool _obscureText = true;

  void _toggle() {
    setState(
      () {
        _obscureText = !_obscureText;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/huvica.jpg',
            scale: 9,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Text(
                    'Inicia sesión',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.blue[900],
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ]),
              ),
              Form(
                key: _emailKey,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value.toString().trim();
                  },
                  decoration: const InputDecoration(
                    hintText: 'ejemplo@ejemplo.com',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    border: UnderlineInputBorder(),
                    labelText: 'Correo electrónico',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _passworKey,
                child: TextFormField(
                  obscureText: _obscureText,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      onPressed: _toggle,
                      icon: _obscureText
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      color: Colors.black,
                    ),
                    border: const UnderlineInputBorder(),
                    labelText: 'Contraseña',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: '¿Olvidate tu contraseña?',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(
                            title: 'Home',
                          ),
                        ),
                      );
                    },
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_emailKey.currentState!.validate() &&
                  _passworKey.currentState!.validate()) {
                try {
                  await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(
                        title: 'Inicio',
                      ),
                    ),
                  );
                  setState(() {
                    isloading = false;
                  });
                } on FirebaseAuthException {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Oops! Inicio de sesión erroneo!"),
                      content: const Text(
                          'Correo o contraseña erroneos. verifica tus datos e intenta nuevamente.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                  setState(() {
                    isloading = false;
                  });
                }
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: const Size(250, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Colors.blue),
              ),
            ),
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Raleway',
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 30.0,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('O'),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                  ),
                ]),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(const Size(250, 40)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Iniciar como invitado',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Raleway',
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Colors.blue),
              ),
              fixedSize: const Size(250, 40),
            ),
            onPressed: () {},
            child: const Text(
              'Registrarse',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Raleway',
                color: Colors.white,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
