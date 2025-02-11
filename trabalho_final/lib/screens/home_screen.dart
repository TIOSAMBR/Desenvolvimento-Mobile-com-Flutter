import 'package:flutter/material.dart';
import 'package:trabalho_final/models/noticia_model.dart';
import 'package:trabalho_final/services/api_service.dart';
import 'package:trabalho_final/widgets/noticia_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Noticia> _noticias = [];
  bool _isLoading = false;
  int _pagina = 1;
  List<String> _campiSelecionados = [];
  final List<String> _todosCampi = [
    'Morrinhos', 'Reitoria', 'Urutaí', 'Campos Belos', 'Catalão', 'Ceres',
    'Cristalina', 'Hidrolândia', 'Ipameri', 'Iporá', 'Posse', 'Rio Verde',
    'Trindade', 'Polo de Inovação', 'Centro de Referência'
  ];

  @override
  void initState() {
    super.initState();
    _carregarNoticias();
  }

  Future<void> _carregarNoticias() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final novasNoticias = await ApiService.fetchNoticias(_pagina);
      setState(() {
        _pagina++;
        _noticias.addAll(novasNoticias);
      });
    } catch (e) {
      print('Erro ao carregar notícias: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Noticia> _filtrarNoticiasPorCampus(List<Noticia> noticias) {
    if (_campiSelecionados.isEmpty) {
      return noticias;
    }
    return noticias.where((noticia) => _campiSelecionados.contains(noticia.campus)).toList();
  }

  void _mostrarDialogoSelecaoCampus() async {
    final List<String> selecionados = List.from(_campiSelecionados);

    final List<String>? novosSelecionados = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Selecionar Campos IF',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 400,
            width: double.maxFinite,
            child: ListView(
              children: _todosCampi.map((campus) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return CheckboxListTile(
                      title: Text(
                        campus,
                        style: TextStyle(fontSize: 16),
                      ),
                      value: selecionados.contains(campus),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selecionados.add(campus);
                          } else {
                            selecionados.remove(campus);
                          }
                        });
                      },
                      activeColor: Colors.teal,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(selecionados);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Aplicar'),
            ),
          ],
        );
      },
    );

    if (novosSelecionados != null) {
      setState(() {
        _campiSelecionados = novosSelecionados;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notícias IF Goiano', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: _mostrarDialogoSelecaoCampus,
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _carregarNoticias();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _filtrarNoticiasPorCampus(_noticias).length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _filtrarNoticiasPorCampus(_noticias).length) {
              return Center(child: CircularProgressIndicator());
            } else {
              return NoticiaCard(noticia: _filtrarNoticiasPorCampus(_noticias)[index]);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _pagina = 1;
            _noticias.clear();
            _carregarNoticias();
          });
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
