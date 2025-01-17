import 'dart:io';  
import 'package:flutter/material.dart';
import 'package:teste/models/anuncio.dart';
import 'package:teste/database_helper.dart';
import 'package:teste/anuncio_form_screen.dart';
import 'package:url_launcher/url_launcher.dart'; 

class AnuncioListaScreen extends StatefulWidget {
  @override
  _AnuncioListaScreenState createState() => _AnuncioListaScreenState();
}

class _AnuncioListaScreenState extends State<AnuncioListaScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Anuncio> _anuncios = [];

  @override
  void initState() {
    super.initState();
    _fetchAnuncios();
  }

  Future<void> _fetchAnuncios() async {
    final data = await _dbHelper.fetchAnuncios();
    setState(() {
      _anuncios = data;
    });
  }

  void _addAnuncio() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnuncioFormScreen(),
      ),
    );
    if (result != null) {
      await _dbHelper.insertAnuncio(result);
      _fetchAnuncios();
    }
  }

  void _editAnuncio(Anuncio anuncio) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnuncioFormScreen(anuncio: anuncio),
      ),
    );
    if (result != null) {
      await _dbHelper.updateAnuncio(result);
      _fetchAnuncios();
    }
  }

  void _deleteAnuncio(int id) async {
    await _dbHelper.deleteAnuncio(id);
    _fetchAnuncios();
  }

  Future<void> sendUrlLauncher(String dest, Anuncio anuncio) async {
  late final Uri url;
  String body =
      "*Título:* ${anuncio.titulo}\n\n" 
      "*Descrição:* ${anuncio.descricao}\n\n" 
      "*Preço:* R\$ ${anuncio.preco.toStringAsFixed(2)}\n\n" 
    ; 

  switch (dest) {
    case 'Email':
      url = Uri(
        scheme: 'mailto',
        path: '',
        queryParameters: {
          "to": "",
          "subject": "Anúncio: ${anuncio.titulo}",
          "body": body,
        },
      );

      if (Platform.isAndroid) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            headers: {'package': 'com.google.android.gm'},
          ),
        );
      } else {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw 'Não foi possível abrir o aplicativo Gmail';
        }
      }
      break;
    case "Sms":
      url = Uri(
        scheme: "sms",
        path: "",
        queryParameters: {'body': body},
      );
      break;
    case "Whatsapp":
      url = Uri(
        scheme: "https",
        host: "wa.me",
        path: "", 
        queryParameters: {"text": body},
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Não foi possível abrir o navegador para WhatsApp Web';
      }
      break;
    default:
      throw 'Destino inválido: $dest';
  }

  if (dest != 'Email' && dest != 'Whatsapp') {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Não foi possível abrir o aplicativo para $dest';
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mercado Negro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Roboto', 
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 4, 
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchAnuncios,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _anuncios.length,
        itemBuilder: (context, index) {
          final anuncio = _anuncios[index];
          return Card(
            color: Colors.black87, 
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8, 
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Row(
                children: [
                  if (anuncio.imagem != null)
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(anuncio.imagem!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12), 
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anuncio.titulo,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.white, 
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          anuncio.descricao,
                          style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                          overflow: TextOverflow.ellipsis, 
                          maxLines: 3, 
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'R\$ ${anuncio.preco.toStringAsFixed(2)}', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 255, 255, 255), 
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PopupMenuButton<String>(
                    icon: Icon(Icons.share, color: Colors.blue),
                    onSelected: (choice) {
                      sendUrlLauncher(choice, anuncio);
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Email', 'Sms', 'Whatsapp'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                  const SizedBox(width: 1), 
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteAnuncio(anuncio.id!),
                  ),
                ],
              ),
              onTap: () => _editAnuncio(anuncio), 
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAnuncio,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), 
        child: Icon(Icons.add, size: 30),
        elevation: 10, 
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29), 
    );
  }
}
