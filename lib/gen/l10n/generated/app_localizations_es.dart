// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_name => 'Beacon';

  @override
  String get settings => 'Ajustes';

  @override
  String get nearby_devices => 'Dispositivos cercanos';

  @override
  String get searching_devices => 'Buscando dispositivos en tu red…';

  @override
  String get transfers => 'Transferencias';

  @override
  String get drop_zone_select_device => 'Selecciona un dispositivo arriba para enviar archivos';

  @override
  String drop_zone_tap_to_pick(String name) {
    return 'Toca para elegir archivos\ny enviar a $name';
  }

  @override
  String drop_zone_release_to_send(String name) {
    return 'Suelta para enviar a $name';
  }

  @override
  String drop_zone_drop_files(String name) {
    return 'Arrastra archivos aquí\npara enviar a $name';
  }

  @override
  String get status => 'Estado';

  @override
  String get status_running => 'En línea';

  @override
  String get status_starting => 'Iniciando…';

  @override
  String get status_stopped => 'Desconectado';

  @override
  String get status_error => 'Error';

  @override
  String get open_folder => 'Abrir carpeta';

  @override
  String get open_folder_failed => 'No se pudo abrir la carpeta';

  @override
  String get appearance => 'Apariencia';

  @override
  String get theme_system => 'Predeterminado del sistema';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_dark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get lang_en => 'Inglés';

  @override
  String get lang_es => 'Español';

  @override
  String get oops_you_should_not_be_here => 'Oops! No deberías estar aquí. Vamos a donde empezamos.';

  @override
  String get go_home => 'Ir a inicio';

  @override
  String get unknown_page => 'Página desconocida';

  @override
  String get privacy_policy => 'Política de privacidad';

  @override
  String get privacy_policy_subtitle => 'Cómo tratamos tus archivos y datos';

  @override
  String get privacy_policy_close => 'Cerrar';

  @override
  String get privacy_policy_intro =>
      'Beacon es una herramienta gratuita que te permite compartir archivos entre tus propios dispositivos en la misma red local. Lee los siguientes puntos antes de usar la aplicación.';

  @override
  String get privacy_policy_file_sharing_title => 'Solo compartimos archivos';

  @override
  String get privacy_policy_file_sharing_body =>
      'La aplicación se limita a transferir los archivos que tú decides enviar. No se envía nada en segundo plano ni se sube a ningún servidor.';

  @override
  String get privacy_policy_liability_title => 'Los riesgos de red siempre están presentes';

  @override
  String get privacy_policy_liability_body =>
      'Esta aplicación no modifica ni daña tus archivos. Sin embargo, como las transferencias dependen de tu red local, siempre existen ciertos riesgos que están fuera de nuestro control. Te recomendamos mantener tus propias copias de seguridad de los archivos importantes.';

  @override
  String get privacy_policy_free_title => 'Completamente gratis';

  @override
  String get privacy_policy_free_body =>
      'La aplicación es totalmente gratis. No hay compras, suscripciones ni anuncios.';

  @override
  String get privacy_policy_no_tracking_title => 'Sin seguimiento';

  @override
  String get privacy_policy_no_tracking_body =>
      'No recopilamos, rastreamos ni compartimos ningún dato personal, analítica ni información de uso.';

  @override
  String get privacy_policy_no_storage_title => 'No guardamos tus archivos';

  @override
  String get privacy_policy_no_storage_body =>
      'No almacenamos tus archivos. Las transferencias van directamente entre tus dispositivos en la red local; nosotros no conservamos ninguna copia.';
}
