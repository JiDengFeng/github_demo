class RepoModel {
  late int id;
  late String name;
  late String description;
  late String language;

  late int forks_count;
  late int stargazers_count;
  late int subscribers_count;

  RepoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'] ?? '无';
    language = json['language'] ?? '';
    forks_count = json['forks_count'] ?? 0;
    stargazers_count = json['stargazers_count'] ?? 0;
    subscribers_count = json['subscribers_count'] ?? 0;
  }
}
