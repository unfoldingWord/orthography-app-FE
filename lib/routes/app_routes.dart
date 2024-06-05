import 'package:orthoappflutter/presentation/alphabet_chat_screens/pages/alphabet_chat_screen.dart';
import 'package:orthoappflutter/presentation/flash_screen/flash_screen.dart';
import 'package:orthoappflutter/presentation/letter_group_screen/pages/letter_group_galley_screen.dart';
import 'package:orthoappflutter/presentation/letter_group_screen/pages/see_more_letters_groups.dart';
import 'package:orthoappflutter/presentation/login_screen/pages/login_screen.dart';
import 'package:orthoappflutter/presentation/instruction_screen/instruction_screen.dart';
import 'package:orthoappflutter/presentation/sidebar_component_screen/sidebar_component_screen.dart';
import 'package:orthoappflutter/presentation/syllable_groups_screen/pages/syllable_groups_screen.dart';
import 'package:get/get.dart';
import '../presentation/Identify_syllables_screens/pages/assign_syllable_screen.dart';
import '../presentation/Identify_syllables_screens/pages/image_gallery_screen.dart';
import '../presentation/homepage_screen/pages/homepage_screen.dart';
import '../presentation/language_selection_screen/pages/languageSelection_screen.dart';
import '../presentation/letter_assignment_screens/pages/assign_letter_groups_screen.dart';
import '../presentation/letter_assignment_screens/pages/assign_letters_single_screen.dart';
import '../presentation/letter_assignment_screens/pages/letter_assignment_gallery_screen.dart';
import '../presentation/sound_grouping_screen/pages/assign_sound_group_screen.dart';
import '../presentation/sound_grouping_screen/pages/see_more_sound_grouping_images.dart';
import '../presentation/sound_grouping_screen/pages/sound_grouping_gallery_screen.dart';
import '../presentation/sound_grouping_screen/pages/sound_syllabic_screen.dart';
import '../presentation/sound_groups_screens/pages/see_more_sound_groups_images.dart';
import '../presentation/sound_groups_screens/pages/sound_groups_gallery_screen.dart';
import '../presentation/syllable_groups_screen/pages/individual_syllabic_screen.dart';
import '../presentation/syllable_groups_screen/pages/syllabic_expanded_view_screen.dart';
import '../presentation/training_video_screen/pages/video_screen.dart';

class AppRoutes {
  static const String flashScreen = '/flash_screen';

  static const String flashtwoScreen = '/flashtwo_screen';

  static const String flashthreeScreen = '/flashthree_screen';

  static const String flashfourTwoScreen = '/flashfour_two_screen';

  static const String loginOneScreen = '/login_one_screen';

  static const String loginScreen = '/login_screen';

  static const String flashfourOneScreen = '/flashfour_one_screen';

  static const String languageSelectionScreen = '/languageSelection_screen';

  static const String instructionScreen = '/instruction_screen';

  static const String videoScreen = '/video_screen';

  static const String homepageOneScreen = '/homepage_one_screen';

  static const String sidebarComponentScreen = '/sidebar_component_screen';

  static const String moduleVideoScreen = '/module_video_screen';

  static const String imageGalleryScreen = '/image_gallery_screen';

  static const String assignSyllableScreen = '/assign_syllable_screen';

  static const String expandedViewOneScreen = '/expanded_view_one_screen';

  static const String expandedViewTwoScreen = '/expanded_view_two_screen';

  static const String expandedViewScreen = '/expanded_view_screen';

  static const String identifySyllablesScreen = '/identify_syllables_screen';

  static const String soundGroupGalleryScreen = '/sound_group_gallery_screen';

  static const String lastImageScreen = '/last_image_screen';

  static const String syllableGroupsScreen = '/syllable_groups_screen';

  static const String soundSyllablicScreen = '/sound_syllabic_screen';

  static const String individualSyllabicList = '/individual_syllabic_list_screen';

  static const String monoSelectedScreen = '/mono_selected_screen';

  static const String changeGroupScreen = '/change_group_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String singleSoundGroup = '/single_sound_group_screen';

  static const String assignSoundGroupScreen = '/assign_sound_group_screen';

  static const String seeMoreSoundGroupingScreen = '/see_sound_grouping_screen';

  static const String seeMoreSoundGroupsScreen = '/see_sound_groups_screen';

  static const String soundGroupingScreen = '/sound_grouping_screen';

  static const String graphemeGalleryScreen = '/grapheme_gallery_screen';

  static const String assignLetterSingleImage = '/assign_letter_single_image_screen';

  static const String assignGroupLetterScreen = '/assign_group_letter_screen';

  static const String letterGroupsScreen = '/letter_groups_screen';

  static const String syllabicExpandedViewScreen = '/syllabic_expanded_view_screen';

  static const String seeMoreLettersGroupsScreen = '/see_more_letters_groups_screen';

  static const String updateLettersGroupsScreen = '/update_letters_groups_screen';

  static const String updateSoundGroupingScreen = '/update_sound_grouping_screen';

  static const String letterAssignmentGallery = '/letter_assignment_gallery';

  static const String alphabetChatScreen = '/alphabet_chat_screen';

  static const String initialRoute = '/initialRoute';

  static List<GetPage> pages = [
    GetPage(
      name: flashScreen,
      page: () => FlashScreen()
    ),

    GetPage(
      name: syllabicExpandedViewScreen,
      page: () => SyllabicExpandedViewScreen()
    ),

    GetPage(
      name: soundGroupingScreen,
      page: () => SoundGroupsGalleryScreen(),
    ),
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),

    ),
    GetPage(
      name: languageSelectionScreen,
      page: () => LanguageSelectionScreen(),

    ),
    GetPage(
      name: instructionScreen,
      page: () => InstructionScreen(),
    ),
    GetPage(
      name: videoScreen,
      page: () => VideoScreen(),
    ),
    GetPage(
      name: homepageOneScreen,
      page: () => HomepageScreen(),

    ),

    GetPage(
      name: sidebarComponentScreen,
      page: () => SidebarComponentScreen(),

    ),

    GetPage(
      name: imageGalleryScreen,
      page: () => ImageGalleryScreen(),

    ),

    GetPage(
      name: seeMoreSoundGroupingScreen,
      page: () => SeeMoreSoundGroupingScreen(),
      bindings: [
        // ImageGalleryBinding(),
      ],
    ),

    GetPage(
      name: assignLetterSingleImage,
      page: () => AssignLetterSingleImage(),
    ),
    GetPage(
      name: assignGroupLetterScreen,
      page: () => AssignLetterGroupImageScreen(),
    ),
    GetPage(
      name: seeMoreSoundGroupsScreen,
      page: () => SeeMoreSoundGroupsScreen(),
    ),

    GetPage(
      name: assignSyllableScreen,
      page: () => AssignSyllableScreen(),

    ),

    GetPage(
      name: soundSyllablicScreen,
      page: () => SoundSyllabicScreen(),
    ),
    GetPage(
      name: assignSoundGroupScreen,
      page: () => AssignSoundGroupScreen(),
    ),

    GetPage(
      name: letterGroupsScreen,
      page: () => LetterGroupScreen(),
    ),

    GetPage(
      name: soundGroupGalleryScreen,
      page: () => SoundGroupGalleryScreen(),

    ),

    GetPage(
      name: syllableGroupsScreen,
      page: () => SyllableGroupsScreen(),

    ),

    GetPage(
      name: individualSyllabicList,
      page: () => IndividualSyllabicList(),
    ),

    GetPage(
      name: initialRoute,
       page: () => FlashScreen(),
    ),

    GetPage(
      name: seeMoreLettersGroupsScreen,
      page: () => SeeMoreLetterGroupsGroupsScreen(),
    ),

    GetPage(
      name: letterAssignmentGallery,
      page: () => LetterAssignmentGallery(),
    ),

    GetPage(
      name: alphabetChatScreen,
      page: () => AlphabetChatScreen(),
    ),

  ];
}
