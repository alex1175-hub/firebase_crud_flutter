import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class AddUsuario extends StatefulWidget {
  const AddUsuario({super.key});

  @override
  State<AddUsuario> createState() => _AddUsuarioState();
}

class _AddUsuarioState extends State<AddUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _nocuentaController = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _nocuentaController.dispose();
    super.dispose();
  }

  Future<void> _guardarUsuario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      await agregarUsuario(
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
          SnackBar(content: Text('No se pudo guardar el usuario: $error')),
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
      appBar: AppBar(title: const Text('Agregar usuario')),
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
              onPressed: _guardando ? null : _guardarUsuario,
              child: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
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
