// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  internal enum LaunchScreen {
  }
  internal enum Localizable {
    /// clear-day
    internal static let clearday = L10n.tr("Localizable", "clearday")
    /// clear-night
    internal static let clearnight = L10n.tr("Localizable", "clearnight")
    /// cloudy
    internal static let cloudy = L10n.tr("Localizable", "cloudy")
    /// Conversions en
    internal static let convert = L10n.tr("Localizable", "convert")
    /// Erreur
    internal static let error = L10n.tr("Localizable", "error")
    /// Malheureusement une erreur c'est produite
    internal static let errorfound = L10n.tr("Localizable", "errorfound")
    /// fog
    internal static let fog = L10n.tr("Localizable", "fog")
    /// Geolocalisation indisponible...
    internal static let geolocationerror = L10n.tr("Localizable", "geolocationerror")
    /// hail
    internal static let hail = L10n.tr("Localizable", "hail")
    /// HeaderCell
    internal static let headercell = L10n.tr("Localizable", "headercell")
    /// Le texte à traduire est manquant.
    internal static let missingtext = L10n.tr("Localizable", "missingtext")
    /// partly-cloudy-day
    internal static let partlycloudyday = L10n.tr("Localizable", "partlycloudyday")
    /// partly-cloudy-night
    internal static let partlycloudynight = L10n.tr("Localizable", "partlycloudynight")
    /// rain
    internal static let rain = L10n.tr("Localizable", "rain")
    /// Taux de change indisponible pour le moment...
    internal static let rateunknown = L10n.tr("Localizable", "rateunknown")
    /// Recherche...
    internal static let search = L10n.tr("Localizable", "search")
    /// sleet
    internal static let sleet = L10n.tr("Localizable", "sleet")
    /// snow
    internal static let snow = L10n.tr("Localizable", "snow")
    /// thunderstorm
    internal static let thunderstorm = L10n.tr("Localizable", "thunderstorm")
    /// Aujourd'hui
    internal static let today = L10n.tr("Localizable", "today")
    /// tornado
    internal static let tornado = L10n.tr("Localizable", "tornado")
    /// Localisation inconnue...
    internal static let unknownlocation = L10n.tr("Localizable", "unknownlocation")
    /// WeatherCell
    internal static let weathercell = L10n.tr("Localizable", "weathercell")
    /// Météo indisponible pour le moment...
    internal static let weatherunknown = L10n.tr("Localizable", "weatherunknown")
    /// wind
    internal static let wind = L10n.tr("Localizable", "wind")
  }
  internal enum Main {
    internal enum HspGC9o0 {
      /// Item
      internal static let title = L10n.tr("Main", "Hsp-GC-9o0.title")
    }
    internal enum NaE8iFgt {
      /// Item
      internal static let title = L10n.tr("Main", "NaE-8i-Fgt.title")
    }
    internal enum TvcClAMg {
      /// Item
      internal static let title = L10n.tr("Main", "Tvc-cl-AMg.title")
    }
    internal enum ToiSw4bR {
      /// Item
      internal static let title = L10n.tr("Main", "toi-sw-4bR.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
