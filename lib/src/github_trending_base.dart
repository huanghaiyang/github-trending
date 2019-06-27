import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

final String github_url = 'https://github.com/';
final linkPattern = new RegExp("^pa-");

Future<Document> requestDocument(String url) async {
  HttpClient client = new HttpClient();
  HttpClientRequest request = await client.getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String html = await response.transform(utf8.decoder).join();
  Document document = parse(html);
  return document;
}

// 解析trending repos
Future<Map<String, String>> requestTrendingRepos() async {
  Document document = await requestDocument('${github_url}/trending');
  List<Element> exploreContent =
      document.getElementsByClassName("explore-pjax-container");
  Map<String, String> repoMap = new Map();
  exploreContent.forEach((Element element) {
    element.getElementsByClassName("Box-row").forEach((Element rowElement) {
      rowElement
          .getElementsByClassName("lh-condensed")
          .forEach((Element repoElement) {
        List<String> names = repoElement
            .getElementsByTagName("a")
            .first
            .attributes['href']
            .split(new RegExp("/"));
        if (names.first == "") {
          names.removeAt(0);
        }
        repoMap[names.elementAt(0)] = names.elementAt(1);
      });
    });
  });
  return repoMap;
}

// 解析trending developers
Future<List<String>> requestTrendingDevelopers() async {
  Document document =
      await requestDocument('${github_url}/trending/developers');
  List<Element> exploreContent =
      document.getElementsByClassName("explore-pjax-container");
  List<String> names = new List();
  exploreContent.forEach((Element element) {
    element
        .getElementsByClassName("Box-row")
        .forEach((Element developerElement) {
      if (developerElement.attributes['id'].startsWith(linkPattern)) {
        String href =
            developerElement.getElementsByTagName("a").first.attributes['href'];
        names.add(href.substring(4, href.length));
      }
    });
  });
  return names;
}

Future<List<Map<String, String>>> requestTopics() async {
  List<Map<String, String>> list = new List();
  Document document = await requestDocument('${github_url}/topics');
  document.getElementsByTagName('a').forEach((link) {
    if (link.attributes['href'].startsWith(new RegExp("\\/topics\\/"))) {
      List<Element> nameElements = link.getElementsByClassName('lh-condensed');
      Element nameElement = nameElements.isNotEmpty ? nameElements.first : null;
      if (nameElement != null) {
        Map<String, String> map = new Map();
        map['name'] = nameElement.text;
        Element descriptionElement = nameElement.nextElementSibling;
        if (descriptionElement != null) {
          map['description'] = descriptionElement.text;
        }
        List<Element> imageElements = link.getElementsByTagName('img');
        Element imageElement =
            imageElements.isNotEmpty ? imageElements.first : null;
        if (imageElement != null) {
          map['avatarUrl'] = imageElement.attributes['src'];
        }
        list.add(map);
      }
    }
  });
  return list;
}
