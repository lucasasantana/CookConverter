// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum AppStrings {
  internal enum Common {
    /// ingredientes
    internal static let ingredients = AppStrings.tr("Common", "ingredients")
    /// medidas
    internal static let measures = AppStrings.tr("Common", "measures")
  }
  internal enum InfoPlist {
    /// Culiversor
    internal static let cfBundleDisplayName = AppStrings.tr("InfoPlist", "CFBundleDisplayName")
    /// Culiversor
    internal static let cfBundleName = AppStrings.tr("InfoPlist", "CFBundleName")
  }
  internal enum Products {
    /// alho
    internal static let alho = AppStrings.tr("Products", "alho")
    /// amendoim
    internal static let amendoim = AppStrings.tr("Products", "amendoim")
    /// amêndoas
    internal static let amêndoas = AppStrings.tr("Products", "amêndoas")
    /// arroz
    internal static let arroz = AppStrings.tr("Products", "arroz")
    /// aveia
    internal static let aveia = AppStrings.tr("Products", "aveia")
    /// azeitonas
    internal static let azeitonas = AppStrings.tr("Products", "azeitonas")
    /// açúcar
    internal static let açúcar = AppStrings.tr("Products", "açúcar")
    /// banha
    internal static let banha = AppStrings.tr("Products", "banha")
    /// café
    internal static let café = AppStrings.tr("Products", "café")
    /// canela
    internal static let canela = AppStrings.tr("Products", "canela")
    /// cebolas
    internal static let cebolas = AppStrings.tr("Products", "cebolas")
    /// cenoura
    internal static let cenoura = AppStrings.tr("Products", "cenoura")
    /// centeio
    internal static let centeio = AppStrings.tr("Products", "centeio")
    /// cevada
    internal static let cevada = AppStrings.tr("Products", "cevada")
    /// coco
    internal static let coco = AppStrings.tr("Products", "coco")
    /// creme
    internal static let creme = AppStrings.tr("Products", "creme")
    /// feijão
    internal static let feijão = AppStrings.tr("Products", "feijão")
    /// fermento
    internal static let fermento = AppStrings.tr("Products", "fermento")
    /// iogurte
    internal static let iogurte = AppStrings.tr("Products", "iogurte")
    /// leite
    internal static let leite = AppStrings.tr("Products", "leite")
    /// lentilhas
    internal static let lentilhas = AppStrings.tr("Products", "lentilhas")
    /// maionese
    internal static let maionese = AppStrings.tr("Products", "maionese")
    /// manteiga
    internal static let manteiga = AppStrings.tr("Products", "manteiga")
    /// milho
    internal static let milho = AppStrings.tr("Products", "milho")
    /// mostarda
    internal static let mostarda = AppStrings.tr("Products", "mostarda")
    /// nozes
    internal static let nozes = AppStrings.tr("Products", "nozes")
    /// ovo
    internal static let ovo = AppStrings.tr("Products", "ovo")
    /// pistache
    internal static let pistache = AppStrings.tr("Products", "pistache")
    /// queijo
    internal static let queijo = AppStrings.tr("Products", "queijo")
    /// sal
    internal static let sal = AppStrings.tr("Products", "sal")
    /// semolina
    internal static let semolina = AppStrings.tr("Products", "semolina")
    /// soja
    internal static let soja = AppStrings.tr("Products", "soja")
    /// suplemento
    internal static let suplemento = AppStrings.tr("Products", "suplemento")
    /// trigo
    internal static let trigo = AppStrings.tr("Products", "trigo")
    /// água
    internal static let água = AppStrings.tr("Products", "água")
    /// óleo
    internal static let óleo = AppStrings.tr("Products", "óleo")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension AppStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
