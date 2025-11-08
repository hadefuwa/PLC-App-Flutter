import 'dart:async';
import 'package:flutter/material.dart';
import '../models/worksheet.dart';
import '../services/progress_tracking_service.dart';

class SFWorksheetsScreen extends StatefulWidget {
  const SFWorksheetsScreen({super.key});

  @override
  State<SFWorksheetsScreen> createState() => _SFWorksheetsScreenState();
}

class _SFWorksheetsScreenState extends State<SFWorksheetsScreen> {
  final Set<String> _completedWorksheets = {};
  final ProgressTrackingService _progressService = ProgressTrackingService();

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await _progressService.getCurrentProgress();
    setState(() {
      _completedWorksheets.clear();
      for (final entry in progress.worksheetProgress.entries) {
        if (entry.value.isCompleted) {
          _completedWorksheets.add(entry.key);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final worksheets = Worksheet.getWorksheets();
    final completionPercent = (_completedWorksheets.length / worksheets.length * 100).toInt();

    return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1A1A2E),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${_completedWorksheets.length}/${worksheets.length} completed',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _completedWorksheets.length / worksheets.length,
                  backgroundColor: Colors.grey.shade800,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completionPercent% complete',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: worksheets.length,
              itemBuilder: (context, index) {
                final worksheet = worksheets[index];
                final isCompleted = _completedWorksheets.contains(worksheet.id);

                return _WorksheetCard(
                  worksheet: worksheet,
                  isCompleted: isCompleted,
                  onStart: () => _openWorksheet(context, worksheet),
                  onToggleComplete: () async {
                    if (isCompleted) {
                      setState(() {
                        _completedWorksheets.remove(worksheet.id);
                      });
                    } else {
                      setState(() {
                        _completedWorksheets.add(worksheet.id);
                      });
                    }
                    await _loadProgress();
                  },
                );
              },
            ),
          ),
        ],
      );
  }

  void _openWorksheet(BuildContext context, Worksheet worksheet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _WorksheetDetailScreen(
          worksheet: worksheet,
          isCompleted: _completedWorksheets.contains(worksheet.id),
          onComplete: () async {
            setState(() {
              _completedWorksheets.add(worksheet.id);
            });
            await _loadProgress();
          },
        ),
      ),
    );
  }
}

class _WorksheetCard extends StatelessWidget {
  final Worksheet worksheet;
  final bool isCompleted;
  final VoidCallback onStart;
  final VoidCallback onToggleComplete;

  const _WorksheetCard({
    required this.worksheet,
    required this.isCompleted,
    required this.onStart,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withValues(alpha: 0.5)
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onStart,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withValues(alpha: 0.2)
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.assignment,
                  color: isCompleted ? Colors.green : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${worksheet.id}: ${worksheet.title}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      worksheet.goal,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '~${worksheet.estimatedMinutes} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorksheetDetailScreen extends StatefulWidget {
  final Worksheet worksheet;
  final bool isCompleted;
  final VoidCallback onComplete;

  const _WorksheetDetailScreen({
    required this.worksheet,
    required this.isCompleted,
    required this.onComplete,
  });

  @override
  State<_WorksheetDetailScreen> createState() => _WorksheetDetailScreenState();
}

class _WorksheetDetailScreenState extends State<_WorksheetDetailScreen> {
  final Set<int> _checkedSteps = {};
  final Set<int> _checkedOverToYou = {};
  final ProgressTrackingService _progressService = ProgressTrackingService();
  DateTime? _startTime;
  Timer? _timeTracker;
  final Map<int, int?> _quizAnswers = {};
  bool _showQuizResults = false;

  @override
  void initState() {
    super.initState();
    _startWorksheet();
    _loadProgress();
  }

  Future<void> _startWorksheet() async {
    _startTime = DateTime.now();
    await _progressService.startWorksheet(
      widget.worksheet.id,
      widget.worksheet.steps.length,
    );

    // Track time every minute
    _timeTracker = Timer.periodic(const Duration(minutes: 1), (timer) async {
      await _progressService.updateTimeSpent(const Duration(minutes: 1));
    });
  }

  Future<void> _loadProgress() async {
    final progress = await _progressService.getCurrentProgress();
    final wp = progress.worksheetProgress[widget.worksheet.id];
    if (wp != null) {
      setState(() {
        _checkedSteps.clear();
        for (int i = 0; i < wp.stepsCompleted; i++) {
          _checkedSteps.add(i);
        }
      });
    }
  }

  @override
  void dispose() {
    _timeTracker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allStepsChecked = _checkedSteps.length == widget.worksheet.steps.length;
    final allOverToYouChecked = _checkedOverToYou.length == widget.worksheet.overToYou.length;
    final allQuizAnswered = _quizAnswers.length == widget.worksheet.quiz.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.worksheet.id),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title and Goal
            Text(
              widget.worksheet.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.worksheet.goal,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estimated time: ${widget.worksheet.estimatedMinutes} minutes',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content Introduction
            _buildSection(
              context,
              icon: Icons.description,
              title: 'Introduction',
              child: Text(
                widget.worksheet.content,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),

            // Learning Steps
            _buildSection(
              context,
              icon: Icons.list_alt,
              title: 'Learning Steps',
              child: Column(
                children: List.generate(widget.worksheet.steps.length, (index) {
                  final step = widget.worksheet.steps[index];
                  final isChecked = _checkedSteps.contains(index);
                  return CheckboxListTile(
                    value: isChecked,
                    onChanged: (value) async {
                      setState(() {
                        if (value == true) {
                          _checkedSteps.add(index);
                        } else {
                          _checkedSteps.remove(index);
                        }
                      });
                    },
                    title: Text(step, style: const TextStyle(fontSize: 14)),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }),
              ),
            ),

            // Over To You
            _buildSection(
              context,
              icon: Icons.touch_app,
              title: 'Over To You - Hands-On Practice',
              color: Colors.orange,
              child: Column(
                children: List.generate(widget.worksheet.overToYou.length, (index) {
                  final task = widget.worksheet.overToYou[index];
                  final isChecked = _checkedOverToYou.contains(index);
                  return CheckboxListTile(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _checkedOverToYou.add(index);
                        } else {
                          _checkedOverToYou.remove(index);
                        }
                      });
                    },
                    title: Text(task, style: const TextStyle(fontSize: 14)),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.orange,
                  );
                }),
              ),
            ),

            // So What?
            _buildSection(
              context,
              icon: Icons.lightbulb,
              title: 'So What? - Why This Matters',
              color: Colors.amber,
              child: Text(
                widget.worksheet.soWhat,
                style: const TextStyle(fontSize: 14, height: 1.5, fontStyle: FontStyle.italic),
              ),
            ),

            // Key Takeaways
            _buildSection(
              context,
              icon: Icons.stars,
              title: 'Key Takeaways',
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.worksheet.keyTakeaways.map((takeaway) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(child: Text(takeaway, style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                )).toList(),
              ),
            ),

            // Quiz
            _buildSection(
              context,
              icon: Icons.quiz,
              title: 'Quiz - Test Your Knowledge',
              color: Colors.purple,
              child: Column(
                children: List.generate(widget.worksheet.quiz.length, (qIndex) {
                  final question = widget.worksheet.quiz[qIndex];
                  final selectedAnswer = _quizAnswers[qIndex];
                  final isCorrect = selectedAnswer == question.correctAnswerIndex;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    color: const Color(0xFF1A1A2E),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Q${qIndex + 1}: ${question.question}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(question.options.length, (oIndex) {
                            final isSelected = selectedAnswer == oIndex;
                            final isThisCorrect = oIndex == question.correctAnswerIndex;
                            Color? tileColor;
                            if (_showQuizResults && isSelected) {
                              tileColor = isCorrect ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2);
                            } else if (_showQuizResults && isThisCorrect) {
                              tileColor = Colors.green.withValues(alpha: 0.1);
                            }

                            return RadioListTile<int>(
                              title: Text(question.options[oIndex]),
                              value: oIndex,
                              groupValue: selectedAnswer,
                              onChanged: _showQuizResults ? null : (value) {
                                setState(() {
                                  _quizAnswers[qIndex] = value;
                                });
                              },
                              tileColor: tileColor,
                              activeColor: Colors.purple,
                            );
                          }),
                          if (_showQuizResults && selectedAnswer != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isCorrect ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        isCorrect ? Icons.check_circle : Icons.info,
                                        color: isCorrect ? Colors.green : Colors.orange,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isCorrect ? 'Correct!' : 'Incorrect',
                                        style: TextStyle(
                                          color: isCorrect ? Colors.green : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    question.explanation,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),
            if (!_showQuizResults && allQuizAnswered)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showQuizResults = true;
                  });
                },
                icon: const Icon(Icons.grading),
                label: const Text('Check Answers'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

            if (_showQuizResults) ...[
              const SizedBox(height: 16),
              _buildQuizScore(),
            ],

            const SizedBox(height: 24),
            if (!widget.isCompleted && allStepsChecked && allOverToYouChecked)
              ElevatedButton.icon(
                onPressed: () async {
                  final timeSpent = _startTime != null
                      ? DateTime.now().difference(_startTime!)
                      : Duration.zero;
                  await _progressService.completeWorksheet(
                    widget.worksheet.id,
                    timeSpent,
                  );
                  widget.onComplete();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Worksheet marked as complete!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Mark Complete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              )
            else if (widget.isCompleted)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 12),
                    Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required IconData icon, required String title, required Widget child, Color? color}) {
    final sectionColor = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: sectionColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: sectionColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: sectionColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildQuizScore() {
    int correctCount = 0;
    for (int i = 0; i < widget.worksheet.quiz.length; i++) {
      if (_quizAnswers[i] == widget.worksheet.quiz[i].correctAnswerIndex) {
        correctCount++;
      }
    }
    final percentage = (correctCount / widget.worksheet.quiz.length * 100).round();
    final passed = percentage >= 70;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: passed ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: passed ? Colors.green : Colors.orange),
      ),
      child: Column(
        children: [
          Icon(
            passed ? Icons.celebration : Icons.info,
            color: passed ? Colors.green : Colors.orange,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'Score: $correctCount/${widget.worksheet.quiz.length} ($percentage%)',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: passed ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            passed ? 'Great job! You passed!' : 'Review the material and try again',
            style: TextStyle(
              fontSize: 16,
              color: passed ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
