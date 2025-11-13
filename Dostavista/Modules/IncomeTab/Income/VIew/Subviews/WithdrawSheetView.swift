//
//  WithdrawSheetView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI

struct WithdrawSheetView: View {
    @State private var amount: String = "3120"
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        content
            .padding(.horizontal)
            .padding(.bottom, 24)
            .background(Color.grayF8F6FF)
            .presentationCornerRadius(20)
            .alert("Сообщение", isPresented: $showAlert) {
                Button("ОК", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
    }
    
    private var content: some View {
        VStack(alignment: .center, spacing: .zero) {
            Capsule()
                .fill(Color.black.opacity(0.1))
                .frame(width: 80, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Вывод средств")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Обрабатываем заявки с 09:00 до 18:00 ежедневно")
                        .font(.system(size: 15))
                        .foregroundColor(.black.opacity(0.4))
                }
                .padding(.bottom)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: .zero) {
                Text("Сумма")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black.opacity(0.4))
                    .padding(.bottom, 8)
                
                VStack(alignment: .leading, spacing: .zero) {
                    HStack {
                        TextField("", text: $amount)
                            .font(.system(size: 24, weight: .semibold))
                            .keyboardType(.numberPad)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("₽")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.black.opacity(0.4))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.grayF2F2F2)
                    )
                    .padding(.bottom, 12)
                    
                    HStack(spacing: 6) {
                        ForEach(["1000₽", "2000₽", "3000"], id: \.self) { text in
                            Button {
                                amount = text.replacingOccurrences(of: "₽", with: "")
                            } label: {
                                Text(text)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.gray6B7280)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.grayF2F2F2)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 12)

                    Text("Доступно: 3,120 ₽ • Минимум: 1000 ₽")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray6B7280)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .stroke(Color.purple8B5CF6.opacity(0.12), lineWidth: 0.5)
            )
            .padding(.bottom, 20)

            HStack(alignment: .center, spacing: 12) {
                Image(.blueFlashIcon)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("Комиссия 0%. Средства поступят \nв течение 2 часов")
                    .font(.system(size: 13))
                    .foregroundStyle(.blue2B7FFF1A)
                
                Spacer(minLength: 0)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue2B7FFF1A.opacity(0.05))
                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
            )
            
            Spacer()
            
            Button {
                handleWithdraw()
            } label: {
                Text("Подать заявку")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(17)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.purple8B5CF6)
                    )
            }
            .buttonStyle(.plain)
        }
    }
    
    
    private func handleWithdraw() {
        let available = 3120
        let requested = Int(amount) ?? 0
        
        if requested > available {
            alertMessage = "Недостаточно средств"
        } else if requested < 1000 {
            alertMessage = "Минимальная сумма вывода — 1000 ₽"
        } else {
            alertMessage = "Ваш запрос находится в обработке"
        }
        showAlert = true
    }
}

#Preview {
    IncomeView(vm: IncomeViewModel())
}
