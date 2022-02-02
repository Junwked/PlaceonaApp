//
//  PlaceonaView.swift
//  PlaceonaApp
//
//  Created by 池上 潤 
//

import SwiftUI

struct PlaceonaView: View { //Placeona管理画面 
    
    @EnvironmentObject var puis: PlaceonaUISystem
    
    var body: some View {
        
        VStack{
            
            HStack{
                
                Text("Placeona")
                    .font(.title)
                    .padding()
                
                Button(action: { //?ボタン
                    puis.placeonaViewQButton()
                }){
                    Image("qmark")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                
                Button(action: { //再生(停止)ボタン -> センサのON/OFF
                    puis.SensorSwitch()
                }){
                    if puis.Sensor {
                        Image("stopButton")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 25, height: 25)
                    }else {
                        Image("startButton")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .sheet(isPresented: $puis.placeonaViewModal) {//Modalの中身
                    
                    VStack{
                        Group{
                            Text("目")
                                .font(.title3)
                                .padding()
                            Text("○: デバイスを集中して見ることができる")
                                .frame(maxWidth: 310, alignment: .leading)
                            Text("×: デバイスを集中して見ることができない")
                                .frame(maxWidth: 310, alignment: .leading)
                            
                            Text("手")
                                .font(.title3)
                                .padding()
                            Text("○: 手で操作することができる")
                                .frame(maxWidth: 250, alignment: .leading)
                            Text("▲: 手で持つことができる")
                                .frame(maxWidth: 250, alignment: .leading)
                            Text("×: 手を使用することができない")
                                .frame(maxWidth: 250, alignment: .leading)
                            
                        }
                        Group{
                            Text("耳")
                                .font(.title3)
                                .padding()
                            Text("○: 聞くことができる")
                                .frame(maxWidth: 170, alignment: .leading)
                            Text("×: 聞くことができない")
                                .frame(maxWidth: 170, alignment: .leading)
                            
                            Text("口")
                                .font(.title3)
                                .padding()
                            Text("○: 話すことができる")
                                .frame(maxWidth: 170, alignment: .leading)
                            Text("×: 話すことができない")
                                .frame(maxWidth: 170, alignment: .leading)
                        }

                        Button(action: {
                            puis.placeonaViewModalCloseButton()
                        }){
                            Text("  閉じる  ")
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                                .background(Color(UIColor(red: 0, green: 0.5, blue: 0.0, alpha: 0.6)))
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
                Spacer()
                
                Text("now: ")
                Text(puis.interactionstyle.rawValue)
                    .padding(.trailing, 15)
                
            }

            HStack{
                Text("Eyes: ")
                Picker("", selection: Binding($puis.Placeona["Eyes"])!) {
                            Text("○")
                                .tag(0)
                            Text("×")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            HStack{
                Text("Hands: ")
                Picker("", selection: Binding($puis.Placeona["Hands"])!) {
                            Text("○")
                                .tag(0)
                            Text("▲")
                                .tag(1)
                            Text("×")
                                .tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            HStack{
                Text("Ears: ")
                Picker("", selection: Binding($puis.Placeona["Ears"])!) {
                            Text("○")
                                .tag(0)
                            Text("×")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            HStack{
                Text("Mouth: ")
                Picker("", selection: Binding($puis.Placeona["Mouth"])!) {
                            Text("○")
                                .tag(0)
                            Text("×")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            
            Group{
                
                HStack{
                    Text("Latitude: ")
                        .font(.caption)
                    Text(puis.latitude)
                        .font(.caption)
                    Spacer()
                }
                .frame(maxWidth: 300, alignment: .leading)
                
                HStack{
                    Text("Longitude: ")
                        .font(.caption)
                    Text(puis.longitude)
                        .font(.caption)
                    Spacer()
                }
                .frame(maxWidth: 300, alignment: .leading)
                
                HStack{
                    Text("Screen brightness: ")
                        .font(.caption)
                    Text(puis.brightness)
                        .font(.caption)
                    Spacer()
                }
                .frame(maxWidth: 300, alignment: .leading)
                
                HStack{
                    Text("Speed: ")
                        .font(.caption)
                    Text(puis.speedText + " [m/s]")
                        .font(.caption)
                    Spacer()
                    Text(" Count: ")
                        .font(.caption)
                    Text(String(puis.speedCount))
                        .font(.caption)
                    Text(" /10")
                        .font(.caption)
                }
                .frame(maxWidth: 300, alignment: .leading)
                
                HStack{
                    Text("x: ")
                        .font(.caption)
                    Text(puis.xStr)
                        .font(.caption)
                    Spacer()
                    Text(" Count: ")
                        .font(.caption)
                    Text(String(puis.xCount))
                        .font(.caption)
                    Text(" /10")
                        .font(.caption)
                }
                .frame(maxWidth: 300, alignment: .leading)
                
                HStack{
                    Text("y: ")
                        .font(.caption)
                    Text(puis.yStr)
                        .font(.caption)
                    Spacer()
                    Text(" Count: ")
                        .font(.caption)
                    Text(String(puis.yCount))
                        .font(.caption)
                    Text(" /10")
                        .font(.caption)
                }
                .frame(maxWidth: 300, alignment: .leading)
                
                HStack{
                    Text("z: ")
                        .font(.caption)
                    Text(puis.zStr)
                        .font(.caption)
                    Spacer()
                    Text(" Count: ")
                        .font(.caption)
                    Text(String(puis.zCount))
                        .font(.caption)
                    Text(" /10")
                        .font(.caption)
                }
                .frame(maxWidth: 300, alignment: .leading)
            }
        }

    }
}


struct PlaceonaModalView: View { //アプリ起動時のPlaceona入力ModalView
    
    @EnvironmentObject var puis: PlaceonaUISystem
    
    var body: some View {
        
        VStack{
            
            HStack{
                Text("Placeonaを入力してください。")
                    .font(.title3)
                
                Button(action: {
                    puis.placeonaModalViewQButton()
                }) {
                    Image("qmark")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
            
            
            HStack{
                Text("Eyes: ")
                Picker("", selection: $puis.FirstPlaceonaEyes) {
                            Text("○")
                                .tag(0)
                            Text("×")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            if puis.placeonaModalViewHelp {
                Text("○: デバイスを集中して見ることができる")
                    .font(.caption)
                    .frame(maxWidth: 310, alignment: .leading)
                Text("×: デバイスを集中して見ることができない")
                    .font(.caption)
                    .frame(maxWidth: 310, alignment: .leading)
            }
            
            HStack{
                Text("Hands: ")
                Picker("", selection: $puis.FirstPlaceonaHands) {
                            Text("○")
                                .tag(0)
                            Text("▲")
                                .tag(1)
                            Text("×")
                                .tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            if puis.placeonaModalViewHelp {
                Text("○: 手で操作することができる")
                    .font(.caption)
                    .frame(maxWidth: 310, alignment: .leading)
                Text("▲: 手で持つことができる")
                    .font(.caption)
                    .frame(maxWidth: 310, alignment: .leading)
                Text("×: 手を使用することができない")
                    .font(.caption)
                    .frame(maxWidth: 310, alignment: .leading)
            }
            
            HStack{
                Text("Ears: ")
                Picker("", selection: $puis.FirstPlaceonaEars) {
                            Text("○")
                                .tag(0)
                            Text("×")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            if puis.placeonaModalViewHelp {
                Text("○: 聞くことができる")
                    .font(.caption)
                    .frame(maxWidth: 310, alignment: .leading)
                Text("×: 聞くことができない")
                    .font(.caption)
                    .frame(maxWidth: 310, alignment: .leading)
            }
            
            HStack{
                Text("Mouth: ")
                Picker("", selection: $puis.FirstPlaceonaMouth) {
                            Text("○")
                                .tag(0)
                            Text("×")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            
            if puis.placeonaModalViewHelp {
                Text("○: 話すことができる")
                    .font(.caption)
                    .frame(maxWidth: 310, alignment: .leading)
                Text("×: 話すことができない")
                    .font(.caption)
                    .frame(maxWidth: 310, alignment: .leading)

            }
            
            Button(action: {
                puis.placeonaModalViewFinishButton()
            }){
                Text("  完了  ")
                    .font(.title3)
                    .foregroundColor(Color.white)
                    .padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(Color(UIColor(red: 0, green: 0.5, blue: 0.0, alpha: 0.6)))
                    .cornerRadius(10)
            }
            
        }
    }
}
