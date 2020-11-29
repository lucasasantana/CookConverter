// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum Rubik {
    internal static let black = FontConvertible(name: "Rubik-Black", family: "Rubik", path: "Rubik-Black.ttf")
    internal static let blackItalic = FontConvertible(name: "Rubik-BlackItalic", family: "Rubik", path: "Rubik-BlackItalic.ttf")
    internal static let bold = FontConvertible(name: "Rubik-Bold", family: "Rubik", path: "Rubik-Bold.ttf")
    internal static let boldItalic = FontConvertible(name: "Rubik-BoldItalic", family: "Rubik", path: "Rubik-BoldItalic.ttf")
    internal static let extraBold = FontConvertible(name: "Rubik-ExtraBold", family: "Rubik", path: "Rubik-ExtraBold.ttf")
    internal static let extraBoldItalic = FontConvertible(name: "Rubik-ExtraBoldItalic", family: "Rubik", path: "Rubik-ExtraBoldItalic.ttf")
    internal static let italic = FontConvertible(name: "Rubik-Italic", family: "Rubik", path: "Rubik-Italic.ttf")
    internal static let light = FontConvertible(name: "Rubik-Light", family: "Rubik", path: "Rubik-Light.ttf")
    internal static let lightItalic = FontConvertible(name: "Rubik-LightItalic", family: "Rubik", path: "Rubik-LightItalic.ttf")
    internal static let medium = FontConvertible(name: "Rubik-Medium", family: "Rubik", path: "Rubik-Medium.ttf")
    internal static let mediumItalic = FontConvertible(name: "Rubik-MediumItalic", family: "Rubik", path: "Rubik-MediumItalic.ttf")
    internal static let regular = FontConvertible(name: "Rubik-Regular", family: "Rubik", path: "Rubik-Regular.ttf")
    internal static let semiBold = FontConvertible(name: "Rubik-SemiBold", family: "Rubik", path: "Rubik-SemiBold.ttf")
    internal static let semiBoldItalic = FontConvertible(name: "Rubik-SemiBoldItalic", family: "Rubik", path: "Rubik-SemiBoldItalic.ttf")
    internal static let all: [FontConvertible] = [black, blackItalic, bold, boldItalic, extraBold, extraBoldItalic, italic, light, lightItalic, medium, mediumItalic, regular, semiBold, semiBoldItalic]
  }
  internal static let allCustomFonts: [FontConvertible] = [Rubik.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(OSX)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
