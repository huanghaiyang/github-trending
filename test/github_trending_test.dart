import 'package:github_trending/github_trending.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('trending repos', () async {
      Map<String, String> actual = await requestTrendingRepos();
      expect(actual.keys.length > 10, true);
    });

    test('trending developers', () async {
      List<String> actual = await requestTrendingDevelopers();
      expect(actual.length > 10, true);
    });

    test('trending topics', () async {
      List<Map<String, String>> actual = await requestTopics();
      expect(actual.length > 10, true);
    });
  });
}
