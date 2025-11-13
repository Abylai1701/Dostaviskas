//
//  ChatView.swift
//  Dostavista
//
//  Created by Abylaikhan Abilkayr on 12.11.2025.
//

import SwiftUI

struct ChatView: View {
    
    @State var vm: ChatViewModel
    
    let order: FullOrder
    
    init(router: MainRouter, order: FullOrder) {
        let coordinator = MainChatCoordinator(router: router)
        _vm = State(initialValue: ChatViewModel(coordinator: coordinator))
        
        self.order = order
    }
    
    init(routerForOrders: OrdersRouter, order: FullOrder) {
        let coordinator = OrdersChatCoordinator(router: routerForOrders)
        _vm = State(initialValue: ChatViewModel(coordinator: coordinator))
        
        self.order = order
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(edges: .top)
            
            VStack(spacing: .zero) {
                header

                messagesList
                
                bottomButton
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .hideKeyboardOnTap()
        .onAppear {
            Task {
                await vm.startChat(email: "ukulesova277@gmail.com")
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: .zero) {
            HStack {
                Button {
                    vm.pop()
                } label: {
                    Image(.backIcon)
                        .resizable()
                        .frame(width: 20, height: 16)
                        .padding(16)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .overlay {
                Text("Детали заказа")
                    .font(.system(size: 17.fitW, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .padding(.bottom, 8)
            
            Divider()
                .background(.black.opacity(0.1))
            
            HStack(alignment: .center, spacing: 12) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple8B5CF6, .purple6D3ED6],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .size(40)
                    .overlay {
                        Text("\(order.sender_name.first ?? "A")")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                
                VStack(alignment: .leading, spacing: .zero) {
                    Text(order.sender_name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                    Text(order.order_number)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.gray6B7280)
                }
                
                Spacer()
                
                Button {
                    callClient(order.sender_phone)
                } label: {
                    Image(.purpleCallIcon)
                        .resizable()
                        .size(40)
                }

            }
            .padding()
            Divider()
                .background(.black.opacity(0.1))
        }
    }
    
    @State private var scrollProxy: ScrollViewProxy?
    
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    ForEach(vm.messages) { msg in
                        MessageRow(message: msg, retryAction: {
                            Task { await vm.retrySend(message: msg) }
                        })
                        .id(msg.id)
                        .padding(.horizontal, 12)
                        .padding(.top, 4)
                    }
                }
                .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
            .background(.grayF2F2F2)
            .onAppear { scrollProxy = proxy }
            .onChange(of: vm.messages.count) { _ in
                if let last = vm.messages.last?.id {
                    withAnimation { proxy.scrollTo(last, anchor: .bottom) }
                }
            }
        }
    }
    
    private var bottomButton: some View {
        VStack(alignment: .center, spacing: .zero) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(messageHints, id: \.self) { hint in
                        Button {
                            vm.text = hint
                        } label: {
                            Text(hint)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 120)
                                        .fill(.white)
                                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 4)

            HStack(alignment: .center, spacing: 8) {
                TextField("Сообщение...", text: $vm.text)
                    .font(.system(size: 15))
                    .foregroundStyle(.black)
                    .frame(height: 44)
                    .padding(.horizontal, 16.fitW)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.grayF2F2F2)
                            .strokeBorder(Color.black.opacity(0.1), lineWidth: 1)
                    )
                
                Button {
                    Task {
                        await vm.sendMessage()
                    }
                } label: {
                    Image(vm.text == "" ? .sendIcon : .purpleSendIcon)
                        .resizable()
                        .size(44)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 10.fitH)
        .background(.whiteF8F6FF)
    }
    
    private let messageHints = [
        "Уже еду 🚗",
        "Буду через 5 минут",
        "Прибыл на место",
        "Забрал заказ",
        "Доставил ✅"
    ]

    private func callClient(_ raw: String) {
        let allowed = Set("+0123456789")
        let cleaned = raw.filter { allowed.contains($0) }
        guard let url = URL(string: "tel://\(cleaned)") else { return }
        UIApplication.shared.open(url)
    }
}


private struct MessageRow: View {
    let message: Message
    let retryAction: () -> Void
    
    var isMine: Bool { message.sender == .user }
    
    var body: some View {
        HStack {
            if isMine { Spacer(minLength: 40) }
            VStack(alignment: isMine ? .trailing : .leading, spacing: 4) {
                Text(message.body)
                    .font(.system(size: 15))
                    .foregroundStyle(isMine ? .white : .black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isMine ? Color.purple6D3ED6 : Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.black.opacity(isMine ? 0 : 0.08), lineWidth: 1)
                            )
                    )
                
                // Статус: отправляется / отправлено / ошибка
                HStack(spacing: 6) {
                    switch message.status {
                    case .sending:
                        ProgressView().scaleEffect(0.8)
                    case .sent:
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.gray)
                    case .failed:
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.red)
                                .font(.system(size: 12, weight: .bold))
                            Button("Повторить") { retryAction() }
                                .font(.system(size: 12, weight: .semibold))
                        }
                    }
                }
                .opacity(isMine ? 1 : 0) // статус показываем только для своих
            }
            if !isMine { Spacer(minLength: 40) }
        }
    }
}
