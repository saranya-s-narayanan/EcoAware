/** Data model for holding informative contents
 *
 */
class Article {
  String _parent="-1";
  String _description="";
  String _imgUrl="";
  String _name="";
  int _id;
  List<Article> _articles = [];

  // Constructor
  Article({
    String parent = "-1",
    String description = "",
    String imgUrl = "",
    String name = "",
    int id = 0,
  })  : _parent = parent,
        _description = description,
        _imgUrl = imgUrl,
        _name = name,
        _id = id;

  // Getters and setters

  int getID(){
    return _id;
  }
  String getName(){
    return _name;
  }
  String getImgUrl(){
    return _imgUrl;
  }
  String getDescription(){
    return _description;
  }
  String getParent(){
    return _parent;
  }

  List<Article> getArticles()
  {
    return _articles;
  }

  addArticle(Article article){
    this._articles.add(article);
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      parent: json['parent'],
      description: json['description'],
      imgUrl: json['img_url'],
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent': _parent,
      'description': _description,
      'img_url': _imgUrl,
      'name': _name,
      'id': _id,
    };
  }
}
