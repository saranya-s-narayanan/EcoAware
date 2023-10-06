/**
 * Class representing Carbon footprint calculator screen
 */
import 'package:ecoaware/models/CalculatorResult.dart';
import 'package:ecoaware/views/widgets/custom_textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ecoaware/repository/firebase/userupdation_helper.dart';
import '../utils/constants.dart';
import '../utils/globals.dart';
import 'calculatorresult_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(CarbonFootprintCalculatorApp());
}

class CarbonFootprintCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoAware',
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: CarbonFootprintCalculatorScreen(),
    );
  }
}

class CarbonFootprintCalculatorScreen extends StatefulWidget {
  @override
  _CarbonFootprintCalculatorScreenState createState() =>
      _CarbonFootprintCalculatorScreenState();
}

class _CarbonFootprintCalculatorScreenState
    extends State<CarbonFootprintCalculatorScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  final key = GlobalKey<FormState>();
  bool isLoading=false;
@override
void initState() {
    // TODO: implement initState
    super.initState();
    Globals().calculatorScore=CalculatorResult();
}

  /** Method to calculate overall score and call result screen
   */
  Future<void> updateAndDisplayResults() async {
  Globals().calculatorScore!.updateOverallScore(
            Globals().calculatorScore!.getUtilitiesScore()+
            Globals().calculatorScore!.getTravelScore()+
            Globals().calculatorScore!.getFoodScore()+
            Globals().calculatorScore!.getTechScore()
  );
    Globals().calculatorScore!.updateSubmittedDate(DateTime.now().toString());

    String status = await UserResultUpdationHelper().updateCalculatorScore();

    // Update score to database
    await UserResultUpdationHelper().getRecentCalculatorScores();

    setState(() {
      isLoading = false; // Set isLoading to true when the button is pressed to display loading circle
    });

    // Transit to result screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CalculatorScreen()),
    );
  }

  /** Method to compute score of each category
   */
  void computeScore(int currentPageIndex) {
    final state = key.currentState;
    state?.save();

    if(_currentPageIndex==0) //Update utilities score
        {
      double utilitiesVal= Globals().electricityVal+Globals().heatingVal;
      Globals().calculatorScore?.updateUtilitiesScore(utilitiesVal);
    }else if(_currentPageIndex==1) //Update travel score
        {
      double travelVal= Globals().motorBikeVal+Globals().nonElectricCarVal+Globals().electricCarVal;
      Globals().calculatorScore?.updateTravelScore(travelVal);
    }if(_currentPageIndex==2) //Update food score
        {
      double foodVal= Globals().chickenVal+Globals().beefVal;
      Globals().calculatorScore?.updateFoodScore(foodVal);
    }if(_currentPageIndex==3) //Update tech score
        {
      double techVal= Globals().smartphoneVal+Globals().laptopVal;
      Globals().calculatorScore?.updateTechScore(techVal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().whiteColor,
      appBar: AppBar(
        backgroundColor: Constants().whiteColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text(
          Constants().appName,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Constants().greenColor,
            fontSize: 16,
          ),
        ),
      ),
      body: Form(
        key: key,
        child: Column(
          children: [

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                  //  if(index>_currentPageIndex)
                    _currentPageIndex = index;
                  });
                },
                children: [
                  UtilitiesSection(),
                  TravelSection(),
                  FoodSection(),
                  TechSection(),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Constants().greenColor), // Set desired background color
                  ),

                  onPressed: () {
                    computeScore(_currentPageIndex);
                    if (_currentPageIndex < 3) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }else{
                      setState(() {
                        isLoading = true; // Set isLoading to true when the button is pressed to display loading circle
                      });
                      updateAndDisplayResults();
                    }
                  },
                  child: isLoading
                      ? SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set the desired color
                    ),
                  ) // Show loading indicator when isLoading is true
                      :Text('Next'),

                ),
              ],
            ),
            SizedBox(height: 5.0,),
            LinearProgressIndicator(
              value: (_currentPageIndex + 1) / 4, // Assuming 4 sections (electricity, heat, gas, travel)
            ),
          ],
        ),
      ),
    );
  }


}

/** Class to represent utilities section widgets
 */
class UtilitiesSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ListView(
      padding: EdgeInsets.fromLTRB(35.0,15.0,35.0,15.0),
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Aligns the children to the center
            children: [
              Icon(
                Icons.home, // The icon you want to display (e.g., Icons.favorite, Icons.add, etc.)
                size: 30.0, // Size of the icon
                color: Colors.blue, // Color of the icon
              ),
              SizedBox(width: 5.0,),
              Text(
                AppLocalizations.of(context)!.utilities,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.0,),
        RoundedSubsection(
          title: AppLocalizations.of(context)!.electricity
          ,
          note: Globals().calculatorQuestions[0].getNote(),
          child: Column(
            children: [
              CustomTextBox(
                accent: Constants().greenColor,
                label:Globals().calculatorQuestions[0].getQuestion(),
                inputType: TextInputType.number,
                textInputAction: TextInputAction.next,
                hint: '',
                errorText: '',
                onSaved: (String value) {
                  Globals().electricityVal= value.isNotEmpty?double.parse(value):0.0;
                  Globals().electricityVal=Globals().electricityVal*Globals().calculatorQuestions[0].getEmissionFactor();
                },
              ),

            ],
          ),
        ),
        SizedBox(height: 15.0,),

        RoundedSubsection(
          title: AppLocalizations.of(context)!.heating
          ,
          note: Globals().calculatorQuestions[1].getNote(),
          child: Column(
            children: [
              CustomTextBox(
                accent: Constants().greenColor,
                inputType: TextInputType.number,
                label:Globals().calculatorQuestions[1].getQuestion(),
                hint: '',
                errorText: '',
                onSaved: (String value) {
                  Globals().heatingVal= value.isNotEmpty?double.parse(value):0.0;
                  Globals().heatingVal=Globals().heatingVal*Globals().calculatorQuestions[1].getEmissionFactor();

                },
              ),

            ],
          ),
        ),
      ],
    );
  }
}

/** Class to represent travel section widgets
 */
class TravelSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(35.0,15.0,35.0,15.0),
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Aligns the children to the center
            children: [
              Icon(
                Icons.bike_scooter, // The icon you want to display (e.g., Icons.favorite, Icons.add, etc.)
                size: 30.0, // Size of the icon
                color: Colors.orange, // Color of the icon
              ),
              SizedBox(width: 5.0,),
              Text(
                AppLocalizations.of(context)!.travel,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.0,),

        RoundedSubsection(
          title: AppLocalizations.of(context)!.motorbike
          ,
          note: Globals().calculatorQuestions[2].getNote(),
          child: Column(
            children: [
              CustomTextBox(
                accent: Constants().greenColor,
                inputType: TextInputType.number,
                textInputAction: TextInputAction.next,
                label:Globals().calculatorQuestions[2].getQuestion(),
                hint: '',
                errorText: '',
                onSaved: (String value) {
                  Globals().motorBikeVal=value.isNotEmpty?double.parse(value):0.0;
                  Globals().motorBikeVal=Globals().motorBikeVal*Globals().calculatorQuestions[2].getEmissionFactor();

                },
              ),

            ],
          ),
        ),
        SizedBox(height: 15.0,),

        RoundedSubsection(
          title: AppLocalizations.of(context)!.car
          ,
          note: Globals().calculatorQuestions[3].getNote(),
          child: Column(
            children: [
              CustomTextBox(
                accent: Constants().greenColor,
                inputType: TextInputType.number,
                textInputAction: TextInputAction.next,
                label:Globals().calculatorQuestions[3].getQuestion(),
                hint: '',
                errorText: '',
                onSaved: (String value) {
                  Globals().nonElectricCarVal= value.isNotEmpty?double.parse(value):0.0;
                  Globals().nonElectricCarVal=Globals().nonElectricCarVal*Globals().calculatorQuestions[3].getEmissionFactor();

                },
              ),
              SizedBox(height: 10.0,),
              CustomTextBox(
                accent: Constants().greenColor,
                inputType: TextInputType.number,
               label:Globals().calculatorQuestions[4].getQuestion(),
                hint: '',
                errorText: '',
                onSaved: (String value) {
                  Globals().electricCarVal= value.isNotEmpty?double.parse(value):0.0;
                  Globals().electricCarVal=Globals().electricCarVal*Globals().calculatorQuestions[4].getEmissionFactor();

                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/** Class to represent food section widgets
 */
class FoodSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(35.0,15.0,35.0,15.0),
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Aligns the children to the center
            children: [
              Icon(
                Icons.food_bank, // The icon you want to display (e.g., Icons.favorite, Icons.add, etc.)
                size: 30.0, // Size of the icon
                color: Colors.red, // Color of the icon
              ),
              SizedBox(width: 5.0,),
              Text(
                AppLocalizations.of(context)!.food,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.0,),

        RoundedSubsection(
          title: AppLocalizations.of(context)!.chicken
          ,
          note: Globals().calculatorQuestions[5].getNote(),
          child: Column(
            children: [
              CustomTextBox(
                accent: Constants().greenColor,
                label:Globals().calculatorQuestions[5].getQuestion(),
                hint: '',
                inputType: TextInputType.number,
                textInputAction: TextInputAction.next,
                errorText: '',
                onSaved: (String value) {
                  Globals().chickenVal= value.isNotEmpty?double.parse(value):0.0;
                  Globals().chickenVal=Globals().chickenVal*Globals().calculatorQuestions[5].getEmissionFactor();
                },
              ),

            ],
          ),
        ),
        SizedBox(height: 15.0,),

        RoundedSubsection(
          title: AppLocalizations.of(context)!.beef
          ,
          note: Globals().calculatorQuestions[6].getNote(),
          child: Column(
            children: [
              CustomTextBox(
                accent: Constants().greenColor,
                label:Globals().calculatorQuestions[6].getQuestion(),
                hint: '',
                inputType: TextInputType.number,
                errorText: '',
                onSaved: (String value) {
                  Globals().beefVal=value.isNotEmpty?double.parse(value):0.0;
                  Globals().beefVal=Globals().beefVal*Globals().calculatorQuestions[6].getEmissionFactor();
                },
              ),

            ],
          ),
        ),
      ],
    );
  }
}

/** Class to represent tech section widgets
 */
class TechSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(35.0,15.0,35.0,15.0),
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Aligns the children to the center
            children: [
              Icon(
                Icons.computer, // The icon you want to display (e.g., Icons.favorite, Icons.add, etc.)
                size: 30.0, // Size of the icon
                color: Colors.green, // Color of the icon
              ),
              SizedBox(width: 5.0,),
              Text(
                AppLocalizations.of(context)!.tech,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.0,),

        RoundedSubsection(
          title: AppLocalizations.of(context)!.smartphone,
          note: Globals().calculatorQuestions[7].getNote(),
          child: Column(
            children: [
              CustomTextBox(
                accent: Constants().greenColor,
                label:Globals().calculatorQuestions[7].getQuestion(),
                hint: '',
                inputType: TextInputType.number,
                textInputAction: TextInputAction.next,
                errorText: '',
                onSaved: (String value) {
                  Globals().smartphoneVal= value.isNotEmpty?double.parse(value):0.0;
                  Globals().smartphoneVal=Globals().smartphoneVal*Globals().calculatorQuestions[7].getEmissionFactor();
                },
              ),

            ],
          ),
        ),
        SizedBox(height: 15.0,),

        RoundedSubsection(
          title: AppLocalizations.of(context)!.laptop
          ,
          note: Globals().calculatorQuestions[8].getNote(),
          child: Column(
            children: [
              CustomTextBox(
                accent: Constants().greenColor,
                label:Globals().calculatorQuestions[8].getQuestion(),
                hint: '',
                inputType: TextInputType.number,
                errorText: '',
                onSaved: (String value) {
                  Globals().laptopVal= value.isNotEmpty?double.parse(value):0.0;
                  Globals().laptopVal=Globals().laptopVal*Globals().calculatorQuestions[8].getEmissionFactor();
                },
              ),

            ],
          ),
        ),
      ],
    );
  }
}

/** class to create a rounded box widget
 */
class RoundedSubsection extends StatelessWidget {
  final String title;
  final Widget child;
  final String note;

  const RoundedSubsection({required this.title, required this.child,required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
       //border: Border.all(color: Colors.grey),
        //color: Colors.grey.withOpacity(0.1), // Green color with 80% opacity
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
              style: TextStyle(
                color: Constants().greenColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,

              ),
          ),
          SizedBox(height: 10.0),
          child,
          SizedBox(height: 3.0),
          Center(
            child: Text(
              note,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Constants().blueColor,
                fontSize: 10,
                fontStyle: FontStyle.italic
              ),
            ),
          ),
          SizedBox(height: 8.0),

        ],
      ),
    );
  }
}

