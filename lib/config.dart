/// Llaves de Supabase leídas de env.json con --dart-define-from-file (AD-06).
class Config {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static bool get completa => supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;
}
