import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    'BHPi7wjE30O7vVhC6EVbVbO9syrShM1oUlXwxfyQ',
    'https://parseapi.back4app.com',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Pessoas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CadastroPessoaScreen(),
    );
  }
}

class CadastroPessoaScreen extends StatefulWidget {
  const CadastroPessoaScreen({super.key});

  @override
  _CadastroPessoaScreenState createState() => _CadastroPessoaScreenState();
}

class _CadastroPessoaScreenState extends State<CadastroPessoaScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  File _foto;

  void _selecionarFoto() {
    // Implemente a lógica para selecionar uma foto da galeria ou da câmera
  }

  Future<void> _salvarPessoa() async {
    final nome = _nomeController.text;
    final sobrenome = _sobrenomeController.text;

    if (nome.isEmpty || sobrenome.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Campos obrigatórios'),
            content: const Text('Preencha todos os campos antes de salvar.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final pessoa = ParseObject('Pessoa')
      ..set('nome', nome)
      ..set('sobrenome', sobrenome);

    final parseFile = ParseFile(_foto, name: 'foto.jpg');
    await parseFile.save();
    pessoa.set<ParseFile>('foto', parseFile);
  
    try {
      await pessoa.save();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Pessoa salva com sucesso!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      _nomeController.clear();
      _sobrenomeController.clear();
      setState(() {
        _foto = null;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content:
                const Text('Ocorreu um erro ao salvar a pessoa. Tente novamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pessoas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _sobrenomeController,
              decoration: const InputDecoration(labelText: 'Sobrenome'),
            ),
            const SizedBox(height: 16.0),
            _foto != null
                ? Image.file(_foto)
                : const Text('Nenhuma foto selecionada'),
            ElevatedButton(
              onPressed: _selecionarFoto,
              child: const Text('Selecionar Foto'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _salvarPessoa,
              child: const Text('Salvar Pessoa'),
            ),
          ],
        ),
      ),
    );
  }
}
