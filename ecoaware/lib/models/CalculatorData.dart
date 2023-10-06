/** Datamodel to hold carbon footprint calculation data
 *
 */
class CalculatorData {
  String _question="";
  double _emissionFactor=0;
  int _id=0;
  String _note="";
  String _type="";

  // Constructor
  CalculatorData({
    int id=0,
    double emissionFactor=0.0,
    String question='',
    String note='',
    String type='',
  }){
    this._id = id;
    this._emissionFactor = emissionFactor;
    this._question = question;
    this._note=note;
    this._type=type;
  }

  // Setters and getters
  void updateScore(double emissionFactor) {
    _emissionFactor = emissionFactor;
  }

  double getEmissionFactor() => _emissionFactor;

  String getQuestion() => _question;
  String getNote() => _note;
  String getType() => _type;

}
