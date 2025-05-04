//
//  DemoLoadingView.swift
//  UniStep
//
//  Created by Akberen on 29.04.2025.
//
//
//
//  DemoLoadingView.swift
//  AdmissionsFinal
//
//  Created by Akberen on 28.04.2025.
//


import SwiftUI

struct DemoLoadingView: View {
    @State private var rotation: Double = 0
    @State private var navigateToHome: Bool = false  // To trigger navigation
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 4)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(rotation))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotation)
                
//                Text("loading")
//                    .multilineTextAlignment(.center)
//                    .bold()
//                    .foregroundColor(.red)
//                    .opacity(0.3)
                    
                    
            }
            .compositingGroup()
            .frame(width: 60)
            .onAppear {
                self.rotation = 360
                // After 4 seconds, change to DemoHomeView
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigateToHome = true
                }
            }

            // Navigation to DemoHomeView after loading
            NavigationLink(
                destination: DemoHomeView(),  // The next screen
                isActive: $navigateToHome,  // Triggered when isLoading is false
                label: { EmptyView() }  // Invisible link to transition
            )
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DemoLoadingView()
}
//
//
//import SwiftUI
//
//struct DemoLoadingView: View {
//    @State private var start = false
//
//    var body: some View {
//        ZStack {
//            // Тень или фон текста
//            Text("Загрузка...")
//                .font(.largeTitle.bold())
//                .foregroundStyle(.red.opacity(0.3))
//
//            // Основной текст с маской
//            Text("Загрузка...")
//                .font(.largeTitle.bold())
//                .foregroundStyle(.red)
//                .frame(width: 220, height: 60)
//                .background(Color.white)
//                .mask {
//                    Circle()
//                        .frame(width: 60, height: 60)
//                        .offset(x: start ? 60 : -60)
//                }
//        }
//        .onAppear {
//            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
//                start = true
//            }
//        }
//    }
//}
//
//struct UniStepLoadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        DemoLoadingView()
//    }
//}
