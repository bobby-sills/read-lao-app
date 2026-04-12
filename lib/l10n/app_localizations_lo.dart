// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lao (`lo`).
class AppLocalizationsLo extends AppLocalizations {
  AppLocalizationsLo([String locale = 'lo']) : super(locale);

  @override
  String get appTitle => 'ຮຽນພາສາລາວ';

  @override
  String get vowels => 'ສະຫລະ';

  @override
  String get consonants => 'ພະຍັນຊະນະ';

  @override
  String get practiceSpellingTitle => 'ຝືກຊອ້ມລຽງຄຳ';

  @override
  String get practiceSpellingDescription => 'ລອງຝືກຊອ້ມການລຽງຄຳໃຫ້ຖືກ';

  @override
  String get startPractice => 'ເລີມຝືກ';

  @override
  String get settingsTitle => 'ການຕັ້ງຄ່າ';

  @override
  String get darkMode => 'ການຕັ້ງຄ່າມືດ';

  @override
  String get darkThemeEnabled => 'ການຕັ້ງຄ່າມືດເປີດການໃຊ້ງານ';

  @override
  String get lightThemeEnabled => 'ການຕັ້ງຄ່າແຈ້ງເປິດການໃຊ້ງານ';

  @override
  String get dailyReminder => 'ການແຈ້ງເຕືອນໃນແຕ່ລະມື້';

  @override
  String get reminderEnabled => 'ເປີດໃຊ້ງານແລ້ວ';

  @override
  String get reminderDisabled => 'ປິດໃຊ້ງານ';

  @override
  String get notificationPermissionDenied => 'ສິດການແຈ້ງເຕືອນຖືກປະຕິເສດ';

  @override
  String get aboutThisApp => 'ກ່ຽວກັບແອບນີ້';

  @override
  String get aboutVersion => 'ເວີຊັນ 2.1.0';

  @override
  String get aboutDescription1 =>
      'ແອັບແບບໂຕ້ຕອບສຳລັບຮຽນພາສາລາວ ໂດຍຜ່ານບົດຝຶກຫັດ ແລະ ບົດຮຽນທີ່ໜ້າສົນໃຈ.';

  @override
  String get aboutDescription2 =>
      'ຮຽນຮູ້ທີ່ຈະຈື່ຈຳ, ອອກສຽງ ແລະ ຂຽນຕົວອັກສອນລາວຕາມຈັງຫວະຂອງທ່ານເອງ';

  @override
  String get close => 'ປິດ';

  @override
  String get resetProgress => 'ລົບບົດຮຽນເກົ່າເພື່ອຮຽນໃຫ່ມ';

  @override
  String get resetProgressTitle =>
      'ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການລົບບົດຮຽນເກົ່າເພື່ອຮຽນໃໝ່?';

  @override
  String get resetProgressContent =>
      'ການກະທຳນີ້ຈະລົບຄວາມຄືບໜ້າຂອງບົດຮຽນທັງໝົດ. ການກະທຳນີ້ບໍ່ສາມາດຍົກເລີກໄດ້.';

  @override
  String get cancel => 'ຍົກເລີກ';

  @override
  String get reset => 'ຣີເຊັດ';

  @override
  String get progressResetSuccessfully => 'ຣີເຊັດຄວາມຄືບໜ້າສຳເລັດແລ້ວ';

  @override
  String get lessonsNavLabel => 'ບົດຮຽນ';

  @override
  String get practiceNavLabel => 'ຝຶກຫັດ';

  @override
  String get achievementsNavLabel => 'ຄວາມສຳເລັດ';

  @override
  String get settingsNavLabel => 'ການຕັ້ງຄ່າ';

  @override
  String get streakDialogNoStreak =>
      'ສຳເລັດບົດຮຽນໃນມື້ນີ້ ເພື່ອເລີ່ມຕົ້ນສະທຣິກຂອງທ່ານ!';

  @override
  String get streakDialogOneDay => 'ທ່ານໄດ້ຝຶກຫັດ 1 ມື້ຕິດຕໍ່ກັນແລ້ວ!';

  @override
  String streakDialogMultipleDays(int count) {
    return 'ທ່ານໄດ້ຝຶກຫັດ $count ມື້ຕິດຕໍ່ກັນແລ້ວ!';
  }

  @override
  String get streakDialogButtonNoStreak => 'ໄປກັນເລີຍ!';

  @override
  String get streakDialogButtonWithStreak => 'ດີຫຼາຍ!';

  @override
  String get exitLessonTitle => 'ອອກຈາກບົດຮຽນ';

  @override
  String get exitLessonContent => 'ເຈົ້າແນ່ໃຈເຈົ້າຈະອອກຈາກບົດຮຽນ';

  @override
  String lessonCompleteTitle(int number) {
    return 'ບົດຮຽນ $number ຈົບແລ້ວ';
  }

  @override
  String get lessonCompleteSubtitle => 'ເຮັດໄດ້ດີຫຼາຍ! ສູ້ໆຕໍ່ໄປເດີ້';

  @override
  String get backToLessons => 'ກັບໄປບົດຮຽນ';

  @override
  String get achievementsTitle => 'ຜົນສຳເລັດການຮຽນ';

  @override
  String get streakMilestones => 'ຫລັກສູດການຮຽນ';

  @override
  String get lessonMilestones => 'ໄລຍະການຮຽນ';

  @override
  String unlockedOn(String date) {
    return 'ປົດລັອກເມື່ອ $date';
  }

  @override
  String get achievementUnlocked => 'ປົດລັອກຄວາມສຳເລັດແລ້ວ!';

  @override
  String get achievementsUnlocked => 'ປົດລັອກຄວາມສຳເລັດແລ້ວ!';

  @override
  String get continueButton => 'ສືບຕໍ່';

  @override
  String streakDays(int count) {
    return 'ຮຽນຕິດຕໍ່ກັນ $count ມື້';
  }

  @override
  String get streakStarted => 'ຮຽນຕໍ່ມື້ອື່ນ';

  @override
  String get streakContinue => 'ຄວາມສະໝ່ຳສະເໝີສຸດຍອດ! ສືບຕໍ່ໄປເດີ້';

  @override
  String get lessonNotFound => 'ບໍ່ພົບບົດຮຽນ';

  @override
  String get goBack => 'ກັບຄືນ';

  @override
  String get timeToReview => 'ໄດ້ເວລາທົບທວນແລ້ວ!';

  @override
  String get practiceOnesYouMissed => 'ມາຝຶກຂໍ້ທີ່ທ່ານຕອບຜິດກັນເຖາະ';

  @override
  String get correct => 'ຖືກຕອ້ງ';

  @override
  String get incorrect => 'ບໍ່ຖືກ';

  @override
  String get answerShown => 'ສະແດງຄຳຕອບແລ້ວ';

  @override
  String get showAnswer => 'ສະແດງຄຳຕອບ';

  @override
  String get skipToThisLesson => 'ຂ້າມບົດຮຽນນີ້ບໍ';

  @override
  String get skipConfirmContent => 'ເຈົ້າແນ່ໃຈບໍ່ທີ່ຈະຂ້າມບົດຮຽນນີ້';

  @override
  String get skip => 'ຂ້າມ';
}
