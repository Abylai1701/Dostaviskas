//
//  OrderCardActiveView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 10.11.2025.
//

import SwiftUI

struct OrderCardActiveView: View {
    
    let data: FullOrder
    var onChat: () -> Void

    @Environment(\.openURL) private var openURL

    private func callPhone(_ raw: String) {
        let allowed = Set("+0123456789")
        let cleaned = raw.filter { allowed.contains($0) }
        guard let url = URL(string: "tel://\(cleaned)") else { return }
        openURL(url)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .zero) {
                HStack(alignment: .center) {
                    Text(data.order_number)
                        .font(.system(size: 13))
                        .foregroundStyle(.gray6B7280)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
                
                HStack(alignment: .center, spacing: 16) {
                    Text("\(Int(data.price_usd)) ₽")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.purple8B5CF6)
                    
                    HStack(alignment: .center, spacing: 2) {
                        Image(.purpleFlashMiniIcon)
                            .resizable()
                            .frame(width: 14, height: 14)
                        
                        Text("+80₽")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.purple8B5CF6)
                    }
                    .padding(.horizontal, 8.5)
                    .padding(.vertical, 5.5)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(.purple8B5CF6.opacity(0.1))
                    )
                    
                    Spacer()
                    
                    Pill(
                        text: OrderTag.urgent.title,
                        foreground: OrderTag.urgent.foreground,
                        background: OrderTag.urgent.background,
                        forMain: false
                    )
                }
                .padding(.bottom, 24)

                HStack(alignment: .top, spacing: 12) {
                    Image(.ordersGeoPinIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        Text("Доставляете к:")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray6B7280)
                            .padding(.bottom , 4)
                        
                        Text(data.toStreet)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.black)
                            .padding(.bottom , 6)
                        
                        HStack(alignment: .center, spacing: 16) {
                            HStack(alignment: .center, spacing: 6) {
                                Image(.purpleMiniCompassIcon)
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                
                                Text("\(String(format: "%.1f", data.distance_km)) км")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(.purple8B5CF6)
                            }
                            
                            HStack(alignment: .center, spacing: 6) {
                                Image(.purpleMiniClockIcon)
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                
                                Text("\(data.delivery_minutes) мин")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(.purple8B5CF6)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [.whiteF5F3FF, .whiteF5F3FF.opacity(0.5)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .strokeBorder(.purple8B5CF6.opacity(0.2), lineWidth: 1)
                )
                .padding(.bottom, 24)

                HStack(alignment: .center, spacing: 12) {
                    VStack(alignment: .center, spacing: 12) {
                        Image(.purpleBigAddressTag)
                            .resizable()
                            .frame(width: 33, height: 33)
                        
                        Rectangle()
                            .fill(.purple8B5CF6.opacity(0.1))
                            .frame(width: 2, height: 20)
                        
                        Image(.redBigAddressTag)
                            .resizable()
                            .frame(width: 33, height: 33)
                    }
                    
                    VStack(alignment: .leading, spacing: .zero) {
                        VStack(alignment: .leading, spacing: .zero) {
                            
                            Text("Откуда")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            Text(data.from_address)
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.4))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: .zero) {
                            
                            Text("Куда")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            Text(data.to_address)
                                .font(.system(size: 15))
                                .foregroundStyle(.black.opacity(0.4))
                        }
                    }
                    .frame(maxHeight: 113)
                    
                    Spacer()
                }
                .padding(.bottom, 24)

                HStack(spacing: 12) {
                    Button {
                        callPhone(data.sender_phone)
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.grayF2F2F2)
                            .frame(height: 44)
                            .overlay {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(.phoneMiniIcon)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .offset(y: 1)
                                    Text("Позвонить")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.black)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        onChat()
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.grayF2F2F2)
                            .frame(height: 44)
                            .overlay {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(.chatMiniIcon)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("Чат")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.black)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
                
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .strokeBorder(.black.opacity(0.1), lineWidth: 1)
                .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
        )
    }
}
