//
//  PlaceonaUISystem.swift
//  PlaceonaApp
//
//  Created by 池上 潤
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
import Speech
import NaturalLanguage
import CoreLocation
import CoreMotion
import UIKit

class PlaceonaUISystem: NSObject, ObservableObject, CLLocationManagerDelegate { //PlaceonaUIのシステム実装クラス
    
    // VUIのケースはメインかその他(order(仮))か非表示か
    enum VUIViewType: String {
        case main
        case order
        case hide
    }
    
    @Published var vuiviewtype: VUIViewType = .main // 初期値はメイン
    
    //音が出るかどうか
    var voiceON: Bool = false
    
    //センサON/OFF
    @Published var Sensor: Bool = false {
        didSet{ //センサ起動時にカウント初期化
            if Sensor {
                speedCount = 0
                xCount = 0
                yCount = 0
                zCount = 0
                brightnessCount = 0
            }
        }
    }
    
    //センサON/OFFボタンの動作
    func SensorSwitch(){
        Sensor.toggle()
    }
    
    //ジェスチャーON/OFF
    @Published var gestureON: Bool = false
    
    //Placeona
    @Published var Placeona: Dictionary<String, Int> = ["Eyes": 0, "Hands": 0, "Ears": 0, "Mouth": 0]{
        didSet{ //Placeonaに変化があると呼ばれる
            InteractionStyleCheck()
            motionFlagSet()
        }
    }
    
    enum inputStyle: String { //入力方法
        case Hybrid
        case Screen
        case Voice
        case GestureVoice
    }
    var inputstyle: inputStyle = .Hybrid //入力方法の初期値
    
    enum outputStyle: String { //出力方法
        case Hybrid
        case Screen
        case Voice
    }
    var outputstyle: outputStyle = .Hybrid //出力方法の初期値
    
    enum InteractionStyle: String{ //入出力方法12通り (不可の場合はとりあえずHybridにしている)
        case A //Hybrid:Hybrid
        case B //Hybrid:Screen
        case C //Hybrid:Voice
        case D //Screen:Hybrid
        case E //Screen:Screen
        case F //Screen:Voice
        case G //Voice:Hybrid
        case H //Voice:Screen
        case I //Voice:Voice
        case J //GestureVoice:Hybrid
        case K //GestureVoice:Screen
        case L //GestureVoice:Voice
    }
    @Published var interactionstyle: InteractionStyle = .A //入出力方法の初期値
    
    //入出力方法を決定する
    func InteractionStyleCheck(){
        
        if self.Placeona["Eyes"] == 0{
            
            if self.Placeona["Hands"] == 0{
                
                if self.Placeona["Ears"] == 0{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //0000
                        inputstyle = .Hybrid
                        outputstyle = .Hybrid
                        
                    }else{
                        
                        //0001
                        inputstyle = .Screen
                        outputstyle = .Hybrid
                        
                    }
                }else{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //0010
                        inputstyle = .Hybrid
                        outputstyle = .Screen
                        
                    }else{
                        
                        //0011
                        inputstyle = .Screen
                        outputstyle = .Screen
                        
                    }
                }
            }else if self.Placeona["Hands"] == 1{
                
                if self.Placeona["Ears"] == 0{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //0100
                        inputstyle = .GestureVoice
                        outputstyle = .Hybrid
                        
                    }else{
                        
                        //0101
                        inputstyle = .Hybrid //Gestureのみ
                        outputstyle = .Hybrid
                        
                    }
                }else{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //0110
                        inputstyle = .GestureVoice
                        outputstyle = .Screen
                        
                    }else{
                        
                        //0111
                        inputstyle = .Hybrid //Gestureのみ
                        outputstyle = .Screen
                        
                    }
                }
            }else{
                
                if self.Placeona["Ears"] == 0{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //0200
                        inputstyle = .Voice
                        outputstyle = .Hybrid
                        
                    }else{
                        
                        //0201
                        inputstyle = .Hybrid //(不可)
                        outputstyle = .Hybrid
                        
                    }
                    
                }else{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //0210
                        inputstyle = .Voice
                        outputstyle = .Screen
                        
                    }else{
                        
                        //0211
                        inputstyle = .Hybrid //(不可)
                        outputstyle = .Screen
                        
                    }
                }
            }
            
        }else{//eyes == 1
            
            if self.Placeona["Hands"] == 0{
                
                if self.Placeona["Ears"] == 0{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //1000
                        inputstyle = .GestureVoice
                        outputstyle = .Voice
                        
                    }else{
                        
                        //1001
                        inputstyle = .Hybrid //Gestureのみ
                        outputstyle = .Voice
                        
                    }
                }else{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //1010
                        inputstyle = .GestureVoice
                        outputstyle = .Hybrid //(不可)
                        
                    }else{
                        
                        //1011
                        inputstyle = .Hybrid //Gestureのみ
                        outputstyle = .Hybrid //(不可)
                        
                    }
                }
            }else if self.Placeona["Hands"] == 1{
                
                if self.Placeona["Ears"] == 0{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //1100
                        inputstyle = .GestureVoice
                        outputstyle = .Voice
                        
                    }else{
                        
                        //1101
                        inputstyle = .Hybrid //Gestureのみ
                        outputstyle = .Voice
                        
                    }
                }else{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //1110
                        inputstyle = .GestureVoice
                        outputstyle = .Hybrid //(不可)
                        
                    }else{
                        
                        //1111
                        inputstyle = .Hybrid //Gestureのみ
                        outputstyle = .Hybrid //(不可)
                        
                    }
                }
            }else{
                
                if self.Placeona["Ears"] == 0{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //1200
                        inputstyle = .Voice
                        outputstyle = .Voice
                        
                    }else{
                        
                        //1201
                        inputstyle = .Hybrid //入力不可)
                        outputstyle = .Voice
                        
                    }
                    
                }else{
                    
                    if self.Placeona["Mouth"] == 0{
                        
                        //1210
                        inputstyle = .Voice
                        outputstyle = .Hybrid //(不可)

                        
                    }else{
                        
                        //1211
                        inputstyle = .Hybrid //(不可)
                        outputstyle = .Hybrid //(不可)

                    }
                }
            }
        }
        
        if inputstyle == .Hybrid {
            if outputstyle == .Hybrid {
                //Hybrid:Hybrid
                interactionstyle = .A
                interactionStyleIsA()
                
            }else if outputstyle == .Screen {
                //Hybrid:Screen
                interactionstyle = .B
                InteractionStyleIsB()
                
            }else{
                //Hybrid:Voice
                interactionstyle = .C
                InteractionStyleIsC()
            }
        }else if inputstyle == .Screen {
            if outputstyle == .Hybrid {
                //Screen:Hybrid
                interactionstyle = .D
                interactionStyleIsD()
                
            }else if outputstyle == .Screen {
                //Screen:Screen
                interactionstyle = .E
                InteractionStyleIsE()
                
            }else{
                //Screen:Voice
                interactionstyle = .F
                InteractionStyleIsF()
                
            }
        }else if inputstyle == .Voice {
            if outputstyle == .Hybrid {
                //Voice:Hybrid
                interactionstyle = .G
                interactionStyleIsG()
                
            }else if outputstyle == .Screen {
                //Voice:Screen
                interactionstyle = .H
                InteractionStyleIsH()
                
            }else{
                //Voice:Voice
                interactionstyle = .I
                InteractionStyleIsI()
                
            }
        }else {//GestureVoice
            if outputstyle == .Hybrid {
                //GestureVoice:Hybrid
                interactionstyle = .J
                interactionStyleIsJ()
                
            }else if outputstyle == .Screen {
                //GestureVoice:Screen
                interactionstyle = .K
                InteractionStyleIsK()
                
            }else{
                //GestureVoice:Voice
                interactionstyle = .L
                InteractionStyleIsL()
                
            }
        }
    }
    
    func interactionStyleIsA(){ //Hybrid:Hybrid
        gestureON = true
        voiceON = true
        vuiviewtype = .main
        outputText = "音声入力が使用できます。"
        speechText(text: "音声入力が使用できます。")
    }
    
    func InteractionStyleIsB(){ //Hybrid:Screen
        gestureON = true
        voiceON = false
        vuiviewtype = .main
        outputText = "音声入力が使用できます。"
    }
    
    func InteractionStyleIsC(){ //Hybrid:Voice
        gestureON = true
        voiceON = true
        vuiviewtype = .main
        outputText = "音声入力が使用できます。"
        speechText(text: "音声入力が使用できます。")
    }
    
    func interactionStyleIsD(){ //Screen:Hybrid
        gestureON = false
        voiceON = true
        vuiviewtype = .main
        outputText = ""
    }
    
    func InteractionStyleIsE(){ //Screen:Screen
        gestureON = false
        voiceON = false
        vuiviewtype = .hide
        outputText = ""
    }
    
    func InteractionStyleIsF(){ //Screen:Voice
        gestureON = false
        voiceON = true
        vuiviewtype = .main
        outputText = "音声入力が使用できます。"
    }
    
    func interactionStyleIsG(){ //Voice:Hybrid
        gestureON = false
        voiceON = true
        vuiviewtype = .main
        outputText = "音声入力が使用できます。効果音の後に入力してください。"
        speechText(text: "音声入力が使用できます。効果音の後に入力してください。")
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.inputTimeCount()
        }
    }
    
    func InteractionStyleIsH(){ //Voice:Screen
        gestureON = false
        voiceON = false
        vuiviewtype = .main
        outputText = "(マイクボタンが動いている間)音声入力が使用できます。"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.inputTimeCount()
        }
    }
    
    func InteractionStyleIsI(){ //Voice:Voice
        gestureON = false
        voiceON = true
        vuiviewtype = .main
        outputText = "音声入力が使用できます。効果音の後に入力してください。"
        speechText(text: "音声入力が使用できます。効果音の後に入力してください。")
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.inputTimeCount()
        }
    }
    
    func interactionStyleIsJ(){ //GestureVoice:Hybrid
        gestureON = true
        voiceON = true
        vuiviewtype = .main
        outputText = "シェイクジェスチャーで音声入力を使用できます。"
        speechText(text: "シェイクジェスチャーで音声入力を使用できます。")
    }
    
    func InteractionStyleIsK(){ //GestureVoice:Screen
        gestureON = true
        voiceON = false
        vuiviewtype = .main
        outputText = "シェイクジェスチャーで音声入力を使用できます。"
    }
    
    func InteractionStyleIsL(){ //GestureVoice:Voice
        gestureON = true
        voiceON = true
        vuiviewtype = .main
        outputText = "シェイクジェスチャーで音声入力を使用できます。"
        speechText(text: "シェイクジェスチャーで音声入力を使用できます。")
    }
    
    //VUI実装
    @Published var audioText: String = "" //入力テキスト
    @Published var audioRunning: Bool = false {
        didSet{ //録音中はセンサを停止する
            if audioRunning {
                Sensor = false
            }else{
                Sensor = true
            }
        }
    }
    
    var audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var synthesizer = AVSpeechSynthesizer()
    
    //マイクボタン音
    let micSoundData = NSDataAsset(name: "micSound")!.data
    var micSoundPlayer: AVAudioPlayer?
    
    //マイク音
    func micSoundPlay(){
        do{
            if voiceON {
                micSoundPlayer = try AVAudioPlayer(data: micSoundData)
                micSoundPlayer?.play()
            }
        } catch {
            
        }
    }
    
    //マイクボタンのアニメーション
    @Published var micAnimation = true
    
    //テキスト読み上げ
    func speechText(text: String){
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.ambient)
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

        //発音を準備
        let utterance = AVSpeechUtterance.init(string: text)
        utterance.voice = AVSpeechSynthesisVoice.init(language: "ja-JP")
        //再生する
        if voiceON {
            synthesizer.speak(utterance)
        }
    }
    
    //形態素解析
    func retrieveTokens(from text: String, unit: NLTokenUnit = .word) -> [String] { //文字列を受け取って、単語に分割して格納
        let tokenizer = NLTokenizer(unit: unit)
        tokenizer.string = text
        
        //分解された単語を格納する配列
        var words = [String]()
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { (tokenRange, _) -> Bool in
            words.append(String(text[tokenRange].lowercased()))
            return true
        }
        return words
    }
    
    func stopRecording(){
        self.recognitionTask?.cancel()
        self.recognitionTask?.finish()
        self.recognitionRequest?.endAudio()
        self.recognitionRequest = nil
        self.recognitionTask = nil
        self.audioEngine.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setMode(AVAudioSession.Mode.default)
        } catch{
            print("AVAudioSession error")
        }
        self.audioRunning = false
    }
    
    func startButton() throws {
        
        self.micSoundPlay()
        Thread.sleep(forTimeInterval: 0.08)
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        self.recognitionTask = SFSpeechRecognitionTask()
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        if(self.recognitionTask == nil || self.recognitionRequest == nil){
            self.stopRecording()
            return
        }
        DispatchQueue.main.async {
            self.audioText = ""
        }
        recognitionRequest?.shouldReportPartialResults = true
        if #available(iOS 13, *) {
            recognitionRequest?.requiresOnDeviceRecognition = false
        }
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { result, error in
            if(error != nil){
                print (String(describing: error))
                self.stopRecording()
                return
            }
            var isFinal = false
            if let result = result {
                isFinal = result.isFinal
                self.audioText = result.bestTranscription.formattedString
                print(result.bestTranscription.formattedString)
            }
            if isFinal {
                print("recording time limit")
                self.stopRecording()
                inputNode.removeTap(onBus: 0)
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        self.audioEngine.prepare()
        try self.audioEngine.start()
        DispatchQueue.main.async {
            self.audioRunning = true
        }
    }
    
    
    var showingAlert = false //音声入力の許可得るとき
    
    func micButton(){
        
        if(AVCaptureDevice.authorizationStatus(for: AVMediaType.audio) == .authorized &&
            SFSpeechRecognizer.authorizationStatus() == .authorized){
            self.showingAlert = false
            if audioEngine.isRunning{
                self.stopButton()
            }else{
                inputTimeCount()
            }
        }
        else{
            self.showingAlert = true
        }
        
        micAnimation = true
    }
    
    var inputText: String = ""
    @Published var outputText: String = ""
    
    func stopButton(){
        
        stopRecording()
        inputText = audioText
        let words = retrieveTokens(from: inputText)
        print(words)
        check(inputWords: words)
    }
    
    //入力の自動終了
    func autoStopButton(){
        stopRecording()
        outputText = "一定時間操作がなかったため、入力を終了します。"
        speechText(text: "一定時間操作がなかったため、入力を終了します。")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.inputText = self.audioText
            let words = self.retrieveTokens(from: self.inputText)
            print(words)
            self.check(inputWords: words)
            self.speechTimeCount = 0
        }
    }
    
    @Published var speechTimer: Timer!
    @Published var speechTimeCount: Int = 0
    
    //時間計測開始, 10秒経ったら自動で入力終了し入力解析
    func inputTimeCount(){
        try! startButton()
        speechTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            if self.speechTimeCount < 10 {
                if self.audioEngine.isRunning{
                    self.speechTimeCount = self.speechTimeCount + 1
                } else {
                    self.speechTimer.invalidate() //タイマーを破棄
                }
            }else{
                self.speechTimer.invalidate() //タイマーを破棄
                self.autoStopButton()
            }
        }
    }
    
    //条件比較
    func check(inputWords: [String]) {

        //Checkwordが複数ある場合、どれか1つが含まれているかどうか true or false で返すメソッド
        func wordCheck(words: [String] = inputWords, Checkwords: [String]) -> Bool {
            var existence: Bool = false
            for i in 0 ..< Checkwords.count {
                if words.contains(Checkwords[i]) {
                    existence = true
                    break
                } else if i == Checkwords.count - 1 {
                    existence = false
                } else {
                    continue
                }
            }
            return existence
        }
        
        func checkA() -> Bool {
            let Checkword1 = "今日"
            let Checkword2 = "天気"
            
            if inputWords.contains(Checkword1){
                return inputWords.contains(Checkword2)
            }else{
                return false
            }
        }
        
        func checkB() -> Bool {
            let Checkword1 = "c"
            let Checkword2 = "d"
            
            if inputWords.contains(Checkword1){
                return inputWords.contains(Checkword2)
            }else{
                return false
            }
            
        }

        //ここからcheck()の動作
        if checkA() {
            return actionA()
        }else if checkB() {
            return actionB()
        }else{
            return mismatch()
        }
    
    }
    
    /*
    //入力のYes/Noを判別する際に使う
    func checkYN(inputWords: [String]) -> Bool {
        
        func wordCheck(words: [String] = inputWords, Checkwords: [String]) -> Bool {
            var existence: Bool = false
            for i in 0 ..< Checkwords.count {
                if words.contains(Checkwords[i]) {
                    existence = true
                    break
                } else if i == Checkwords.count - 1 {
                    existence = false
                } else {
                    continue
                }
            }
            return existence
        }
        
        let Checkwords = ["はい", "イエス", "いえす", "そう", "オッケー", "yes", "おっけー", "良い", "大丈夫"]
        return wordCheck(Checkwords: Checkwords)
    }
     */
    
    func actionA(){
        outputText = "アクションA"
        speechText(text: outputText)
    }
    
    func actionB(){
        outputText = "アクションB"
        speechText(text: outputText)
    }
    
    func mismatch(){
        outputText = "その入力には現在対応していません。"
        speechText(text: outputText)
    }
    
    
    @Published var placeonaViewModal: Bool = false
    
    func placeonaViewQButton(){
        placeonaViewModal = true
    }
    
    func placeonaViewModalCloseButton(){
        placeonaViewModal = false
    }
    //音声関連の許可
    func privacyConfirmation(){
        AVCaptureDevice.requestAccess(for: AVMediaType.audio) { granted in
            OperationQueue.main.addOperation {
            }
        }
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
            }
        }
    }
    
    //アプリ起動時のPlaceona入力ModalView
    @Published var placeonaModalView: Bool = true
    @Published var placeonaModalViewHelp: Bool = false
    
    func placeonaModalViewQButton(){
        placeonaModalViewHelp.toggle()
    }
    
    @Published var FirstPlaceonaEyes: Int = 0
    @Published var FirstPlaceonaHands: Int = 0
    @Published var FirstPlaceonaEars: Int = 0
    @Published var FirstPlaceonaMouth: Int = 0
    
    func placeonaModalViewFinishButton(){
        placeonaModalView = false
        placeonaModalViewHelp = false
        Placeona = ["Eyes": FirstPlaceonaEyes , "Hands": FirstPlaceonaHands, "Ears": FirstPlaceonaEars, "Mouth": FirstPlaceonaMouth]
        Sensor = true
        userSpeedCheck()
        motionCheck()
        brightnessCheck()
        
    }
    
    @Published var latitude: String = "" //緯度
    @Published var longitude: String = "" //経度
    @Published var speedText: String = "" //速度
    @Published var speed: Double!
    
    @Published var speedTimer: Timer!
    @Published var speedCount: Int = 0
    
    //速度, 位置情報
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        if manager.authorizationStatus == .authorizedWhenInUse {
            
            print("authorized")
            manager.startUpdatingLocation()
            
            if manager.accuracyAuthorization != .fullAccuracy {
                print("reduce accuracy")
                
                manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Location") {(err) in
                    if err != nil {
                        print(err!)
                        return
                    }
                }
            }
        } else {
            print("not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }
    //位置情報変化すると勝手に呼び出される
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last,
            CLLocationCoordinate2DIsValid(newLocation.coordinate) else {
                speedText = "Error"
                return
        }
        speedText = "".appendingFormat("%.3f", newLocation.speed)
        latitude = String(format: "%+.06f", newLocation.coordinate.latitude)
        longitude = String(format: "%+.06f", newLocation.coordinate.longitude)
        
    }
    
    //速度監視
    func userSpeedCheck(){
        speedTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){ _ in
            if self.Sensor {
                self.speed = Double(self.speedText)
                
                if self.speed > 0.5 {
                    if self.speedCount == 10 {
                        if self.Placeona["Eyes"] != 1 {
                            self.speedCount = 0
                            self.outputText = "移動を検知しました。"
                            self.speechText(text: "移動を検知しました。")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.Placeona["Eyes"] = 1
                            }
                        } else { self.speedCount = 0 }
                    } else {
                        self.speedCount = self.speedCount + 1
                    }
                } else {
                    self.speedCount = 0
                }
            }
        }
    }
    
    @Published var xStr = "0.0"
    @Published var yStr = "0.0"
    @Published var zStr = "0.0"
    let motionManager = CMMotionManager()
    
    @Published var motionTimer: Timer!
    //一回前の加速度保持
    var xB: Double = 0
    var yB: Double = 0
    var zB: Double = 0
    //加速度の差分が条件を満たしたカウント
    @Published var xCount: Int = 0
    @Published var yCount: Int = 0
    @Published var zCount: Int = 0
    
    var motionFlag: Bool = true //条件が同時に満たないようにするための変数
    
    func motionData() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (motion:CMAccelerometerData?, error:Error?) in
                self.updateMotionData(motionData: motion!)
            }
        }
    }
    func updateMotionData(motionData:CMAccelerometerData) {
        xStr = String(format: "%.4f", motionData.acceleration.x)
        yStr = String(format: "%.4f", motionData.acceleration.y)
        zStr = String(format: "%.4f", motionData.acceleration.z)
    }
    
    //加速度監視
    func motionCheck(){
        motionData()
        motionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            if self.Sensor {
                //各軸の加速度をdouble型絶対値に変換
                let x = fabs(Double(self.xStr)!)
                let y = fabs(Double(self.yStr)!)
                let z = fabs(Double(self.zStr)!)
                //各軸の差分を入れる変数
                let xDif = fabs(self.xB - x)
                let yDif = fabs(self.yB - y)
                let zDif = fabs(self.zB - z)
                
                if xDif < 0.015 {
                    if self.xCount >= 10 {
                    } else {
                        self.xCount = self.xCount + 1
                    }
                } else {
                    self.xCount = 0
                }
                
                if yDif < 0.015 {
                    if self.yCount >= 10 {
                    } else {
                        self.yCount = self.yCount + 1
                    }
                } else {
                    self.yCount = 0
                }
                
                if zDif < 0.015 {
                    if self.zCount >= 10 {
                    } else {
                        self.zCount = self.zCount + 1
                    }
                } else {
                    self.zCount = 0
                }
                
                if self.xCount >= 10 || self.yCount >= 10 || self.zCount >= 10 {
                    if self.Placeona["Hands"] != 2 && self.motionFlag {
                        self.motionFlag = false
                        self.outputText = "ユーザとデバイスの間に距離を検知しました。"
                        self.speechText(text: "ユーザとデバイスの間に距離を検知しました。")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.Placeona["Hands"] = 2
                            self.xCount = 0
                            self.yCount = 0
                            self.zCount = 0
                        }
                    } else {
                        self.xCount = 0
                        self.yCount = 0
                        self.zCount = 0
                    }
                }
                self.xB = x
                self.yB = y
                self.zB = z
            }
        }
    }
    
    func motionFlagSet(){
        if self.Placeona["Hands"] != 2 {
            self.motionFlag = true
        }
    }
    
    @Published var brightness: String = ""
    @Published var brightnessCount: Int = 0
    @Published var brightnessTimer: Timer!
    
    //輝度監視
    func brightnessCheck(){
        brightnessTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            if self.Sensor {
                self.brightness = String(format: "%.4f", UIScreen.main.brightness)
                let briD = Double(self.brightness)!
                
                if briD < 0.3 {
                    if self.brightnessCount < 5 {
                        self.brightnessCount = self.brightnessCount + 1
                    } else if self.brightnessCount == 5 {
                        self.outputText = "周囲が暗くはないでしょうか？"
                        self.speechText(text: "周囲が暗くはないでしょうか。")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            
                            if self.interactionstyle == .A || self.interactionstyle == .B || self.interactionstyle == .C{
                                self.outputText = "マイクボタンから音声入力が使用できます。"
                                self.speechText(text: "マイクボタンから音声入力を使用することもできます。")
                            }else if self.interactionstyle == .G || self.interactionstyle == .H || self.interactionstyle == .I{
                                self.outputText = "音声入力が使用できます。効果音の後に入力してください。"
                                self.speechText(text: "音声入力が使用できます。効果音の後に入力してください。")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                                    self.inputTimeCount()
                                }
                            }
                        }
                        self.brightnessCount = self.brightnessCount + 1
                    }
                } else { self.brightnessCount = 0 }
            }
        }
    }
    
}
