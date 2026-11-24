import 'package:medical_appointment_app/core/errors/api_exception.dart';

String errorMessage(Object error) {
  if (error is ApiException) return error.message;
  if (error is FormatException) {
    return 'Serverul a trimis date JSON invalide: ${error.message}';
  }
  return 'Datele nu au putut fi incarcate. Verifica internetul si reincearca.';
}
