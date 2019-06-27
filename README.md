# Github trending API

## APIs

+ trending repos
```dart
Map<String, String> actual = await requestTrendingRepos();
```

+ trending developers
```dart
List<String> actual = await requestTrendingDevelopers();
```

+ topics 100+
```dart
List<Map<String, String>> actual = await requestTopics();
```

