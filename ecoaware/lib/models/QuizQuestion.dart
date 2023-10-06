/** Datamodel to hold quiz question information
 *
 */
class QuizQuestion {
  String _title="";
  List<String> _options=[];
  String _tip="";
  String _answer="";
  int _id=0;

  //Constructor
  QuizQuestion({
    int id = 0,
    String title = "",
    String answer = "",
    String tip = "",
  }) {
    this._id = id;
    this._title = title;
    this._answer = answer;
    this._tip = tip;
  }

  //Setters and getters
  String getTitle() => _title;

  setTitle(String title) {
    _title = title;
  }

  List<String> getOptions() => _options;

  setOptions(List<String> options) {
    _options = options;
  }

  String getTip() => _tip;

  set tip(String tip) {
    _tip = tip;
  }

  String getAnswer() => _answer;

  setAnswer(String answer) {
    _answer = answer;
  }

  int getId() => _id;

  setId(int id) {
    _id = id;
  }
}
