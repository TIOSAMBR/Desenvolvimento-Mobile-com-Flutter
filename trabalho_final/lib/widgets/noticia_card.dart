import 'package:flutter/material.dart';
import 'package:trabalho_final/models/noticia_model.dart';
import 'package:url_launcher/url_launcher.dart';  
import 'package:flutter/services.dart';  

class NoticiaCard extends StatelessWidget {
  final Noticia noticia;

  const NoticiaCard({required this.noticia});

  // Função para abrir a URL 
  void _abrirNoApp(BuildContext context, String url) async {
    print("Tentando abrir a URL no app: $url");

    if (url.isNotEmpty) {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://' + url;
      }

      final Uri uri = Uri.parse(url);
      final Uri appUri = Uri.parse('googlechrome://navigate?url=$url');

      if (await canLaunch(appUri.toString())) {
        await launch(appUri.toString()); 
      } else if (await canLaunch(uri.toString())) {
        await launch(uri.toString(), forceSafariVC: false, forceWebView: false); 
      } else {
        print('Não foi possível abrir a URL.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir a URL.')),
        );
      }
    } else {
      print('A URL está vazia');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('URL vazia!')),
      );
    }
  }

  void _copiarLink(BuildContext context, String url) async {
    if (url.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: url));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link copiado para a área de transferência!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('URL vazia!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              noticia.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(noticia.subtitle),
            trailing: Text(noticia.campus),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.open_in_browser),
                  onPressed: () => _abrirNoApp(context, noticia.url),
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () => _copiarLink(context, noticia.url),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}