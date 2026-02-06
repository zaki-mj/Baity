// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Baity';

  @override
  String get welcomeText => 'Bienvenue sur Baity';

  @override
  String get exploreButton => 'Commencer l\'exploration';

  @override
  String get slogan => 'Trouvez votre prochaine aventure dans les maisons et camps de jeunesse !';

  @override
  String get adminLogin => 'Connexion administrateur';

  @override
  String get tabAll => 'Tout';

  @override
  String get tabYouthHouses => 'Auberge de jeunesse';

  @override
  String get tabYouthCamps => 'Camps de jeunesse';

  @override
  String get detailsTitle => 'Détails';

  @override
  String get availableSpots => 'Places disponibles';

  @override
  String get description => 'Description';

  @override
  String get loginTitle => 'Connexion administrateur';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get editData => 'Modifier les données';

  @override
  String get settings => 'Paramètres';

  @override
  String get switchLanguage => 'Changer de langue';

  @override
  String get detailsContact => 'Contact';

  @override
  String get detailsPhone => 'Téléphone';

  @override
  String get detailsEmail => 'Email';

  @override
  String get detailsSocial => 'Réseaux sociaux';

  @override
  String get detailsMap => 'Voir sur Google Maps';

  @override
  String get detailsSpots => 'Places disponibles';

  @override
  String get detailsDescription => 'Un bel endroit pour que les jeunes séjournent et se connectent.';

  @override
  String get detailsFacebook => 'Facebook';

  @override
  String get detailsInstagram => 'Instagram';

  @override
  String get detailsTwitter => 'Twitter';

  @override
  String get detailsAddress => 'Adresse';

  @override
  String get about => 'À propos';

  @override
  String get aboutTitle => 'À propos de Baity';

  @override
  String get aboutDescription => 'Baity est une application mobile conçue pour aider les jeunes à découvrir et explorer les maisons et camps de jeunesse à travers l\'Algérie. Notre plateforme fournit des informations détaillées sur diverses installations de jeunesse, y compris les emplacements, les places disponibles, les informations de contact et les liens vers les réseaux sociaux.';

  @override
  String get technicalDetails => 'Détails techniques';

  @override
  String get appVersion => 'Version de l\'application';

  @override
  String get versionNumber => '1.0.0';

  @override
  String get developedWith => 'Développé avec';

  @override
  String get credits => 'Crédits';

  @override
  String get ideaBy => 'Idée de';

  @override
  String get developedBy => 'Développé par';

  @override
  String get medjdoubHadjirat => 'Medjdoub Hadjirat';

  @override
  String get medjdoubZakaria => 'Medjdoub Zakaria';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get cancel => 'Annuler';

  @override
  String get editYouthHouse => 'Modifier la maison de jeunesse';

  @override
  String get addNewYouthHouse => 'Ajouter une nouvelle maison de jeunesse';

  @override
  String get updateYouthHouseInfo => 'Mettre à jour les informations de la maison de jeunesse';

  @override
  String get createNewYouthHouse => 'Créer une nouvelle maison ou camp de jeunesse';

  @override
  String get basicInformation => 'Informations de base';

  @override
  String get contactInformation => 'Informations de contact';

  @override
  String get socialMedia => 'Réseaux sociaux';

  @override
  String get nameArabic => 'الاسم بالعربية';

  @override
  String get nameLatin => 'Nom en Latin';

  @override
  String get location => 'Emplacement';

  @override
  String get imageUrl => 'URL de l\'image';

  @override
  String get type => 'Type';

  @override
  String get phone => 'Téléphone';

  @override
  String get email => 'Email';

  @override
  String get address => 'Adresse';

  @override
  String get facebookUrl => 'URL Facebook';

  @override
  String get instagramUrl => 'URL Instagram';

  @override
  String get twitterUrl => 'URL Twitter';

  @override
  String get pleaseEnterName => 'Veuillez entrer un nom';

  @override
  String get pleaseEnterLocation => 'Veuillez entrer un emplacement';

  @override
  String get pleaseEnterImageUrl => 'Veuillez entrer une URL d\'image';

  @override
  String get update => 'Mettre à jour';

  @override
  String get save => 'Enregistrer';

  @override
  String get youthHouseUpdated => 'Maison de jeunesse mise à jour avec succès !';

  @override
  String get youthHouseAdded => 'Maison de jeunesse ajoutée avec succès !';

  @override
  String get deleteConfirmation => 'Êtes-vous sûr de vouloir supprimer cette maison de jeunesse ? Cette action ne peut pas être annulée.';

  @override
  String get delete => 'Supprimer';

  @override
  String get deletedSuccessfully => 'Supprimé avec succès';

  @override
  String get manageYouthHouses => 'Gérer les maisons et camps de jeunesse';

  @override
  String locationsManaged(Object count) {
    return '$count emplacements gérés';
  }

  @override
  String get errorEnterEmail => 'Veuillez entrer votre email';

  @override
  String get errorValidEmail => 'Veuillez entrer un email valide';

  @override
  String get errorEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get errorPasswordLength => 'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String loggedInAs(Object email) {
    return 'Connecté en tant que : $email';
  }

  @override
  String get logout => 'Se déconnecter';

  @override
  String get errorNetwork => 'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String get errorWrongCredentials => 'Email ou mot de passe incorrect.';

  @override
  String get errorUnknown => 'Une erreur inconnue s\'est produite. Veuillez réessayer.';

  @override
  String get state => 'Wilaya';

  @override
  String get city => 'Commune';

  @override
  String get adminInterface => 'Interface Des Administrateurs';

  @override
  String get explore => 'Explorer';

  @override
  String get numberofinstitution => 'Nombre d\'établissement';

  @override
  String get errorNotFound => 'Aucune donnée n\'a été trouvée';

  @override
  String get add => 'Ajouter';

  @override
  String get facebookLinkNotAvailable => 'Lien Facebook non disponible';

  @override
  String get instagramLinkNotAvailable => 'Lien Instagram non disponible';

  @override
  String get twitterLinkNotAvailable => 'Lien TikTok non disponible';

  @override
  String get contribute => 'Contribuer';

  @override
  String get contributeTitle => 'Contribuer';

  @override
  String get contributeDescription => 'Notre application ne peut grandir qu\'avec la contribution des maisons de jeunes à travers le pays. Pour nous aider et ajouter votre propre établissement, veuillez envoyer les détails suivants à l\'adresse e-mail ci-dessous.';

  @override
  String get contributeDetails => 'Détails requis : Nom de l\'établissement, emplacement Google Maps, informations de contact et liens de médias sociaux.';

  @override
  String get contributeEmail => 'zakariamedjdoub.dev@gmail.com';

  @override
  String get contributeButton => 'Envoyer un e-mail';

  @override
  String get publisher => 'Éditeur';

  @override
  String get jawalAssociation => 'Association Jawal pour les activités de jeunesse';
}
