/// What common Flutter plugins need from the iOS configuration.
///
/// Built from each plugin's own README on pub.dev (its "iOS setup" section).
/// Projects extend these tables through rule options.
library;

/// Plugins whose presence is evidence that a `UIBackgroundModes` entry has a
/// feature behind it.
const backgroundModeEvidence = <String, List<String>>{
  'audio': [
    'audio_service',
    'just_audio_background',
    'audioplayers',
    'assets_audio_player',
    'flutter_sound',
    'record',
    'livekit_client',
    'flutter_webrtc',
    'agora_rtc_engine',
  ],
  'location': [
    'geolocator',
    'location',
    'background_location',
    'flutter_background_geolocation',
  ],
  'voip': ['flutter_callkit_incoming', 'callkeep'],
  'fetch': ['workmanager', 'background_fetch'],
  'processing': ['workmanager', 'background_fetch'],
  'remote-notification': [
    'firebase_messaging',
    'onesignal_flutter',
    'airship_flutter',
  ],
  'bluetooth-central': ['flutter_blue_plus', 'flutter_reactive_ble'],
  'bluetooth-peripheral': ['flutter_ble_peripheral'],
};

/// Whether a plugin needs a purpose string in every app that links it.
enum KeyLevel {
  /// Every app that links the plugin needs the key.
  required,

  /// Only apps that use one feature of the plugin need the key; the plugin's
  /// README names the feature.
  conditional,
}

/// One Info.plist purpose-string key a plugin's README asks for.
class PluginKey {
  /// A key every app that links the plugin needs.
  const PluginKey.required(this.key) : condition = null;

  /// A key needed only when [condition] holds.
  const PluginKey.conditional(this.key, String this.condition);

  /// The Info.plist key.
  final String key;

  /// When the key is needed, completing "needed only if …" (for example
  /// `you record video`); `null` for a required key.
  final String? condition;

  /// [KeyLevel.conditional] when the README gives a condition.
  KeyLevel get level =>
      condition == null ? KeyLevel.required : KeyLevel.conditional;
}

/// The purpose strings one plugin asks for, and where its README says so.
class PluginPurposeStrings {
  /// Creates a table row.
  const PluginPurposeStrings({
    required this.source,
    required this.section,
    required this.keys,
  });

  /// Link to the README (or setup guide) section that lists the keys.
  final String source;

  /// Where [source] points, as a reader finds it: `image_picker README,
  /// "iOS"`.
  final String section;

  /// The keys, each with its level.
  final List<PluginKey> keys;
}

const _camera = PluginKey.required('NSCameraUsageDescription');
const _microphone = PluginKey.required('NSMicrophoneUsageDescription');
const _photoLibrary = PluginKey.required('NSPhotoLibraryUsageDescription');
const _whenInUse = PluginKey.required('NSLocationWhenInUseUsageDescription');

/// Info.plist purpose-string keys each plugin's README asks for, with the
/// level the README gives each one.
///
/// A missing required key means the build is refused at upload with
/// ITMS-90683, or the app is terminated by iOS the first time the API is
/// called. A key is conditional only when the plugin's own README says it is
/// needed for one feature; the condition is quoted from there.
const purposeStringsByPlugin = <String, PluginPurposeStrings>{
  'image_picker': PluginPurposeStrings(
    source: 'https://pub.dev/packages/image_picker#ios',
    section: 'image_picker README, "iOS"',
    keys: [
      _photoLibrary,
      _camera,
      // "describe why your app needs access to the microphone, if you
      // intend to record videos."
      PluginKey.conditional('NSMicrophoneUsageDescription', 'you record video'),
    ],
  ),
  'camera': PluginPurposeStrings(
    source: 'https://pub.dev/packages/camera#ios',
    section: 'camera README, "iOS"',
    keys: [_camera, _microphone],
  ),
  'mobile_scanner': PluginPurposeStrings(
    source: 'https://pub.dev/packages/mobile_scanner#ios',
    section: 'mobile_scanner README, "iOS"',
    keys: [_camera],
  ),
  'geolocator': PluginPurposeStrings(
    source: 'https://pub.dev/packages/geolocator#usage',
    section: 'geolocator README, "Usage" -> "iOS"',
    keys: [_whenInUse],
  ),
  'location': PluginPurposeStrings(
    source: 'https://pub.dev/packages/location#ios',
    section: 'location README, "iOS"',
    keys: [_whenInUse],
  ),
  'record': PluginPurposeStrings(
    source: 'https://pub.dev/packages/record#ios',
    section: 'record README, "iOS"',
    keys: [_microphone],
  ),
  'flutter_sound': PluginPurposeStrings(
    source:
        'https://flutter-sound.canardoux.xyz/tau/guides/guides-install.html#post-installation',
    section: 'Flutter Sound installation guide, "Post Installation"',
    keys: [_microphone],
  ),
  'speech_to_text': PluginPurposeStrings(
    source: 'https://pub.dev/packages/speech_to_text#ios--macos',
    section: 'speech_to_text README, "iOS & macOS"',
    keys: [
      PluginKey.required('NSSpeechRecognitionUsageDescription'),
      _microphone,
    ],
  ),
  'local_auth': PluginPurposeStrings(
    source: 'https://pub.dev/packages/local_auth_darwin#setup',
    section: 'local_auth_darwin README, "Setup"',
    keys: [PluginKey.required('NSFaceIDUsageDescription')],
  ),
  'flutter_contacts': PluginPurposeStrings(
    source: 'https://pub.dev/packages/flutter_contacts#2-configure-permissions',
    section: 'flutter_contacts README, "Configure Permissions"',
    keys: [PluginKey.required('NSContactsUsageDescription')],
  ),
  'flutter_blue_plus': PluginPurposeStrings(
    source:
        'https://pub.dev/packages/flutter_blue_plus#add-permissions-for-ios',
    section: 'flutter_blue_plus README, "Add permissions for iOS"',
    keys: [PluginKey.required('NSBluetoothAlwaysUsageDescription')],
  ),
  'photo_manager': PluginPurposeStrings(
    source: 'https://pub.dev/packages/photo_manager#ios-config-preparation',
    section: 'photo_manager README, "iOS config preparation"',
    keys: [_photoLibrary],
  ),
  'gal': PluginPurposeStrings(
    source: 'https://pub.dev/packages/gal#ios-setup',
    section: 'gal README, "iOS Setup"',
    keys: [PluginKey.required('NSPhotoLibraryAddUsageDescription')],
  ),
  'flutter_webrtc': PluginPurposeStrings(
    source: 'https://pub.dev/packages/flutter_webrtc#ios',
    section: 'flutter_webrtc README, "iOS"',
    keys: [_camera, _microphone],
  ),
  'livekit_client': PluginPurposeStrings(
    source: 'https://pub.dev/packages/livekit_client#ios',
    section: 'livekit_client README, "iOS"',
    keys: [_camera, _microphone],
  ),
  'agora_rtc_engine': PluginPurposeStrings(
    source: 'https://pub.dev/packages/agora_rtc_engine#ios--macos',
    section: 'agora_rtc_engine README, "iOS & macOS"',
    keys: [_microphone, _camera],
  ),
};

/// Words that describe the *permission itself* for each purpose-string key.
///
/// A purpose string made only of these (plus filler and the app's name)
/// restates the permission instead of describing a use.
const permissionVocabulary = <String, Set<String>>{
  'NSCameraUsageDescription': {
    'camera',
    'cameras',
    'photo',
    'photos',
    'picture',
    'pictures',
    'video',
    'videos',
    'take',
    'taking',
    'capture',
    'capturing',
    'record',
    'recording',
    'image',
    'images',
  },
  'NSMicrophoneUsageDescription': {
    'microphone',
    'mic',
    'audio',
    'sound',
    'sounds',
    'voice',
    'record',
    'recording',
    'records',
    'video',
    'videos',
    'speak',
  },
  'NSPhotoLibraryUsageDescription': {
    'photo',
    'photos',
    'library',
    'libraries',
    'gallery',
    'image',
    'images',
    'picture',
    'pictures',
    'video',
    'videos',
    'media',
    'camera',
    'roll',
    'select',
    'choose',
    'pick',
    'upload',
  },
  'NSPhotoLibraryAddUsageDescription': {
    'photo',
    'photos',
    'library',
    'gallery',
    'image',
    'images',
    'save',
    'saving',
    'add',
    'adding',
    'picture',
    'pictures',
    'video',
    'videos',
    'camera',
    'roll',
  },
  'NSLocationWhenInUseUsageDescription': {
    'location',
    'locations',
    'position',
    'where',
    'gps',
    'locate',
    'current',
  },
  'NSLocationAlwaysAndWhenInUseUsageDescription': {
    'location',
    'locations',
    'position',
    'where',
    'gps',
    'locate',
    'always',
    'background',
    'current',
  },
  'NSContactsUsageDescription': {'contact', 'contacts', 'address', 'book'},
  'NSCalendarsUsageDescription': {'calendar', 'calendars', 'event', 'events'},
  'NSCalendarsFullAccessUsageDescription': {
    'calendar',
    'calendars',
    'event',
    'events',
    'full',
  },
  'NSRemindersUsageDescription': {'reminder', 'reminders'},
  'NSBluetoothAlwaysUsageDescription': {
    'bluetooth',
    'devices',
    'device',
    'nearby',
    'connect',
  },
  'NSFaceIDUsageDescription': {
    'face',
    'id',
    'faceid',
    'biometric',
    'biometrics',
    'authenticate',
    'authentication',
  },
  'NSSpeechRecognitionUsageDescription': {
    'speech',
    'recognition',
    'recognize',
    'voice',
    'dictation',
  },
  'NSMotionUsageDescription': {'motion', 'fitness', 'activity', 'sensor'},
  'NSHealthShareUsageDescription': {'health', 'data', 'read'},
  'NSHealthUpdateUsageDescription': {'health', 'data', 'write', 'save'},
  'NSUserTrackingUsageDescription': {
    'track',
    'tracking',
    'tracked',
    'advertising',
    'ads',
    'personalized',
  },
  'NSLocalNetworkUsageDescription': {'local', 'network', 'devices', 'device'},
};

/// Words that carry no meaning on their own in a purpose string: filler,
/// generic permission phrasing, pronouns.
const purposeFiller = <String>{
  'a',
  'access',
  'accessing',
  'all',
  'allow',
  'allows',
  'also',
  'an',
  'and',
  'any',
  'app',
  'application',
  'are',
  'as',
  'be',
  'by',
  'can',
  'could',
  'data',
  'device',
  "device's",
  'do',
  'does',
  'enable',
  'enables',
  'feature',
  'features',
  'for',
  'from',
  'functionality',
  'get',
  'give',
  'grant',
  'has',
  'have',
  'here',
  'i',
  'in',
  'is',
  'it',
  'its',
  'just',
  'let',
  'lets',
  'like',
  'make',
  'may',
  'me',
  'might',
  'more',
  'my',
  'need',
  'needed',
  'needs',
  'of',
  'on',
  'or',
  'order',
  'our',
  'permission',
  'permissions',
  'please',
  'properly',
  'provide',
  'require',
  'required',
  'requires',
  'some',
  'so',
  'that',
  'the',
  'their',
  'them',
  'this',
  'to',
  'us',
  'use',
  'used',
  'uses',
  'using',
  'want',
  'wants',
  'we',
  'when',
  'will',
  'with',
  'work',
  'would',
  'you',
  'your',
  "you're",
};

/// Phrases that introduce a concrete example, as Apple's guidance asks for.
const exampleMarkers = <String>[
  'for example',
  'for instance',
  'e.g.',
  'such as',
  'like when',
];
