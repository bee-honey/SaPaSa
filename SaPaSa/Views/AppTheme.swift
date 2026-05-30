import SwiftUI

enum AppTheme {
    static let background = Color(hex: 0xFFF7EA)
    static let surface = Color(hex: 0xFFFFFA)
    static let surfaceMuted = Color(hex: 0xF4E6CD)
    static let primary = Color(hex: 0x8F1D2C)
    static let primarySoft = Color(hex: 0xF1D4D1)
    static let gold = Color(hex: 0xC88A1D)
    static let green = Color(hex: 0x346D4B)
    static let blue = Color(hex: 0x315D7E)
    static let ink = Color(hex: 0x2A211B)
    static let mutedInk = Color(hex: 0x7D6F62)

    static let gradient = LinearGradient(
        colors: [Color(hex: 0x8F1D2C), Color(hex: 0xC88A1D)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    init(hex: UInt, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

extension View {
    func sapasaCard() -> some View {
        padding(16)
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .shadow(color: AppTheme.ink.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
