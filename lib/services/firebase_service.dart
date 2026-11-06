import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getUsuarios() async {
  final queryUsuarios = await db.collection('usuarios').get();
  return queryUsuarios.docs.map((documento) {
    return {...documento.data(), 'uid': documento.id};
  }).toList();
}

Future<void> agregarUsuario(
  String nombre,
  String email,
  String nocuenta,
) async {
  await db.collection('usuarios').add({
    'nombre': nombre,
    'email': email,
    'nocuenta': nocuenta,
  });
}

Future<void> editarUsuario(
  String uid,
  String nombre,
  String email,
  String nocuenta,
) async {
  await db.collection('usuarios').doc(uid).update({
    'nombre': nombre,
    'email': email,
    'nocuenta': nocuenta,
  });
}

Future<void> deleteUsuario(String uid) async {
  await db.collection('usuarios').doc(uid).delete();
}
