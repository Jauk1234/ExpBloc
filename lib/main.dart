import 'package:bloc/bloc.dart';
import 'package:exp/app.dart';
import 'package:exp/simple_bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
    logger.i('Environment variables loaded successfully');
  } catch (e) {
    logger.i('Error loading .env file: $e');
  }
  final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final String supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );

    logger.i('Supabase initialized successfully');
  } catch (e) {
    logger.i('Error initializing Supabase: $e');
  }
  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}
