class Anuncio {
  int? id;
  String titulo;
  String descricao;
  double preco;
  String? imagem;  //armazenar o caminho da imagem 
  Anuncio({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.preco,
    this.imagem,
  });

  // Converter um objeto Anuncio para um mapa (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'preco': preco,
      'imagem': imagem, // Salva o caminho da imagem
    };
  }

  // Converter um mapa para um objeto Anuncio
  factory Anuncio.fromMap(Map<String, dynamic> map) {
    return Anuncio(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      preco: map['preco'],
      imagem: map['imagem'], // recupera o caminho da imagem
    );
  }
}
