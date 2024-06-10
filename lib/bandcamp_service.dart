import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'id_generator.dart';

class BandcampService {
  static Future<Map<String, dynamic>> fetchBandcampAlbumInfo(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var document = html_parser.parse(response.body);

      String title = document.querySelector('meta[property="og:title"]')?.attributes['content'] ?? 'Unknown Title';
      String artist = document.querySelector('meta[property="og:site_name"]')?.attributes['content'] ?? 'Unknown Artist';
      String artworkUrl = document.querySelector('meta[property="og:image"]')?.attributes['content'] ?? '';

      // Split the title to extract album name and artist separately
      List<String> titleParts = title.split(', by ');
      String albumName = titleParts.isNotEmpty ? titleParts[0].trim() : 'Unknown Album';
      String artistName = titleParts.length > 1 ? titleParts[1].trim() : artist;

      int collectionId = UniqueIdGenerator.generateUniqueCollectionId();

      return {
        'collectionId': collectionId,
        'collectionName': albumName,
        'artistName': artistName,
        'artworkUrl100': artworkUrl,
        'url': url,
        // 'tracks': BandcampParser.extractTracks(document, collectionId),
      };
    } else {
      throw Exception('Failed to load Bandcamp album');
    }
  }
}