import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/Homepage.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';

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
    _fetchQuestions();
    questionTimer =
        Timer(Duration.zero, () {}); // Initialize with an empty timer
  }

  @override
  void dispose() {
    questionTimer.cancel();
    super.dispose();
  }

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

  void _moveToNextQuestion() {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      _startQuestionTimer();
    } else {
      _showResultDialog(score);
    }
  }

  void _showResultDialog(score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (score > 9) {
          GameDone();
          return AlertDialog(
            content: Container(
              width: 340,
              height: 420,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 340,
                      height: 420,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 57,
                    top: 41,
                    child: Text(
                      'Congratulations!!!',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 51,
                    top: 286,
                    child: Container(
                      width: 238,
                      height: 50,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 238,
                              height: 50,
                              decoration: ShapeDecoration(
                                color: Color(0xFF801EF8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 83,
                            top: 13,
                            child: Text(
                              'Continue',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 27,
                    top: 194,
                    child: Container(
                      width: 303,
                      height: 60,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 24,
                            child: Text(
                              'You Just Scored ${score}/10',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Text(
                              'You Are A Winner',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 107,
                    top: 77,
                    child: Container(
                      width: 120,
                      height: 120,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: ShapeDecoration(
                                color: Color(0xFFE3E3E3),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: ShapeDecoration(
                                color: Color(0xFF7161EF),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 22,
                            top: 20,
                            child: Container(
                              width: 93,
                              height: 97,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/QuizPage/fullscore.jpg"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return AlertDialog(
            content: Container(
              width: 340,
              height: 420,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 340,
                      height: 420,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 57,
                    top: 41,
                    child: Text(
                      'Congratulations!!!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 51,
                    top: 286,
                    child: Container(
                      width: 238,
                      height: 50,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              //CODE
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                            child: Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 238,
                                height: 50,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF801EF8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 83,
                            top: 13,
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 27,
                    top: 194,
                    child: Container(
                      width: 303,
                      height: 60,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 24,
                            child: Text(
                              '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Text(
                              "We didn't win",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 107,
                    top: 77,
                    child: Container(
                      width: 120,
                      height: 120,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: ShapeDecoration(
                                color: Color(0xFFE3E3E3),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: ShapeDecoration(
                                color: Color(0xFF7161EF),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 22,
                            top: 20,
                            child: Container(
                              width: 93,
                              height: 97,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/QuizPage/failed.jpg"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
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
      backgroundColor: Color(0xFF1D1D1D),
      body: questions.length < 10
          ? Center(
              child: RiveAnimation.asset(
              'assets/load.riv',
            ))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Text(remainingTime.toString()),
                  Text(
                    questions[currentIndex].difficulty == 'hard'
                        ? "Hard"
                        : "Easy",
                    style: GoogleFonts.poppins(
                      color: questions[currentIndex].difficulty == 'hard'
                          ? Colors.red[400]
                          : Colors.green[300],
                    ),
                  ),
                  Text(
                    'Question ${currentIndex + 1}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 58,
                    child: Text(
                      questions[currentIndex].question,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ...questions[currentIndex].choices.map(
                        (choice) => GestureDetector(
                          onTap: () => _checkAnswer(choice),
                          child: Column(
                            children: [
                              Container(
                                width: 335,
                                height: 81,
                                child: Center(
                                  child: Text(choice),
                                ),
                                decoration: ShapeDecoration(
                                  color: Color(0xFFD67836),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),
    );
  }
}

void GameDone() {}
