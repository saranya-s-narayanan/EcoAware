/** Datamodel to hold user information
 *
 */
class UserProfile {
  String _id="";
  String _name="";
  String _email="";

//Constructor
  UserProfile({
    String id='0',
    String name='',
    String email='',
  }){
    this._id = id;
    this._name = name;
    this._email = email;
  }

  //Setters and getters

  void setID(String id) {
    _id = id;
  }
  String getID() => _id;

  void setName(String name) {
    _name = name;
  }
  String getName() => _name;

  void setEmail(String email) {
    _email = email;
  }
  String getEmail() => _email;
}
