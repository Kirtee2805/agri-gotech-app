// main.dart
// Welcome to the Agri-GoTech Flutter Application!
// This single file contains the entire source code for the app.
// To run this, ensure you have the following packages in your pubspec.yaml:
// dependencies:
//   flutter:
//     sdk: flutter
//   google_fonts: ^6.2.1
//   syncfusion_flutter_gauges: ^25.2.5
//   intl: ^0.19.0

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

//==============================================================================
// 1. APP CONFIGURATION & THEME
//==============================================================================

const Color _primaryColor = Color(0xFF2E7D32); // Vibrant Organic Green
const Color _secondaryColor = Color(0xFF6D4C41); // Warm Earthy Brown
const Color _backgroundColor = Color(0xFFFCFBF8); // Light Warm Off-white
const Color _aiChatBubbleColor = Color(0xFF1976D2); // Friendly Blue
const Color _textColor = Color(0xFF333333);

final ThemeData agriGoTechTheme = ThemeData(
  scaffoldBackgroundColor: _backgroundColor,
  primaryColor: _primaryColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primaryColor,
    primary: _primaryColor,
    secondary: _secondaryColor,
    background: _backgroundColor,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: _backgroundColor,
    elevation: 0,
    iconTheme: const IconThemeData(color: _secondaryColor),
    titleTextStyle: GoogleFonts.poppins(
      color: _secondaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  ),
  // FIX: Changed CardTheme to CardThemeData
  cardTheme: CardThemeData(
    elevation: 4.0,
    color: Colors.white,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: _primaryColor,
    unselectedItemColor: _secondaryColor,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);

//==============================================================================
// 2. DATA MODELS & KNOWLEDGE BASE
//==============================================================================

class GrowthStage {
  final String en;
  final String gu;
  final String hi;
  final String ta;
  final String te;
  final int lowerThreshold;
  final int upperThreshold;

  GrowthStage({
    required this.en,
    required this.gu,
    required this.hi,
    required this.ta,
    required this.te,
    required this.lowerThreshold,
    required this.upperThreshold,
  });

  String name(String langCode) {
    switch (langCode) {
      case 'gu': return gu;
      case 'hi': return hi;
      case 'ta': return ta;
      case 'te': return te;
      default: return en;
    }
  }
}

class Crop {
  final String id;
  final String en;
  final String gu;
  final String hi;
  final String ta;
  final String te;
  final IconData icon;
  final List<GrowthStage> stages;

  Crop({
    required this.id,
    required this.en,
    required this.gu,
    required this.hi,
    required this.ta,
    required this.te,
    required this.icon,
    required this.stages,
  });

  String name(String langCode) {
    switch (langCode) {
      case 'gu': return gu;
      case 'hi': return hi;
      case 'ta': return ta;
      case 'te': return te;
      default: return en;
    }
  }
}

final List<Crop> cropKnowledgeBase = [
  Crop(
    id: 'groundnut',
    en: 'Groundnut', gu: 'મગફળી', hi: 'मूंगफली', ta: 'நிலக்கடலை', te: 'వేరుశనగ',
    icon: Icons.spa,
    stages: [
      GrowthStage(en: 'Flowering', gu: 'ફૂલ આવવા', hi: 'फूल आना', ta: 'பூக்கும் நிலை', te: 'పుష్పించే దశ', lowerThreshold: 60, upperThreshold: 80),
      GrowthStage(en: 'Pegging', gu: 'સોયા પડવા', hi: 'पेगिंग', ta: 'காய் பிடிக்கும் நிலை', te: 'పెగ్గింగ్ దశ', lowerThreshold: 70, upperThreshold: 85),
      GrowthStage(en: 'Pod Formation', gu: 'દાણા ભરાવા', hi: 'फली बनना', ta: 'காய் உருவாதல்', te: 'కాయ ఏర్పడే దశ', lowerThreshold: 70, upperThreshold: 85),
    ],
  ),
  Crop(
    id: 'cotton',
    en: 'Cotton', gu: 'કપાસ', hi: 'कपास', ta: 'பருத்தி', te: 'పత్తి',
    icon: Icons.filter_vintage,
    stages: [
      GrowthStage(en: 'Vegetative', gu: 'વાનસ્પતિક', hi: 'वनस्पति', ta: 'தாவர வளர்ச்சி', te: 'శాఖీయ దశ', lowerThreshold: 40, upperThreshold: 60),
      GrowthStage(en: 'Flowering & Boll', gu: 'ફૂલ અને જીંડવા', hi: 'फूल और डोडे', ta: 'பூத்தல் மற்றும் காய்', te: 'పుష్పించడం & కాయ', lowerThreshold: 65, upperThreshold: 85),
      GrowthStage(en: 'Maturity', gu: 'પાકવુ', hi: 'परिपक्वता', ta: 'முதிர்ச்சி', te: 'పరిపక్వత దశ', lowerThreshold: 40, upperThreshold: 50),
    ],
  ),
  Crop(
    id: 'wheat',
    en: 'Wheat', gu: 'ઘઉં', hi: 'गेहूँ', ta: 'கோதுமை', te: 'గోధుమ',
    icon: Icons.grain,
    stages: [
      GrowthStage(en: 'Crown Root Init.', gu: 'તાજ મૂળ', hi: 'क्राउन रूट', ta: 'முடி வேர்', te: 'క్రౌన్ రూట్', lowerThreshold: 50, upperThreshold: 70),
      GrowthStage(en: 'Flowering', gu: 'ફૂલ આવવા', hi: 'फूल आना', ta: 'பூக்கும் நிலை', te: 'పుష్పించే దశ', lowerThreshold: 60, upperThreshold: 80),
    ],
  ),
  Crop(
    id: 'cumin',
    en: 'Cumin', gu: 'જીરૂ', hi: 'जीरा', ta: 'சீரகம்', te: 'జీలకర్ర',
    icon: Icons.scatter_plot,
    stages: [
      GrowthStage(en: 'Germination', gu: 'અંકુરણ', hi: 'अंकुरण', ta: 'முளைப்பு', te: 'అంకురోత్పత్తి', lowerThreshold: 50, upperThreshold: 65),
      GrowthStage(en: 'Flowering', gu: 'ફૂલ આવવા', hi: 'फूल आना', ta: 'பூக்கும் நிலை', te: 'పుష్పించే దశ', lowerThreshold: 55, upperThreshold: 70),
    ],
  ),
];


//==============================================================================
// 3. MULTI-LANGUAGE STRINGS
//==============================================================================

class AppLocalizations {
  final String locale;
  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'login_title': 'Welcome to Agri-GoTech',
      'login_subtitle': 'Smart Farming, Simplified.',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'dashboard': 'Dashboard',
      'crop_hub': 'Crop Hub',
      'ai_assistant': 'AI Assistant',
      'profile': 'Profile',
      'field_water_level': 'Field Water Level',
      'pump_control': 'Manual Pump Control',
      'pump_on': 'ON',
      'pump_off': 'OFF',
      'crop_info_guide': 'Crop Information Guide',
      'critical_moisture': 'Critical Moisture Range:',
      'ask_anything': 'Ask me anything about your farm...',
      'user_name': 'Saurashtra Farmer',
      'select_crop': 'Select Your Crop',
      'select_stage': 'Select Current Growth Stage',
      'select_language': 'Select Language',
      'notification_pump_start': '💧 Your %s needs water! The pump has started automatically.',
      'notification_pump_stop': '✅ Watering complete! The pump has stopped to save water.',
      'notification_manual_start': '🔧 Manual Override: Pump turned ON.',
      'notification_manual_stop': '🔧 Manual Override: Pump turned OFF.',
      'ai_response_pump': 'The pump started because the soil moisture for your %s dropped to %.0f%%, which is below the %d%% threshold needed for its current %s stage.',
      'ai_response_generic': "That's a great question. I am analyzing your farm's data to provide an answer soon.",
    },
    'gu': {
      'login_title': 'એગ્રી-ગોટેકમાં આપનું સ્વાગત છે',
      'login_subtitle': 'સ્માર્ટ ખેતી, સરળીકૃત.',
      'email': 'ઈમેલ',
      'password': 'પાસવર્ડ',
      'login': 'લોગિન',
      'dashboard': 'ડેશબોર્ડ',
      'crop_hub': 'પાક માહિતી',
      'ai_assistant': 'AI સહાયક',
      'profile': 'પ્રોફાઇલ',
      'field_water_level': 'ખેતરમાં ભેજનું સ્તર',
      'pump_control': 'મેન્યુઅલ પંપ નિયંત્રણ',
      'pump_on': 'ચાલુ',
      'pump_off': 'બંધ',
      'crop_info_guide': 'પાક માહિતી માર્ગદર્શિકા',
      'critical_moisture': 'જરૂરી ભેજની શ્રેણી:',
      'ask_anything': 'તમારા ખેતર વિશે કંઈપણ પૂછો...',
      'user_name': 'સૌરાષ્ટ્રના ખેડૂત',
      'select_crop': 'તમારો પાક પસંદ કરો',
      'select_stage': 'વર્તમાન વૃદ્ધિનો તબક્કો પસંદ કરો',
      'select_language': 'ભાષા પસંદ કરો',
      'notification_pump_start': '💧 તમારા %s ને પાણીની જરૂર છે! પંપ આપમેળે શરૂ થયો છે.',
      'notification_pump_stop': '✅ પિયત પૂર્ણ! પાણી બચાવવા માટે પંપ બંધ થઈ ગયો છે.',
      'notification_manual_start': '🔧 મેન્યુઅલ ઓવરરાઇડ: પંપ ચાલુ કરવામાં આવ્યો.',
      'notification_manual_stop': '🔧 મેન્યુઅલ ઓવરરાઇડ: પંપ બંધ કરવામાં આવ્યો.',
      'ai_response_pump': 'પંપ એટલા માટે શરૂ થયો કારણ કે તમારા %s માટે જમીનનો ભેજ %.0f%% થઈ ગયો હતો, જે તેના વર્તમાન %s તબક્કા માટે જરૂરી %d%% ની નીચે છે.',
      'ai_response_generic': 'ખૂબ સરસ પ્રશ્ન. હું જવાબ આપવા માટે તમારા ફાર્મના ડેટાનું વિશ્લેષણ કરી રહ્યો છું.',
    },
    'hi': {
      'login_title': 'एग्री-गोटेक में आपका स्वागत है',
      'login_subtitle': 'स्मार्ट खेती, सरलीकृत।',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'login': 'लॉग इन करें',
      'dashboard': 'डैशबोर्ड',
      'crop_hub': 'फसल जानकारी',
      'ai_assistant': 'AI सहायक',
      'profile': 'प्रोफ़ाइल',
      'field_water_level': 'खेत में पानी का स्तर',
      'pump_control': 'मैनुअल पंप नियंत्रण',
      'pump_on': 'चालू',
      'pump_off': 'बंद',
      'crop_info_guide': 'फसल सूचना गाइड',
      'critical_moisture': 'महत्वपूर्ण नमी सीमा:',
      'ask_anything': 'अपने खेत के बारे में कुछ भी पूछें...',
      'user_name': 'सौराष्ट्र किसान',
      'select_crop': 'अपनी फसल चुनें',
      'select_stage': 'वर्तमान विकास चरण चुनें',
      'select_language': 'भाषा चुनें',
      'notification_pump_start': '💧 आपकी %s को पानी चाहिए! पंप स्वचालित रूप से शुरू हो गया है।',
      'notification_pump_stop': '✅ सिंचाई पूरी! पानी बचाने के लिए पंप बंद हो गया है।',
      'notification_manual_start': '🔧 मैनुअल ओवरराइड: पंप चालू किया गया।',
      'notification_manual_stop': '🔧 मैनुअल ओवरराइड: पंप बंद किया गया।',
      'ai_response_pump': 'पंप इसलिए शुरू हुआ क्योंकि आपकी %s के लिए मिट्टी की नमी %.0f%% तक गिर गई, जो उसके वर्तमान %s चरण के लिए आवश्यक %d%% से નીચે है।',
      'ai_response_generic': 'यह एक अच्छा सवाल है। मैं जवाब देने के लिए आपके खेत के डेटा का विश्लेषण कर रहा हूं।',
    },
    'ta': {
      'login_title': 'அக்ரி-கோடெக்கிற்கு வரவேற்கிறோம்',
      'login_subtitle': 'திறன்மிகு வேளாண்மை, எளிமையானது.',
      'email': 'மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
      'login': 'உள்நுழை',
      'dashboard': 'முகப்பு',
      'crop_hub': 'பயிர் மையம்',
      'ai_assistant': 'AI உதவியாளர்',
      'profile': 'சுயவிவரம்',
      'field_water_level': 'வயல் நீர் மட்டம்',
      'pump_control': 'கையேடு பம்ப் கட்டுப்பாடு',
      'pump_on': 'ஆன்',
      'pump_off': 'ஆஃப்',
      'crop_info_guide': 'பயிர் தகவல் வழிகாட்டி',
      'critical_moisture': 'முக்கிய ஈரப்பதம் வரம்பு:',
      'ask_anything': 'உங்கள் பண்ணையைப் பற்றி எதுவும் கேளுங்கள்...',
      'user_name': 'சௌராஷ்டிரா விவசாயி',
      'select_crop': 'உங்கள் பயிரைத் தேர்ந்தெடுக்கவும்',
      'select_stage': 'தற்போதைய வளர்ச்சி நிலையைத் தேர்ந்தெடுக்கவும்',
      'select_language': 'மொழியை தேர்ந்தெடு',
      'notification_pump_start': '💧 உங்கள் %s க்கு தண்ணீர் தேவை! பம்ப் தானாகவே இயங்கத் தொடங்கியது.',
      'notification_pump_stop': '✅ நீர்ப்பாசனம் முடிந்தது! தண்ணீரைக் சேமிக்க பம்ப் நிறுத்தப்பட்டது.',
      'notification_manual_start': '🔧 கையேடு மேலாதிக்கம்: பம்ப் ஆன் செய்யப்பட்டது.',
      'notification_manual_stop': '🔧 கையேடு மேலாதிக்கம்: பம்ப் ஆஃப் செய்யப்பட்டது.',
      'ai_response_pump': 'உங்கள் %s க்கான மண் ஈரம் %.0f%% ஆகக் குறைந்துவிட்டதால் பம்ப் இயங்கத் தொடங்கியது, இது தற்போதைய %s நிலைக்கான தேவைப்படும் %d%% க்கு குறைவாக உள்ளது.',
      'ai_response_generic': 'இது ஒரு சிறந்த கேள்வி. பதில் அளிக்க உங்கள் பண்ணையின் தரவை நான் பகுப்பாய்வு செய்கிறேன்.',
    },
    'te': {
      'login_title': 'అగ్రి-గోటెక్‌కు స్వాగతం',
      'login_subtitle': 'స్మార్ట్ వ్యవసాయం, సరళీకృతం.',
      'email': 'ఇమెయిల్',
      'password': 'పాస్వర్డ్',
      'login': 'లాగిన్',
      'dashboard': 'డాష్‌బోర్డ్',
      'crop_hub': 'పంట కేంద్రం',
      'ai_assistant': 'AI సహాయకుడు',
      'profile': 'ప్రొఫైల్',
      'field_water_level': 'క్షేత్ర నీటి మట్టం',
      'pump_control': 'మాన్యువల్ పంప్ నియంత్రణ',
      'pump_on': 'ఆన్',
      'pump_off': 'ఆఫ్',
      'crop_info_guide': 'పంట సమాచార గైడ్',
      'critical_moisture': 'క్లిష్టమైన తేమ పరిధి:',
      'ask_anything': 'మీ వ్యవసాయ క్షేత్రం గురించి ఏదైనా అడగండి...',
      'user_name': 'సౌరాష్ట్ర రైతు',
      'select_crop': 'మీ పంటను ఎంచుకోండి',
      'select_stage': 'ప్రస్తుత పెరుగుదల దశను ఎంచుకోండి',
      'select_language': 'భాషను ఎంచుకోండి',
      'notification_pump_start': '💧 మీ %s కి నీరు అవసరం! పంప్ స్వయంచాలకంగా ప్రారంభమైంది.',
      'notification_pump_stop': '✅ నీటిపారుదల పూర్తయింది! నీటిని ఆదా చేయడానికి పంప్ ఆగిపోయింది.',
      'notification_manual_start': '🔧 మాన్యువల్ ఓవర్‌రైడ్: పంప్ ఆన్ చేయబడింది.',
      'notification_manual_stop': '🔧 మాన్యువల్ ఓవర్‌రైడ్: పంప్ ఆఫ్ చేయబడింది.',
      'ai_response_pump': 'మీ %s కోసం నేల తేమ %.0f%% కి పడిపోయినందున పంప్ ప్రారంభమైంది, ఇది దాని ప్రస్తుత %s దశకు అవసరమైన %d%% కంటే తక్కువ.',
      'ai_response_generic': 'అది గొప్ప ప్రశ్న. సమాధానం అందించడానికి నేను మీ వ్యవసాయ క్షేత్రం యొక్క డేటాను విశ్లేషిస్తున్నాను.',
    },
  };

  String get(String key) {
    return _localizedValues[locale]![key] ?? key;
  }
}

//==============================================================================
// 4. MAIN APPLICATION ENTRY POINT
//==============================================================================

void main() {
  runApp(const AgriGoTechApp());
}

class AgriGoTechApp extends StatelessWidget {
  const AgriGoTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri-GoTech',
      theme: agriGoTechTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

//==============================================================================
// 5. LOGIN SCREEN
//==============================================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations(_selectedLanguage);
    
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/farm_background.jpg', 
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
            // Add an error builder for better debugging
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text(
                  'Could not load background image.\nMake sure "assets/farm_background.jpg" exists\nand is declared in pubspec.yaml',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.yellow),
                ),
              );
            },
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  const Icon(Icons.eco, color: Colors.white, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    strings.get('login_title'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    strings.get('login_subtitle'),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 60),
                  _buildTextField(strings.get('email'), Icons.email_outlined),
                  const SizedBox(height: 16),
                  _buildTextField(strings.get('password'), Icons.lock_outline, obscureText: true),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context, 
                          '/home', 
                          arguments: _selectedLanguage,
                        );
                      },
                      child: Text(strings.get('login')),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildLanguageSelector(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          isExpanded: true,
          dropdownColor: _secondaryColor,
          icon: const Icon(Icons.language, color: Colors.white70),
          style: const TextStyle(color: Colors.white),
          onChanged: (String? newValue) {
            setState(() {
              _selectedLanguage = newValue!;
            });
          },
          items: <String>['en', 'gu', 'hi', 'ta', 'te']
              .map<DropdownMenuItem<String>>((String value) {
            String languageName = 'English';
            switch (value) {
              case 'gu': languageName = 'ગુજરાતી'; break;
              case 'hi': languageName = 'हिन्दी'; break;
              case 'ta': languageName = 'தமிழ்'; break;
              case 'te': languageName = 'తెలుగు'; break;
            }
            return DropdownMenuItem<String>(
              value: value,
              child: Text(languageName, style: GoogleFonts.poppins()),
            );
          }).toList(),
        ),
      ),
    );
  }
}

//==============================================================================
// 6. MAIN APP SCREEN (WITH STATE MANAGEMENT & NAVIGATION)
//==============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedLanguage = 'en';
  Crop _selectedCrop = cropKnowledgeBase[0];
  late GrowthStage _selectedGrowthStage;
  
  double _liveMoisture = 55.0; 
  bool _isPumpOn = false;
  bool _isManualOverride = false;
  Timer? _dataSimulatorTimer;

  bool _showNotification = false;
  String _notificationMessage = '';
  Color _notificationColor = _primaryColor;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageArgument = ModalRoute.of(context)?.settings.arguments as String?;
    if (languageArgument != null) {
      _selectedLanguage = languageArgument;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedGrowthStage = _selectedCrop.stages[0];
    _startDataSimulation();
  }

  @override
  void dispose() {
    _dataSimulatorTimer?.cancel();
    super.dispose();
  }

  void _startDataSimulation() {
    _dataSimulatorTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        if (_isPumpOn) {
          _liveMoisture += Random().nextDouble() * 2.5 + 1.0;
        } else {
          _liveMoisture -= Random().nextDouble() * 1.5 + 0.5;
        }
        _liveMoisture = _liveMoisture.clamp(25.0, 90.0);

        if (!_isManualOverride) {
          _runAutomationLogic();
        }
      });
    });
  }

  void _runAutomationLogic() {
    final lowerThreshold = _selectedGrowthStage.lowerThreshold;
    final upperThreshold = _selectedGrowthStage.upperThreshold;

    if (_liveMoisture < lowerThreshold && !_isPumpOn) {
      _isPumpOn = true;
      final msg = AppLocalizations(_selectedLanguage).get('notification_pump_start');
      _triggerNotification(sprintf(msg, [_selectedCrop.name(_selectedLanguage)]), _primaryColor);
    } 
    else if (_liveMoisture > upperThreshold && _isPumpOn) {
      _isPumpOn = false;
      final msg = AppLocalizations(_selectedLanguage).get('notification_pump_stop');
      _triggerNotification(sprintf(msg, []), Colors.green.shade800);
    }
  }

  void _triggerNotification(String message, Color color) {
    if (!mounted) return;
    setState(() {
      _notificationMessage = message;
      _notificationColor = color;
      _showNotification = true;
    });
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showNotification = false;
        });
      }
    });
  }

  void _onLanguageChanged(String newLanguage) {
    setState(() {
      _selectedLanguage = newLanguage;
    });
  }

  void _onCropChanged(Crop newCrop) {
    setState(() {
      _selectedCrop = newCrop;
      _selectedGrowthStage = newCrop.stages[0];
    });
  }

  void _onStageChanged(GrowthStage newStage) {
    setState(() {
      _selectedGrowthStage = newStage;
    });
  }
  
  void _onManualPumpToggle(bool isOn) {
    setState(() {
      _isManualOverride = true;
      _isPumpOn = isOn;
      final msgKey = isOn ? 'notification_manual_start' : 'notification_manual_stop';
      final msg = AppLocalizations(_selectedLanguage).get(msgKey);
      _triggerNotification(msg, _secondaryColor);
    });
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
         _isManualOverride = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations(_selectedLanguage);

    final List<Widget> pages = [
      DashboardScreen(
        liveMoisture: _liveMoisture,
        isPumpOn: _isPumpOn,
        onManualPumpToggle: _onManualPumpToggle,
        selectedLanguage: _selectedLanguage,
      ),
      CropHubScreen(selectedLanguage: _selectedLanguage),
      AiAssistantScreen(
        selectedLanguage: _selectedLanguage,
        selectedCrop: _selectedCrop,
        selectedGrowthStage: _selectedGrowthStage,
        liveMoisture: _liveMoisture,
      ),
      ProfileScreen(
        selectedCrop: _selectedCrop,
        selectedStage: _selectedGrowthStage,
        selectedLanguage: _selectedLanguage,
        onCropChanged: _onCropChanged,
        onStageChanged: _onStageChanged,
        onLanguageChanged: _onLanguageChanged,
      ),
    ];
    
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            top: _showNotification ? MediaQuery.of(context).padding.top + 10 : -100,
            left: 16,
            right: 16,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _notificationColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _notificationMessage,
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard_rounded), label: strings.get('dashboard')),
          BottomNavigationBarItem(icon: const Icon(Icons.library_books_rounded), label: strings.get('crop_hub')),
          BottomNavigationBarItem(icon: const Icon(Icons.smart_toy_rounded), label: strings.get('ai_assistant')),
          BottomNavigationBarItem(icon: const Icon(Icons.person_rounded), label: strings.get('profile')),
        ],
      ),
    );
  }
}

//==============================================================================
// 7. DASHBOARD SCREEN
//==============================================================================

class DashboardScreen extends StatelessWidget {
  final double liveMoisture;
  final bool isPumpOn;
  final Function(bool) onManualPumpToggle;
  final String selectedLanguage;

  const DashboardScreen({
    super.key,
    required this.liveMoisture,
    required this.isPumpOn,
    required this.onManualPumpToggle,
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations(selectedLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.get('dashboard')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            strings.get('field_water_level'),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 18, color: _textColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 20),
          _buildMoistureGauge(),
          const SizedBox(height: 40),
          _buildPumpControlCard(context, strings),
        ],
      ),
    );
  }

  Widget _buildMoistureGauge() {
    return SizedBox(
      height: 300,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            startAngle: 180,
            endAngle: 0,
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              cornerStyle: CornerStyle.bothCurve,
              color: Colors.grey.shade300,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: liveMoisture,
                cornerStyle: CornerStyle.bothCurve,
                width: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
                gradient: const SweepGradient(
                  colors: <Color>[Color(0xFF6DD5FA), Color(0xFF2980B9)],
                  stops: <double>[0.25, 0.75],
                ),
              ),
              MarkerPointer(
                value: liveMoisture,
                markerType: MarkerType.circle,
                color: Colors.white,
                markerHeight: 25,
                markerWidth: 25,
                borderWidth: 5,
                borderColor: const Color(0xFF2980B9),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  '${liveMoisture.toStringAsFixed(1)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2980B9),
                  ),
                ),
                angle: 90,
                positionFactor: 0.1,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPumpControlCard(BuildContext context, AppLocalizations strings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              strings.get('pump_control'),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _secondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Transform.scale(
              scale: 1.5,
              child: Switch(
                value: isPumpOn,
                onChanged: onManualPumpToggle,
                activeTrackColor: _primaryColor.withOpacity(0.5),
                activeColor: _primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPumpOn ? strings.get('pump_on') : strings.get('pump_off'),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isPumpOn ? _primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==============================================================================
// 8. CROP HUB SCREEN
//==============================================================================

class CropHubScreen extends StatefulWidget {
  final String selectedLanguage;
  const CropHubScreen({super.key, required this.selectedLanguage});

  @override
  _CropHubScreenState createState() => _CropHubScreenState();
}

class _CropHubScreenState extends State<CropHubScreen> {
  String? _expandedCropId;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations(widget.selectedLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.get('crop_info_guide')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: cropKnowledgeBase.length,
        itemBuilder: (context, index) {
          final crop = cropKnowledgeBase[index];
          final isExpanded = crop.id == _expandedCropId;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                setState(() {
                  _expandedCropId = isExpanded ? null : crop.id;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(crop.icon, color: _primaryColor, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            crop.name(widget.selectedLanguage),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _secondaryColor,
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: _secondaryColor,
                        ),
                      ],
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                      child: Visibility(
                        visible: isExpanded,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: crop.stages.map((stage) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0, left: 42.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stage.name(widget.selectedLanguage),
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${strings.get('critical_moisture')} ${stage.lowerThreshold}% - ${stage.upperThreshold}%',
                                      style: GoogleFonts.poppins(color: _textColor.withOpacity(0.8)),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//==============================================================================
// 9. AI ASSISTANT SCREEN
//==============================================================================
class AiAssistantScreen extends StatefulWidget {
  final String selectedLanguage;
  final Crop selectedCrop;
  final GrowthStage selectedGrowthStage;
  final double liveMoisture;

  const AiAssistantScreen({
    super.key,
    required this.selectedLanguage,
    required this.selectedCrop,
    required this.selectedGrowthStage,
    required this.liveMoisture,
  });

  @override
  _AiAssistantScreenState createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  bool get wantKeepAlive => true;
  
  void _sendMessage() async {
    final messageText = _controller.text;
    if (messageText.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': messageText});
      _isLoading = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(seconds: 2));

    String aiResponse;
    final strings = AppLocalizations(widget.selectedLanguage);
    
    if (messageText.toLowerCase().contains("pump") || messageText.contains("પાણી")) {
      final responseTemplate = strings.get('ai_response_pump');
      aiResponse = sprintf(responseTemplate, [
        widget.selectedCrop.name(widget.selectedLanguage),
        widget.liveMoisture,
        widget.selectedGrowthStage.lowerThreshold,
        widget.selectedGrowthStage.name(widget.selectedLanguage),
      ]);
    } else {
      aiResponse = strings.get('ai_response_generic');
    }
    
    if(!mounted) return;
    setState(() {
      _messages.add({'role': 'ai', 'content': aiResponse});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final strings = AppLocalizations(widget.selectedLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.get('ai_assistant')),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              reverse: true,
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == 0) {
                  return const AiMessageBubble(isTyping: true, content: '');
                }
                final messageIndex = _isLoading ? index - 1 : index;
                final message = _messages.reversed.toList()[messageIndex];
                final bool isUser = message['role'] == 'user';
                
                return isUser
                    ? UserMessageBubble(content: message['content']!)
                    : AiMessageBubble(content: message['content']!);
              },
            ),
          ),
          _buildMessageInput(strings),
        ],
      ),
    );
  }

  Widget _buildMessageInput(AppLocalizations strings) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: strings.get('ask_anything'),
                  fillColor: _backgroundColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: _primaryColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserMessageBubble extends StatelessWidget {
  final String content;
  const UserMessageBubble({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: _primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Text(content, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class AiMessageBubble extends StatelessWidget {
  final String content;
  final bool isTyping;
  const AiMessageBubble({super.key, required this.content, this.isTyping = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isTyping ? Colors.grey.shade300 : _aiChatBubbleColor.withOpacity(0.15),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: isTyping 
          ? const SizedBox(height: 24, width: 40, child: Text("..."))
          : Text(content, style: TextStyle(color: _textColor)),
      ),
    );
  }
}

//==============================================================================
// 10. PROFILE SCREEN
//==============================================================================

class ProfileScreen extends StatelessWidget {
  final Crop selectedCrop;
  final GrowthStage selectedStage;
  final String selectedLanguage;
  final Function(Crop) onCropChanged;
  final Function(GrowthStage) onStageChanged;
  final Function(String) onLanguageChanged;

  const ProfileScreen({
    super.key,
    required this.selectedCrop,
    required this.selectedStage,
    required this.selectedLanguage,
    required this.onCropChanged,
    required this.onStageChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations(selectedLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.get('profile')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(strings),
          const SizedBox(height: 24),
          _buildSectionTitle(strings.get('select_crop'), Icons.eco),
          const SizedBox(height: 12),
          _buildCropSelection(),
          const SizedBox(height: 24),
          _buildSectionTitle(strings.get('select_stage'), Icons.grass),
          const SizedBox(height: 12),
          _buildStageSelection(),
          const SizedBox(height: 24),
          _buildSectionTitle(strings.get('select_language'), Icons.language),
          const SizedBox(height: 12),
          _buildLanguageSelectionCard(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(AppLocalizations strings) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: _secondaryColor,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.get('user_name'),
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Rajkot, Gujarat",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildCropSelection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: cropKnowledgeBase.length,
      itemBuilder: (context, index) {
        final crop = cropKnowledgeBase[index];
        final isSelected = crop.id == selectedCrop.id;
        return GestureDetector(
          onTap: () => onCropChanged(crop),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? _primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _primaryColor : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ] : [],
            ),
            child: Center(
              child: Text(
                crop.name(selectedLanguage),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : _secondaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStageSelection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: selectedCrop.stages.map((stage) {
        final isSelected = stage.en == selectedStage.en;
        return GestureDetector(
          onTap: () => onStageChanged(stage),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _primaryColor.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _primaryColor, width: 1.5),
            ),
            child: Text(
              stage.name(selectedLanguage),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: _primaryColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildLanguageSelectionCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedLanguage,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: _primaryColor),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onLanguageChanged(newValue);
              }
            },
            items: <String>['en', 'gu', 'hi', 'ta', 'te']
                .map<DropdownMenuItem<String>>((String value) {
              String languageName = 'English';
              switch (value) {
                case 'gu': languageName = 'ગુજરાતી'; break;
                case 'hi': languageName = 'हिन्दी'; break;
                case 'ta': languageName = 'தமிழ்'; break;
                case 'te': languageName = 'తెలుగు'; break;
              }
              return DropdownMenuItem<String>(
                value: value,
                child: Text(languageName, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

//==============================================================================
// 11. UTILITY FUNCTIONS
//==============================================================================

/// A simple sprintf implementation for string formatting.
String sprintf(String template, List<dynamic> args) {
  var i = 0;
  return template.replaceAllMapped(RegExp(r'%[sd.0-9f]'), (match) {
    if (i < args.length) {
      final arg = args[i++];
      if (match.group(0) == '%.0f') {
        return (arg as num).toStringAsFixed(0);
      }
      return arg.toString();
    }
    return match.group(0)!;
  });
}