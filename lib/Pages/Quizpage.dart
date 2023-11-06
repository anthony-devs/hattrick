import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/Homepage.dart';
import 'package:hattrick/Models/user.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';
import 'package:wakelock/wakelock.dart';

import '../Models/quiz.dart';

class TestQuestion {
  String question;
  List<String> choices;
  String correctAnswer;
  String difficulty;
  int duration;

  TestQuestion({
    required this.question,
    required this.choices,
    required this.correctAnswer,
    required this.difficulty,
    required this.duration,
  });
}

class QuizPage extends StatefulWidget {
  QuizType type;
  QuizPage({required this.type, super.key});
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<TestQuestion> questions = [];
  Set<int> usedQuestionIndexes = {};
  int currentIndex = 0;
  int score = 0;
  late Timer questionTimer;
  int remainingTime = 0;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _fetchQuestions();
    questionTimer = Timer(Duration.zero, () {});
    auth.PasswordlessSignIn(); // Initialize with an empty timer
  }

  @override
  void dispose() {
    questionTimer.cancel();
    super.dispose();
  }

  final auth = HattrickAuth();
  Future<void> _fetchQuestions() async {
    try {
      final responseEasy =
          await http.get(Uri.parse('http://localhost:5000/easy_questions'));
      final responseHard =
          await http.get(Uri.parse('http://localhost:5000/hard_questions'));

      if (responseEasy.statusCode == 200 && responseHard.statusCode == 200) {
        final List<dynamic> easyQuestionsData = jsonDecode(responseEasy.body);
        final List<dynamic> hardQuestionsData = jsonDecode(responseHard.body);

        final easyQuestions = easyQuestionsData.map((doc) {
          return TestQuestion(
            question: doc['question'],
            choices: List<String>.from(
              _shuffleOptions(
                  List<String>.from([doc['Opt1'], doc['Opt2'], doc['Opt3']]),
                  doc['correct_answer'].toString()),
            ),
            correctAnswer: doc['correct_answer'],
            difficulty: "easy",
            duration: 12, // You can update this value based on your data
          );
        }).toList();

        final hardQuestions = hardQuestionsData.map((doc) {
          return TestQuestion(
            question: doc['question'],
            choices: List<String>.from(
              _shuffleOptions(
                  List<String>.from([doc['Opt1'], doc['Opt2'], doc['Opt3']]),
                  doc['correct_answer'].toString()),
            ),
            correctAnswer: doc['correct_answer'],
            difficulty: "hard",
            duration: 12, // You can update this value based on your data
          );
        }).toList();

        // Shuffle the questions
        easyQuestions.shuffle();
        hardQuestions.shuffle();

        // Combine and ensure no repeat questions
        final allQuestions = [
          ..._takeUniqueQuestions(easyQuestions, 2),
          ..._takeUniqueQuestions(hardQuestions, 2),
          ..._takeUniqueQuestions(easyQuestions, 2),
          ..._takeUniqueQuestions(hardQuestions, 4),
        ];

        setState(() {
          questions = allQuestions;
        });

        print("Got Questions");
      } else {
        print('Failed to load questions');
      }
    } catch (error) {
      print('Error fetching questions: $error');
    }
  }

  List<String> _shuffleOptions(List<String> options, String correctAnswer) {
    options.add(correctAnswer);
    options.shuffle();
    return options;
  }

  List<TestQuestion> _takeUniqueQuestions(
      List<TestQuestion> source, int count) {
    List<TestQuestion> uniqueQuestions = [];

    for (int i = 0; i < source.length; i++) {
      if (uniqueQuestions.length >= count) {
        break;
      }

      if (!usedQuestionIndexes.contains(i)) {
        uniqueQuestions.add(source[i]);
        usedQuestionIndexes.add(i);
      }
    }

    return uniqueQuestions;
  }

  void _checkAnswer(String selectedAnswer) {
    if (questions[currentIndex].correctAnswer == selectedAnswer) {
      setState(() {
        score++;
      });
    }

    _moveToNextQuestion();
  }

  Future<dynamic> GameDone() async {
    final response =
        await http.post(Uri.parse("http://localhost:5000/post-game"),
            body: jsonEncode(<String, String>{
              'score': score.toString(),
              'uid': auth.currentuser!.uid.toString(),
              'type': widget.type.toString()
            }),
            headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    final data = jsonDecode(response.body);
    Fluttertoast.showToast(msg: data['msg']);
    //auth.currentuser = new User(
    //uid: data['uid'],
    //FullName: data['FullName'],
    //city: data['city'],
    //coins: data['coins'],
    //earning_balance: data['earning_balance'],
    //email: data['email'],
    //is_subscribed: data['is_subscribed'],
    //practice_points: data['practice_points'],
    //super_points: data['super_points'],
    //username: data['username'],
    //);
    auth.PasswordlessSignIn();
  }

  void _moveToNextQuestion() {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      _startQuestionTimer();
    } else {
      Navigator.pop(context);
      GameDone();
      _showResultDialog(score);
      auth.PasswordlessSignIn();
    }
  }

  void _showResultDialog(score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              width: 340,
              height: 420,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [
                  Text(score < 9 ? "Game Finished" : "You Are A Winner",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(height: 4),
                  Container(
                    height: 128,
                    width: 128,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(score < 9
                              ? "assets/failed.jpg"
                              : "assets/fullscore.jpg")),
                      color: Color.fromARGB(255, 228, 228, 228),
                      shape: BoxShape.circle,
                    ),
                    child: Center(),
                  ),
                  Container(
                    child: Column(textDirection: TextDirection.ltr, children: [
                      Text(score < 9 ? score.toString() : "What A Shot!!!",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      Text(
                        score < 9 ? 'Practice More!!!' : 'You Are A Winner!!!',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 238,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: Color(0xFFAF89F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Color(0xFF322653),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
                  )
                ]),
              )),
        );
      },
    );
  }

  void _startQuestionTimer() {
    if (questionTimer != null && questionTimer.isActive) {
      questionTimer.cancel();
    }

    final currentQuestion = questions[currentIndex];
    remainingTime = currentQuestion.duration;
    questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
        if (remainingTime <= 0) {
          _moveToNextQuestion();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FB),
      body: questions.length < 10
          ? Center(
              child: RiveAnimation.asset(
              'assets/load.riv',
            ))
          : Container(
              color: Color.fromARGB(255, 240, 248, 251),
              //padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                )),
                            Spacer(),
                            Text(
                              "${currentIndex + 1}",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: remainingTime / questions[currentIndex].duration,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFEA8843)),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Padding(
                            //width: MediaQuery.of(context).size.width - 58,
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              questions[currentIndex].question,
                              style: GoogleFonts.poppins(
                                color: Color.fromARGB(255, 43, 42, 49),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 26),
                          Container(
                            width: 150,
                            height: 47,
                            decoration: ShapeDecoration(
                              color: Color(0x9EFFDFB0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${4} Points",
                                style: GoogleFonts.poppins(
                                  color: Color(0xFFEA8843),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 26),
                          ...questions[currentIndex].choices.map(
                                (choice) => GestureDetector(
                                  onTap: () => _checkAnswer(choice),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Text(
                                            choice,
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFF2B2A31),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        width: 335,
                                        height: 81,
                                        decoration: ShapeDecoration(
                                          color: Color(0xFFF1ECF7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                        ]),
                  )
                ],
              ),
            ),
    );
  }
}
