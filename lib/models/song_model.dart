class Song {
  final String id;
  final String title;
  final String description;
  final String url;
  final String coverUrl;
  int like;
  int dislike;
  int superlike;
  final String username;

  Song({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
    required this.like,
    required this.dislike,
    required this.superlike,
    required this.username,
  });

  static List<Song> songs = [
    Song(
      id: '1',
      title: 'Instru regeatton ',
      description: 'Mds',
      url: 'assets/music/mds-regeatton-deogo.mp3',
      coverUrl: 'assets/images/photo-1470225620780-dba8ba36b745.jpeg',
      like: 0,
      dislike: 0,
      superlike: 0,
      username: '',
    ),
    Song(
      id: '2',
      title: "coeur d'étranger",
      description: "coeur d'étranger",
      url: 'assets/music/Mele-Coeur-d_etranger-2.mp3',
      coverUrl:
          'assets/images/pngtree-note-music-logo-watercolor-background-picture-image_1589075.jpg',
      like: 0,
      dislike: 0,
      superlike: 0,
      username: '',
    ),
    Song(
      id: '3',
      title: 'Mds Beat Guitare',
      description: 'Mds Beat Guitare',
      url: 'assets/music/Mds-type-beat-guiatre-bpm-158-08.01.2023.mp3',
      coverUrl: 'assets/images/download.jpeg',
      like: 0,
      dislike: 0,
      superlike: 0,
      username: '',
    ),
    Song(
      id: '4',
      title: 'Pronto',
      description: 'Nero',
      url: 'assets/music/Nero-Pronto.mp3',
      coverUrl: 'assets/images/pexels-eric-esma-894156.jpg',
      like: 0,
      dislike: 0,
      superlike: 0,
      username: '',
    ),
  ];
}
