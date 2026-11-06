import 'package:appfirebase/pages/add_usuario_page.dart';
import 'package:appfirebase/pages/edit_usuario_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el formulario de usuario muestra sus campos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AddUsuario()));

    expect(find.text('Agregar usuario'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('No. cuenta'), findsOneWidget);
    expect(find.text('Guardar'), findsOneWidget);
  });

  testWidgets('el formulario de edición carga los datos recibidos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/': (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/edit',
                  arguments: {
                    'uid': 'usuario-1',
                    'nombre': 'Ana Pérez',
                    'email': 'ana@example.com',
                    'nocuenta': '12345',
                  },
                );
              },
              child: const Text('Editar'),
            ),
          ),
          '/edit': (context) => const EditUsuario(),
        },
      ),
    );

    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();

    final campos = tester.widgetList<TextFormField>(
      find.byType(TextFormField),
    );
    expect(
      campos.map((campo) => campo.controller!.text).toList(),
      ['Ana Pérez', 'ana@example.com', '12345'],
    );
    expect(find.text('Actualizar'), findsOneWidget);
  });
}
