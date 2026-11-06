import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class EditUsuario extends StatefulWidget {
  const EditUsuario({super.key});

  @override
  State<EditUsuario> createState() => _EditUsuarioState();
}

class _EditUsuarioState extends State<EditUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _nocuentaController = TextEditingController();
  late String _uid;
  bool _argumentosCargados = false;
  bool _guardando = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argumentosCargados) {
      return;
    }

    final argumentos = ModalRoute.of(context)?.settings.arguments;
    if (argumentos is! Map<String, dynamic>) {
      throw FlutterError('Faltan los datos del usuario que se va a editar.');
    }

    final uid = argumentos['uid'];
    if (uid is! String || uid.isEmpty) {
      throw FlutterError('El usuario no tiene un identificador válido.');
    }

    _uid = uid;
    _nombreController.text = argumentos['nombre'] as String? ?? '';
    _emailController.text = argumentos['email'] as String? ?? '';
    _nocuentaController.text = argumentos['nocuenta'] as String? ?? '';
    _argumentosCargados = true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _nocuentaController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      await editarUsuario(
        _uid,
        _nombreController.text.trim(),
        _emailController.text.trim(),
        _nocuentaController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo actualizar el usuario: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar usuario')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre',
              ),
              textCapitalization: TextCapitalization.words,
              validator: _campoRequerido,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _campoRequerido,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nocuentaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'No. cuenta',
              ),
              validator: _campoRequerido,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardando ? null : _guardarCambios,
              child: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  String? _campoRequerido(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
}
