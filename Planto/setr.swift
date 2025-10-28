//
//  setr.swift
//  Planto
//
//  Created by Sarah on 06/05/1447 AH.
//


import SwiftUI
import Combine

public struct SeR: View {
    @State private var plant = Plant(
        name: "",
        room: "Bedroom",
        light: "Full Sun",
        day: "Every day",
        water: "20-50 ml",
        isWatered: false

    )
    @State private var showSheet = true
    var onDone: () -> Void
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var plantData: PlantData
    
    let rooms = ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"]
    let lights = ["Full Sun", "Partial Sun", "Low light"]
    let day = ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    let water = ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"]

    public var body: some View {
        ZStack {
            // خلفية داكنة ناعمة
           // Color.lb.ignoresSafeArea()

            VStack {

                HStack {
                    Button(action: {
                        dismiss() }){
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .white.opacity(0.15), radius: 6, x: 0, y: 2)
                            .glassEffect(.clear)
                            

                    }
                    .padding(8)

                    Spacer()

                    Text("Set Reminder")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    // زر التأكيد (✅)
                    Button(action: {
                        // 1️⃣ إضافة النبات
                        plantData.plants.append(plant)
                        
                        // 2️⃣ استدعاء onDone
                        onDone()
                        
                        // 3️⃣ جدولة الإشعار بعد 40 ثانية
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            NotificationManager.shared.sendGeneralNotification()
                        }

                        
                        // 4️⃣ إغلاق الشاشة
                        dismiss()
                    }){
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.prog.opacity(0.4), lineWidth: 1)
                                    )
                                    .background(
                                        Circle().fill(Color.prog)
                                    )
                            )
                            .shadow(color: .prog.opacity(0.2), radius: 8, x: 0, y: 3)
                            .glassEffect(.clear)
                            .padding(8)

                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Divider().background(Color.white.opacity(0.3))

                // 🔹 حقل اسم النبات
                HStack {
                    Text("Plant Name:")
                        .foregroundColor(.white)
                        .font(.system(size: 17))

                    TextField("Pothos", text: $plant.name)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .tint(.green)
                }
                .padding()
                .frame(width: 388, height: 59)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .padding(.top, 50)

                // 🔹 Room + Light
                VStack(spacing: 0) {
                    HStack {
                        Label("Room", systemImage: "paperplane")
                            .foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $plant.room) {
                            ForEach(rooms, id: \.self) { room in
                                Text(room)
                                    .tag(room)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.gray)
                    }
                    .padding()
                    .frame(width: 388, height: 47)

                    Divider().background(Color.white.opacity(0.3))
                        .padding(.horizontal, 20)

                    HStack {
                        Label("Light", systemImage: "sun.max")
                            .foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $plant.light) {
                            ForEach(lights, id: \.self) { light in
                                Text(light)
                                    .tag(light)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.gray)
                    }
                    .padding()
                    .frame(width: 388, height: 47)
                }
                .frame(width: 388, height: 95)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .padding(.top, 40)

                // 🔹 Water + Days
                VStack(spacing: 0) {
                    HStack {
                        Label("Watering Days", systemImage: "drop")
                            .foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $plant.day) {
                            ForEach(day, id: \.self) { room in
                                Text(room)
                                    .tag(room)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.gray)
                    }
                    .padding()
                    .frame(width: 388, height: 47)

                    Divider().background(Color.white.opacity(0.3))
                        .padding(.horizontal, 20)

                    HStack {
                        Label("Water", systemImage: "drop")
                            .foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $plant.water) {
                            ForEach(water, id: \.self) { light in
                                Text(light)
                                    .tag(light)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.gray)
                      //  .labelsHidden()
                    }
                    .padding()
                    .frame(width: 388, height: 47)
                }
                .frame(width: 388, height: 95)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .padding(.top, 40)

                Spacer()
                
            }
        }
        
    }
}

struct Plant: Identifiable, Codable {
    var id = UUID()
    var name: String
    var room: String
    var light: String
    var day: String
    var water: String
    var isWatered: Bool
}

class PlantData: ObservableObject {
    @Published var plants: [Plant] = []
}




#Preview {
    SeR(onDone: { })
        .environmentObject(PlantData())
}

