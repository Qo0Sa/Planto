//
//  splash.swift
//  Planto
//
//  Created by Sarah on 06/05/1447 AH.
//


import SwiftUI
import Combine

public struct Spalsh: View {
    @StateObject var plantData = PlantData() // مشترك بين الصفحات
    @State private var showAddSheet = false
    @State private var goToMain = false

    
    public var body: some View {
        ZStack {
            if goToMain {
                TodR()
                    .environmentObject(plantData) // نفس الـStateObject
            

            } else {
                VStack {
                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 164, height: 200)
                        .padding()
                    
                    Text("Start your plant journey!")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                    
                    Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 140)
                    
                    Button("Set Plant Reminder") {
                        showAddSheet = true
                    }
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 280, height: 42)
                    .background(Color(.cBoutt).opacity(0.85))
                    .cornerRadius(1000)
                }
                .sheet(isPresented: $showAddSheet) {
                    SeR(onDone: {
                        goToMain = true // بعد حفظ النبات، انتقل للصفحة الرئيسية
                    })
                    .environmentObject(plantData) // ← تمرير نفس الـPlantData
                    .presentationDetents([.large])
                    .presentationCornerRadius(30)
                    .presentationBackground(.clear)
                }



            }
        }
    }
}

#Preview {
    Spalsh()

}

