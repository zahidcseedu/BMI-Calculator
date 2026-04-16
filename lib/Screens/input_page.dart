import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Components/Icon_Content.dart';
import '../Components/Reusable_Bg.dart';
import '../Components/RoundIcon_Button.dart';
import '../constants.dart';
import 'Results_Page.dart';
import 'SavedResults_Page.dart';
import '../Components/BottomContainer_Button.dart';
import '../calculator_brain.dart';

// ignore: must_be_immutable
class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

//ENUMERATION : The action of establishing number of something , implicit way
enum Gender {
  male,
  female,
}

class _InputPageState extends State<InputPage> {
  //by default male will be selected

  late Gender selectedGender = Gender.male;
  int feet = 5;
  int inches = 10;
  int weight = 50;
  int age = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2F51),
      appBar: AppBar(
        title: Center(
          child: Text('BMI CALCULATOR'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedResultsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    child: ReusableBg(
                      colour: selectedGender == Gender.male
                          ? kactiveCardColor
                          : kinactiveCardColor,
                      cardChild: IconContent(
                          myicon: FontAwesomeIcons.user, text: 'MALE'),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                    child: ReusableBg(
                      colour: selectedGender == Gender.female
                          ? kactiveCardColor
                          : kinactiveCardColor,
                      cardChild: IconContent(
                          myicon: FontAwesomeIcons.female, text: 'FEMALE'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableBg(
              colour: kactiveCardColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'HEIGHT',
                    style: klabelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        feet.toString(),
                        style: kDigitTextStyle,
                      ),
                      Text(
                        "'",
                        style: klabelTextStyle,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        inches.toString(),
                        style: kDigitTextStyle,
                      ),
                      Text(
                        '"',
                        style: klabelTextStyle,
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Feet',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Color(0xFF8D8E98),
                                ),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: ksliderInactiveColor,
                                  thumbColor: Color(0xFFEB1555),
                                  overlayColor: Color(0x29EB1555),
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 10.0),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 20.0),
                                ),
                                child: Slider(
                                  value: feet.toDouble(),
                                  min: 4,
                                  max: 7,
                                  divisions: 3,
                                  onChanged: (double newValue) {
                                    setState(() {
                                      feet = newValue.round();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Inches',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Color(0xFF8D8E98),
                                ),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: ksliderInactiveColor,
                                  thumbColor: Color(0xFFEB1555),
                                  overlayColor: Color(0x29EB1555),
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 10.0),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 20.0),
                                ),
                                child: Slider(
                                  value: inches.toDouble(),
                                  min: 0,
                                  max: 11,
                                  divisions: 11,
                                  onChanged: (double newValue) {
                                    setState(() {
                                      inches = newValue.round();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableBg(
                    colour: kactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'WEIGHT',
                          style: klabelTextStyle,
                        ),
                        Text(
                          weight.toString(),
                          style: kDigitTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  weight--;
                                });
                              },
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableBg(
                    colour: kactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'AGE',
                          style: klabelTextStyle,
                        ),
                        Text(
                          age.toString(),
                          style: kDigitTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(() {
                                  age--;
                                });
                              },
                            ),
                            SizedBox(width: 15.0),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  age++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomContainer(
            text: 'CALCULATE',
            onTap: () {
              // Convert feet and inches to centimeters
              int heightInCm = (feet * 30.48 + inches * 2.54).round();
              Calculate calc = Calculate(height: heightInCm, weight: weight);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(
                    bmi: calc.result(),
                    resultText: calc.getText(),
                    advise: calc.getAdvise(),
                    textColor: calc.getTextColor(),
                    height: heightInCm,
                    weight: weight,
                    bmiBmi: calc.getBMI(),
                    normalWeightRange: calc.getNormalWeightRange(),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(
      //     Icons.favorite,
      //     color: Colors.pink,
      //     size: 23.0,
      //   ),
      //   backgroundColor: kactiveCardColor,
      // ),
    );
  }
}
