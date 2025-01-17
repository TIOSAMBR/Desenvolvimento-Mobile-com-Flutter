import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teste/models/anuncio.dart';

class AnuncioFormScreen extends StatefulWidget {
  final Anuncio? anuncio;

  const AnuncioFormScreen({Key? key, this.anuncio}) : super(key: key);

  @override
  _AnuncioFormScreenState createState() => _AnuncioFormScreenState();
}

class _AnuncioFormScreenState extends State<AnuncioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _precoController;
  String? _imagePath;  // Guardar o caminho da imagem

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.anuncio != null) {
      _tituloController = TextEditingController(text: widget.anuncio!.titulo);
      _descricaoController = TextEditingController(text: widget.anuncio!.descricao);
      _precoController = TextEditingController(text: widget.anuncio!.preco.toString());
      _imagePath = widget.anuncio!.imagem;  // Carregar o caminho da imagem se o anúncio existir
    } else {
      _tituloController = TextEditingController();
      _descricaoController = TextEditingController();
      _precoController = TextEditingController();
      _imagePath = null;
    }
  }

  // Função para escolher uma imagem da galeria ou tirar uma foto
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); 

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;  // Atualiza o caminho da imagem
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final titulo = _tituloController.text;
      final descricao = _descricaoController.text;
      final preco = double.parse(_precoController.text);

      final anuncio = Anuncio(
        id: widget.anuncio?.id,
        titulo: titulo,
        descricao: descricao,
        preco: preco,
        imagem: _imagePath,  // Passa o caminho da imagem para o Anuncio
      );

      Navigator.pop(context, anuncio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.anuncio == null ? 'Novo Anúncio' : 'Editar Anúncio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Roboto', 
          ),
          ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),  
        elevation: 0,  
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Título do anúncio
              TextFormField(
                controller: _tituloController,
                style: TextStyle(color: Colors.white),  
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: Colors.grey[400]),  
                  filled: true,  
                  fillColor: Colors.black87,  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,  
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // Descrição do anúncio
              TextFormField(
                controller: _descricaoController,
                style: TextStyle(color: Colors.white),  
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.black87,  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),

              // Preço do anúncio
TextFormField(
  controller: _precoController,
  style: TextStyle(color: Colors.white),
  decoration: InputDecoration(
    labelText: 'Preço',
    labelStyle: TextStyle(color: Colors.grey[400]),
    filled: true,
    fillColor: Colors.black87,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  keyboardType: TextInputType.numberWithOptions(decimal: true), // Permite números com ponto decimal
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Permite apenas números e ponto decimal
  ],
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o preço';
    }
    // Valida se o valor é um número válido
    if (double.tryParse(value) == null) {
      return 'Por favor, insira um preço válido';
    }
    return null;
  },
),
SizedBox(height: 20),

              // Botão para selecionar imagem
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,  
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.grey), 
                ),
                child: Text(
                  _imagePath == null ? 'Selecionar Imagem' : 'Imagem Selecionada',
                  style: TextStyle(color: Colors.white),  
                ),
              ),
              if (_imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_imagePath!),
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),

              // Botão de salvar ou atualizar
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,  
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.grey), 
                ),
                child: Text(
                  widget.anuncio == null ? 'Salvar' : 'Atualizar',
                  style: TextStyle(color: Colors.white), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
