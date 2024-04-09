import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/Homepage.dart';
import 'package:hattrick/Models/user.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

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
  HattrickAuth auth;
  QuizPage({required this.type, super.key, required this.auth});
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<TestQuestion> questions = [];
  Set<int> usedQuestionIndexes = {};
  int currentIndex = 0;
  int score = 0;
  late Timer questionTimer;
  double remainingTime = 0;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _fetchQuestions();
    questionTimer = Timer(Duration.zero, () {});
    // Initialize with an empty timer
  }

  @override
  void dispose() {
    questionTimer.cancel();
    super.dispose();
  }

  Future<void> _fetchQuestions() async {
    try {
      final responseEasy = await http.get(Uri.parse(
          'https://hattrick-server-production.up.railway.app//easy_questions'));
      final responseHard = await http.get(Uri.parse(
          'https://hattrick-server-production.up.railway.app//hard_questions'));

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
    final auth = widget.auth;
    final response = await http.post(
        Uri.parse(
            "https://hattrick-server-production.up.railway.app//post-game"),
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
  }

  void _moveToNextQuestion() {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      _startQuestionTimer();
    } else {
      Navigator.pop(context);
      GameDone();
      _showResultDialog(score);
    }
  }

  void _showResultDialog(score) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            content: Container(
              width: 350,
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 22),
                  score > 9
                      ? Image.asset(
                          "assets/win.png",
                          width: 120,
                          height: 120,
                        )
                      : Center(
                          child: Text(score.toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 24, fontWeight: FontWeight.bold))),
                  SizedBox(height: score > 9 ? 21 : 27),
                  Text(
                    score > 9 ? "Congratulations" : "Failed",
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: score > 9 ? Colors.black : Colors.red),
                  ),
                  score > 9
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("You Scored ",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                            Text(
                              "10",
                              style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              " Points",
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      : Text(
                          "Score 10 points to win",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                  SizedBox(height: 7),
                  score > 9
                      ? Text(
                          "+10,000 NGN",
                          style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )
                      : Container(),
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 219,
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: Center(
                          child: Text(
                        "Back To Home",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.normal),
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _startQuestionTimer() {
    if (questionTimer != null && questionTimer.isActive) {
      questionTimer.cancel();
    }

    final currentQuestion = questions[currentIndex];
    remainingTime = currentQuestion.duration.toDouble();
    questionTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        remainingTime = remainingTime - 0.1;
        if (remainingTime <= 0) {
          _moveToNextQuestion();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: questions.length < 10
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage("assets/bgq.png"), fit: BoxFit.cover)),
              //padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value:
                              remainingTime / questions[currentIndex].duration,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFEA8843)),
                        ),
                        Text("${(currentIndex + 1)}/10",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
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
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 26),
                          SizedBox(height: 26),
                          ...questions[currentIndex].choices.map(
                                (choice) => GestureDetector(
                                  onTap: () => _checkAnswer(choice),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Center(
                                            child: Text(
                                              choice,
                                              style: GoogleFonts.poppins(
                                                color: Color(0xFFFFFFFF),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 81,
                                          decoration: ShapeDecoration(
                                            color: Color(0xFF151515),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                      ],
                                    ),
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
