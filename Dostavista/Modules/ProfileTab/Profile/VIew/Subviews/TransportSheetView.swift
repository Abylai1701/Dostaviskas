//
//  TransportSheetView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 11.11.2025.
//

import SwiftUI

struct TransportSheetView: View {
    
    enum TransportType: String, CaseIterable, Identifiable {
        case walk = "Пешком"
        case bike = "Велосипед"
        case scooter = "Самокат"
        case car = "Автомобиль"
        
        var id: String { rawValue }
        
        var emoji: String {
            switch self {
            case .walk: return "🚶‍♂️"
            case .bike: return "🚴‍♂️"
            case .scooter: return "🛴"
            case .car: return "🚗"
            }
        }
    }
    
    @AppStorage("selectedTransportTypes") private var savedTransportRaw: String = ""
    @Environment(\.dismiss) private var dismiss

    @State private var selectedTypes: Set<TransportType> = []

    var body: some View {
        content
            .padding(.horizontal)
            .padding(.bottom, 24)
            .background(Color.grayF8F6FF)
            .presentationCornerRadius(20)
            .onAppear {
                selectedTypes = Set(savedTransportRaw
                    .split(separator: ",")
                    .compactMap { TransportType(rawValue: String($0)) })
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
                    Text("Тип транспорта")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Выберите доступные варианты")
                        .font(.system(size: 15))
                        .foregroundColor(.black.opacity(0.4))
                }
                .padding(.bottom)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(TransportType.allCases) { type in
                    TransportCell(
                        type: type,
                        isSelected: selectedTypes.contains(type)
                    ) {
                        toggleSelection(for: type)
                    }
                }
            }
            
            Spacer()
            
            Button {
                saveSelection()
                dismiss()
            } label: {
                Text("Сохранить")
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
    
    // MARK: - Selection logic
    private func toggleSelection(for type: TransportType) {
        if selectedTypes.contains(type) {
            selectedTypes.remove(type)
        } else {
            selectedTypes.insert(type)
        }
    }
    private func saveSelection() {
        let joined = selectedTypes.map(\.rawValue).joined(separator: ",")
        savedTransportRaw = joined
    }
}


// MARK: - Cell View
private struct TransportCell: View {
    let type: TransportSheetView.TransportType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.purple8B5CF6 : Color.grayF2F2F2)
                        .frame(width: 48, height: 48)
                    Text(type.emoji)
                        .font(.system(size: 28))
                }
                
                Text(type.rawValue)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.purple8B5CF6.opacity(0.1) : .white)
                    .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(duration: 0.15), value: isSelected)
    }
}

#Preview {
    TransportSheetView()
}
