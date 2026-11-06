import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = getUsuarios();
  }

  Future<void> _abrirFormulario() async {
    final usuarioAgregado = await Navigator.pushNamed<Object?>(context, '/add');
    _actualizarListaSiEsNecesario(usuarioAgregado);
  }

  Future<void> _abrirEdicion(Map<String, dynamic> usuario) async {
    final usuarioEditado = await Navigator.pushNamed<Object?>(
      context,
      '/edit',
      arguments: {
        'uid': usuario['uid'],
        'nombre': usuario['nombre'],
        'email': usuario['email'],
        'nocuenta': usuario['nocuenta'],
      },
    );
    _actualizarListaSiEsNecesario(usuarioEditado);
  }

  void _actualizarListaSiEsNecesario(Object? resultado) {
    if (resultado == true && mounted) {
      setState(() {
        _usuariosFuture = getUsuarios();
      });
    }
  }

  Future<bool> _confirmarEliminacion(String nombre) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmación'),
            content: Text('¿Estás seguro de querer eliminar a $nombre?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sí'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _eliminarUsuario(
    List<Map<String, dynamic>> usuarios,
    int index,
    String uid,
  ) async {
    usuarios.removeAt(index);
    setState(() {});

    try {
      await deleteUsuario(uid);
    } catch (error) {
      if (mounted) {
        setState(() {
          _usuariosFuture = getUsuarios();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo eliminar el usuario: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usuariosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No se pudieron cargar los usuarios.'),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _usuariosFuture = getUsuarios();
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final usuarios = snapshot.data ?? [];
          if (usuarios.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados.'));
          }

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final usuario = usuarios[index];
              final nombre = usuario['nombre'] as String? ?? 'Sin nombre';
              final inicial = nombre.trim().isEmpty
                  ? '?'
                  : nombre.trim().substring(0, 1).toUpperCase();
              final detalles =
                  [usuario['email'] as String?, usuario['nocuenta'] as String?]
                      .whereType<String>()
                      .where((valor) => valor.isNotEmpty)
                      .join(' · ');
              final uid = usuario['uid'] as String;

              return Dismissible(
                key: ValueKey(uid),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) => _confirmarEliminacion(nombre),
                onDismissed: (direction) async {
                  await _eliminarUsuario(usuarios, index, uid);
                },
                child: ListTile(
                  title: Text(nombre),
                  subtitle: detalles.isEmpty ? null : Text(detalles),
                  leading: CircleAvatar(child: Text(inicial)),
                  onTap: () => _abrirEdicion(usuario),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        tooltip: 'Agregar usuario',
        child: const Icon(Icons.add),
      ),
    );
  }
}
