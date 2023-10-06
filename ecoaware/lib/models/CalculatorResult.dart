/** Datamodel to hold the carbon footprint calculation result
 *
 */
class CalculatorResult {
  double _utilitiesScore=0.0;
  double _travelScore=0.0;
  double _foodScore=0.0;
  double _techScore=0.0;
  double _overallScore=0.0;
  String _submittedDate='';

  //Constructor
  CalculatorResult(){}


  //Setters and getters
  void updateUtilitiesScore(double utilitiesScore) {
    _utilitiesScore = utilitiesScore;
  }
  double getUtilitiesScore() => _utilitiesScore;

  void updateTravelScore(double travelScore) {
    _travelScore = travelScore;
  }
  double getTravelScore() => _travelScore;

  void updateFoodScore(double foodScore) {
    _foodScore = foodScore;
  }
  double getFoodScore() => _foodScore;

  void updateTechScore(double techScore) {
    _techScore = techScore;
  }
  double getTechScore() => _techScore;

  void updateOverallScore(double overallScore) {
    _overallScore = overallScore;
  }
  double getOverallScore() => _overallScore;

  void updateSubmittedDate(String submittedDate) {
    _submittedDate = submittedDate;
  }
  String getSubmittedDate() => _submittedDate;
}
