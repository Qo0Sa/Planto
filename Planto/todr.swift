//
//  todr.swift
//  Planto
//
//  Created by Sarah on 06/05/1447 AH.
//


import SwiftUI
import Combine


public struct TodR: View {
    @State private var showAddSheet = false
    @EnvironmentObject var plantData: PlantData // ← النسخة المشتركة
    @State private var goToMain = false
    @State private var selectedPlant: Plant? = nil
    
    
    public var body: some View {
        ZStack {
            
            
            
            VStack(spacing: 20) {
                HStack {
                    Text("My Plants 🌱")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.leading, 10)
                    Spacer()
                }
                
                
                // 👇 باقي المحتوى في المنتصف
                VStack(spacing: 20) {
                    let total = plantData.plants.count
                    let completed = plantData.plants.filter { $0.isWatered }.count
                    let progress = total > 0 ? CGFloat(completed) / CGFloat(total) : 0
                    
                        Divider()
                            .background(Color.gre.opacity(0.9))
                            .frame(height: 1)

                            .frame(maxWidth: .infinity) // ← يوسع الـ Divider لكل العرض


                    if completed == 0 {
                        Text("Your plants are waiting for a sip 💦")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else {
                        Text("\(completed) of your plants feel loved today ✨")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    //progress
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)
                        
                        // لاحقًا: هذا الجزء يتغير مع التقدم
                        Rectangle()
                            .fill(Color.prog)
                            .frame(width: 361 * progress, height: 6) // ← النسبة المتغيرة
                            .animation(.easeInOut, value: progress)
                        
                    }
                    .frame(width: 361, height: 8)
                    .cornerRadius(3)
                    
                }
                
                
                
 ZStack(alignment: .bottomTrailing) {
                    let total = plantData.plants.count
                    let completed = plantData.plants.filter { $0.isWatered }.count

     if total > 0 && completed == total {
         VStack {
             Spacer() // 🔹 يرفع المحتوى إلى منتصف الشاشة
             
             Image("splash")
                 .resizable()
                 .scaledToFit()
                .frame(width: 154 , height: 190)
             
             Text("All Done! 🎉")
                 .font(.system(size: 25, weight: .semibold))
                 .foregroundColor(.white)
                 .multilineTextAlignment(.center)
                 .padding(.top, 8)
             
             Text("All Reminders Completed")
                 .font(.system(size: 16, weight: .regular))
                 .foregroundColor(.gray)
                 .multilineTextAlignment(.center)
                 .padding(.top, 2)
             
             Spacer() // 🔹 يخليها فعلاً بالنص تمامًا
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity) // ← يضمن إنها تاخذ كل الشاشة
         .transition(.opacity.combined(with: .scale))
         .animation(.easeInOut, value: completed)
     }
 else {
                        List {
                            ForEach(plantData.plants) { plant in
                                PlantCard(plantData: plantData, plant: plant)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            if let index = plantData.plants.firstIndex(where: { $0.id == plant.id }) {
                                                plantData.plants.remove(at: index)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .onTapGesture {
                                        selectedPlant = plant
                                    }
                                    .listRowBackground(Color.black)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                        .listStyle(PlainListStyle())
                        .transition(.opacity)
                    }

                    // زر الإضافة يظل موجود دائمًا
                    Button(action: { showAddSheet = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(Circle().stroke(Color.prog.opacity(0.4), lineWidth: 1))
                                    .background(Circle().fill(Color.prog))
                            )
                            .shadow(color: .prog.opacity(0.2), radius: 8, x: 0, y: 3)
                            .glassEffect(.clear)
                            .padding(.bottom, 25)
                            .padding(.trailing, 21)
                    }
                }

                
                
                
                
                .sheet(isPresented: $showAddSheet) {
                    SeR(onDone: {
                        goToMain = true  // عند الحفظ ينتقل للصفحة الرئيسية
                    })
                    .presentationDetents([.large])
                    .presentationCornerRadius(30)
                    .presentationBackground(.clear)
                    .environmentObject(plantData)
                }
                
                
                .sheet(item: $selectedPlant) { plant in
                    SeRd(plant: plant, onDone: {
                        selectedPlant = nil
                    })
                    .presentationDetents([.large])
                    .presentationCornerRadius(30)
                    .presentationBackground(.clear)
                    .environmentObject(plantData)
                }
                
                
                
            }
            
        }
            
        
        
    }}
struct PlantCard: View {
    @ObservedObject var plantData: PlantData
    let plant: Plant
    var onCardTap: (() -> Void)? // ← closure عند الضغط على الكارد


    var body: some View {
        VStack(spacing: 0) {
            HStack  {
                Button(action: {
                    if let index = plantData.plants.firstIndex(where: { $0.id == plant.id }) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            plantData.plants[index].isWatered.toggle()
                        }
                    }
                }) {
                    Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.system(size: 22))
                        .foregroundColor(plant.isWatered ? .prog : .gray)
                }
                .offset(x: -10) // ← يحرك التشيك مارك 4 نقاط يسار

                VStack(alignment: .leading, spacing: 6) {
                    Label {
                        Text(plant.room)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.gray.opacity(0.7))
                    } icon: {
                        Image(systemName: "paperplane")
                            .foregroundColor(.gray.opacity(0.7))
                    }

                    Text(plant.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "sun.max")
                                .foregroundColor(.ye)
                                .font(.system(size: 12))
                            Text(plant.light)
                                .font(.system(size: 12))
                                .foregroundColor(.ye)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())

                        HStack(spacing: 4) {
                            Image(systemName: "drop")
                                .foregroundColor(.bl)
                                .font(.system(size: 12))
                            Text(plant.water)
                                .font(.system(size: 12))
                                .foregroundColor(.bl)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
    }
}




#Preview {
    TodR()
        .environmentObject(PlantData())
}
