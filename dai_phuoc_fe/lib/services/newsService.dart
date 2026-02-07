import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

class NewsService {
  static const String httpEndpoint = 'https://phongkhamdaiphuoc.vn/vn/';

  Future<List<String>> getNews() async{
    List<String> imageUrls = [];
    
    try{

      final response = await http.get(
        Uri.parse(httpEndpoint + 'tin-tuc.html'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0',
          'Accept':'application/json, text/plain, */*'
        },
      );

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);

        String structureSelector = '#vnt-wrapper, #vnt-container, #vnt-content, .gdcontent .wrapper .vntconts #vtab1 .tphdkbsma .vntconts .slick-track';
        var mainContainer = document.querySelector(structureSelector);
        var listNews = mainContainer?.querySelectorAll('.slick-active .ithdkbsmb') ?? [];

        for(var newsElement in listNews){
          // test lấy danh sách ảnh trước
          var imageElement = newsElement.querySelector('.thumb img');
          var imageUrl = imageElement?.attributes['src'] ?? '';
          imageUrls.add(imageUrl);
        }
      }
      return imageUrls;
    }
    catch (e){
      throw Exception("Lỗi khi crawl $e");
    }
  }
}