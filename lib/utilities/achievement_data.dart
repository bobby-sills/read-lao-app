class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int threshold;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.threshold,
  });
}

class AchievementData {
  static const List<Achievement> streakAchievements = [
    Achievement(
      id: 'streak_7',
      title: 'Week Warrior',
      description: 'Reach a 7-day streak',
      emoji: '🔥',
      threshold: 7,
    ),
    Achievement(
      id: 'streak_14',
      title: 'Two Weeks Strong',
      description: 'Reach a 14-day streak',
      emoji: '🔥',
      threshold: 14,
    ),
    Achievement(
      id: 'streak_21',
      title: 'Three Week Habit',
      description: 'Reach a 21-day streak',
      emoji: '🔥',
      threshold: 21,
    ),
    Achievement(
      id: 'streak_30',
      title: 'Monthly Master',
      description: 'Reach a 30-day streak',
      emoji: '🏅',
      threshold: 30,
    ),
    Achievement(
      id: 'streak_60',
      title: 'Two Month Champion',
      description: 'Reach a 60-day streak',
      emoji: '🏅',
      threshold: 60,
    ),
    Achievement(
      id: 'streak_100',
      title: 'Century Streak',
      description: 'Reach a 100-day streak',
      emoji: '🏆',
      threshold: 100,
    ),
  ];

  static const List<Achievement> lessonAchievements = [
    Achievement(
      id: 'lessons_10',
      title: 'Getting Started',
      description: 'Complete 10 lessons',
      emoji: '⭐',
      threshold: 10,
    ),
    Achievement(
      id: 'lessons_25',
      title: 'Quarter Way There',
      description: 'Complete 25 lessons',
      emoji: '⭐',
      threshold: 25,
    ),
    Achievement(
      id: 'lessons_50',
      title: 'Halfway Hero',
      description: 'Complete 50 lessons',
      emoji: '🌟',
      threshold: 50,
    ),
    Achievement(
      id: 'lessons_all',
      title: 'Lao Scholar',
      description: 'Complete all lessons',
      emoji: '🎓',
      threshold: -1, // special: checked against total lessons
    ),
  ];

  static List<Achievement> get all => [
    ...streakAchievements,
    ...lessonAchievements,
  ];
}
