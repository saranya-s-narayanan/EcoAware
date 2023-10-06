/** Data model to hold quiz result information
 */
class QuizResult {
  String _submittedDate="";
  int _overallScore=0;
  int _id=0;

  // Constructor
  QuizResult({
    int id=0,
    int overallScore=0,
    String submittedDate='',
  }){
    this._id = id;
    this._overallScore = overallScore;
    this._submittedDate = submittedDate;
  }

  //Setters and getters
  void updateScore(int newScore) {
    _overallScore = newScore;
  }
  void setID(int id) {
    _id = id;
  }

  int getOverallScore() => _overallScore;
  int getID() => _id;

  String getSubmittedDate() => _submittedDate;

}
