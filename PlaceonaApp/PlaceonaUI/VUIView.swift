//
//  VUIView.swift
//  PlaceonaApp
//
//  Created by 池上 潤 
//

import SwiftUI
import CoreLocation

struct VUIView: View{ // VUI画面
    
    @EnvironmentObject var puis: PlaceonaUISystem
    var manager = CLLocationManager()
    
    var body: some View{
        
        ZStack{
            
            if puis.vuiviewtype == .main{
                
                ZStack {
                    Color(red: 55/255, green: 55/255, blue: 55/255, opacity: 0.9)
                        .edgesIgnoringSafeArea(.all)
                    
                    HStack{
                        VStack{
                            
                            Text(puis.outputText)
                                .frame(maxWidth: 350, alignment: .leading)
                                .foregroundColor(Color(red: 180/255, green: 255/255, blue: 180/255))
                                .padding(.leading, 5.0)
                            
                            Text(puis.audioText)
                                .frame(maxWidth: 350, alignment: .trailing)
                                .foregroundColor(Color(red: 180/255, green: 255/255, blue: 180/255))
                        }
                        
                        ZStack{
                            
                            Button(action: {
                                
                                puis.micButton()
                                
                            }) {
                                Image("micButton")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 47, height: 47)
                            }
                            .padding(.trailing, 5.0)
                            .padding(.leading, 5.0)
                            .alert(isPresented: $puis.showingAlert) {
                                Alert(title: Text("マイクの使用または音声の認識が許可されていません"))
                            }
                            
                            if puis.audioRunning {
                                
                                Circle()
                                    .trim(from: 0, to: 0.5)
                                    .stroke(AngularGradient(gradient: Gradient(colors: [.red, .white]), center: .center),
                                            style: StrokeStyle(
                                                lineWidth: 8,
                                                lineCap: .round,
                                                dash: [0.1, 16],
                                                dashPhase: 8))
                                    .frame(width: 38, height: 38)
                                    .rotationEffect(Angle(degrees: puis.micAnimation ? 360 : 0))
                                    .onAppear() {
                                        withAnimation(
                                            Animation
                                                .linear(duration: 1)
                                                .repeatForever(autoreverses: false)){
                                                    puis.micAnimation.toggle()
                                        }
                                    }
                                    .padding(.trailing, 5.0)
                                    .padding(.leading, 5.0)
                            }
                            
                        }
                        
                    }
                    
                }
                .frame(height: 80, alignment:.center)
                .onAppear{
                    puis.privacyConfirmation()
                    //位置情報使うための記述
                    manager.delegate = puis
                    puis.locationManagerDidChangeAuthorization(manager)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
            if puis.gestureON {
                puis.micButton()
            }
        }
        .sheet(isPresented: $puis.placeonaModalView) {
            PlaceonaModalView().environmentObject(self.puis)
        }
        
    }
}

extension NSNotification.Name {
    public static let deviceDidShakeNotification = NSNotification.Name("DeviceDidShakeNotification")
}
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
}
