class Noticia {
  final int idSite;
  final String title;
  final String subtitle;
  final String url;
  final String campus;
  final String dateString;
  final String? dataPublicacao;

  Noticia({
    required this.idSite,
    required this.title,
    required this.subtitle,
    required this.url,
    required this.campus,
    required this.dateString,
    this.dataPublicacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'idSite': idSite,
      'title': title,
      'subtitle': subtitle,
      'url': url,
      'campus': campus,
      'dateString': dateString,
      'dataPublicacao': dataPublicacao,
    };
  }

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      idSite: json['idSite'] ?? 0,
      title: json['title'] ?? 'Título não disponível',
      subtitle: json['subtitle'] ?? 'Subtítulo não disponível',
      url: json['url'] ?? '',
      campus: json['campus'] ?? 'Campus não especificado',
      dateString: json['dateString'] ?? 'Data não disponível',
      dataPublicacao: json['dataPublicacao'],
    );
  }
}
