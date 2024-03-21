import 'package:cabby/config/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

void saveTokenToDatabase(String token, String userId) async {
  final supabaseClient = Supabase.instance.client;
  logger("Saving token to database");

  const uuid = Uuid();
  try {
    // Check if a record with this user_id already exists
    List<dynamic> existingRecordResponse = await supabaseClient
        .from('userTokens')
        .select()
        .eq('userId', userId);

        logger("Existing record response: $existingRecordResponse");

    if (existingRecordResponse.isNotEmpty) {
      // Record exists, update it
      logger("Record exists, updating it");
      await supabaseClient.from('userTokens').update({
        'token': token,
      }).eq('userId', userId);
      logger("Token updated in database");
    } else {
      logger("Record does not exist, inserting it");
      // No record exists, insert a new one
      await supabaseClient.from('userTokens').insert({
        'id': uuid.v4(),
        'userId': userId,
        'token': token,
      });
      logger("Token saved to database");
    }
  } catch (e) {
    logger('Error saving token: $e');
  }
}
