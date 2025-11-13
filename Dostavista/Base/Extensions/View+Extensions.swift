//
//  View+Extensions.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 07.11.2025.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

extension View {
    func safeTopPadding(_ value: CGFloat = 0) -> some View {
        self.modifier(SafeTopPaddingModifier(paddingTop: value))
    }
}

extension View {
    /// Открывает системное окно браузера  внутри приложения
    func safari(urlString: String?, isPresented: Binding<Bool>) -> some View {
        modifier(SafariModifier(isPresented: isPresented, urlString: urlString))
    }
    
    /// Открывает системное окно создания письма внутри приложения
    func mail(recipients: [String], subject: String, messageBody: String, isPresented: Binding<Bool>) -> some View {
        modifier(
            MailModifier(isPresented: isPresented, recipients: recipients, subject: subject, messageBody: messageBody)
        )
    }
}

extension View {
    /// Задает одинаковую ширину и высоту
    func size(_ value: CGFloat) -> some View {
        self.modifier(FixedSizeModifier(width: value, height: value))
    }
}
