//
//  Compass.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/10/23.
//

import SwiftUI

struct Compass: View {
    
    @State var shouldHideP1Heading = false
    @State var shouldHideP2Heading = false
    @State var p1Heading: Double = 500
    @State var p2Heading: Double = 500
    @EnvironmentObject var bleManager: BLEManager
    @ObservedObject var compassHeading = CompassHeading()
    @State var newInterval = 1


    var body: some View {
        
        VStack {
            Capsule()
                .frame(width: 5, height: 25)
                .padding(.vertical, -7)
            
            ZStack {
                ZStack {
                    VStack {
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color.red)
                        
                        Spacer()
                    }
                    .rotationEffect(Angle(degrees: p1Heading))
                    .opacity(shouldHideP1Heading ? 1 : 0)
                    
                    VStack {
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color.blue)
                        
                        Spacer()
                    }
                    .rotationEffect(Angle(degrees: p2Heading))
                    .opacity(shouldHideP2Heading ? 1 : 0)
                        
                    ForEach(Marker.markers(), id: \.self) { marker in
                        CompassMarkerView(marker: marker,
                                          compassDegress: self.compassHeading.degrees)
                    }

                    
                }
                .frame(width: UIScreen.screenWidth, height: 265)
                .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                
//                Image(systemName: "plus")
//                    .resizable()
//                    .frame(width: 110, height: 110)
                
                
                Divider()
                    .frame(width: 265, height: 265)
                    .rotationEffect(.degrees(-180))
                
                Divider()
                    .frame(width: 265, height: 265)
                    .rotationEffect(.degrees(-90))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                print("-----> callFunc1")
                getPartner1Heading()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                print("-----> callFunc2")
                getPartner2Heading()
            }
        }
    }

    
    func getPartner1Heading() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(newInterval), repeats: true) { timer in
            bleManager.getPartner1Heading { heading in
                print("heading is \(heading)")
                let heading = heading as! Double
                print(compassHeading.degrees)

//                p1Heading = compassHeading.degrees - heading
                p1Heading = heading

//                if p1Heading < 0 {
//                    p1Heading+=180
//                }
    //            p1Heading = 245
                print("Final p1heading \(p1Heading)")
                shouldHideP1Heading = true

            }
            if bleManager.myPeripheral == nil {
                timer.invalidate()
            }
        }
    }
    
    func getPartner2Heading() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(newInterval), repeats: true) { timer in
            bleManager.getPartner2Heading { heading in
                print("heading is \(heading)")
                let heading = heading as! Double
                print(compassHeading.degrees)

//                p2Heading = heading
//                if p2Heading < 0 {
//                    p2Heading+=360
//                }
                p2Heading = 340
                print("Final p2heading \(p2Heading)")
                shouldHideP2Heading = true
            }
            
            if bleManager.myPeripheral == nil {
                timer.invalidate()
            }
        }
    }
    
    
    
    
    
//    @Sendable func delayPartner1Heading() async {
//        try? await Task.sleep(nanoseconds: 4_000_000_000)
//        bleManager.getPartner1Heading { heading in
//            print("heading is \(heading)")
//            let heading = heading as! Double
//            print(compassHeading.degrees)
//
//            p1Heading = compassHeading.degrees - heading
//
//            if p1Heading < 0 {
//                p1Heading+=360
//            }
////            p1Heading = 245
//            print("Final p1heading \(p1Heading)")
//            shouldHideP1Heading = true
//
//        }
//    }
//
//    @Sendable func delayPartner2Heading() async {
//        try? await Task.sleep(nanoseconds: 8_000_000_000)
//        bleManager.getPartner2Heading { heading in
//            print("heading is \(heading)")
//            let heading = heading as! Double
//            print(compassHeading.degrees)
//
//            p2Heading = compassHeading.degrees - heading
//
//            if p2Heading < 0 {
//                p2Heading+=360
//            }
//            p2Heading = 245
//            print("Final p2heading \(p2Heading)")
//            shouldHideP2Heading = true
//        }
//    }
}

struct Compass_Previews: PreviewProvider {
    static var previews: some View {
        Compass()
    }
}

struct CompassMarkerView: View {
    let marker: Marker
    let compassDegress: Double

    @State var p1Heading: Double = 0
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var compassHeading: CompassHeading

    
    var body: some View {
        VStack {

            if marker.show {
                Text(marker.degreeText())
    //                .fontWeight(.light)
                    .rotationEffect(self.textAngle())
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(Color.gray.opacity(0.5))
            }
//            else {
//                Text("")
//            }


            if marker.show {
                Capsule()
                    .frame(width: 2,
                           height: 10)
                    .foregroundColor(.black)
                    .padding(.bottom, 35)
//                Capsule()
//                    .frame(width: self.capsuleWidth(),
//                           height: self.capsuleHeight())
//                    .foregroundColor(self.capsuleColor())
            } else {
                Capsule()
                    .frame(width: 0.5,
                           height: 10)
                    .foregroundColor(.black)
            }


            Text(marker.label)
                .fontWeight(.bold)
                .frame(width: 50,height: 50)
                .foregroundColor(.black)
                .rotationEffect(self.textAngle())
                .padding(.bottom, 220)
            
//            Text(marker.label)
//                .fontWeight(.bold)
//                .foregroundColor(.black)
//                .rotationEffect(self.textAngle())
//                .padding(.bottom, 180)
        }
        .rotationEffect(Angle(degrees: marker.degrees))
    }
    
    private func capsuleWidth() -> CGFloat {
        return self.marker.degrees == 0 ? 7 : 3
    }

    private func capsuleHeight() -> CGFloat {
        return self.marker.degrees == 0 ? 45 : 30
    }

    private func capsuleColor() -> Color {
        return self.marker.degrees == 0 ? .red : .gray
    }

    private func textAngle() -> Angle {
        return Angle(degrees: -self.compassDegress - self.marker.degrees)
    }
}

struct Marker: Hashable {
    
    var degrees: Double
    let label: String
    let show: Bool

    init(degrees: Double, label: String = "", show: Bool = false) {
        self.degrees = degrees
        self.label = label
        self.show = show
    }

    func degreeText() -> String {
        return String(format: "%.0f", self.degrees)
    }

    static func markers() -> [Marker] {
        return [
            Marker(degrees: 0, label: "N", show: true),
            
            Marker(degrees: 2, show: false),
            Marker(degrees: 4, show: false),
            Marker(degrees: 6, show: false),
            Marker(degrees: 8, show: false),
            Marker(degrees: 10, show: false),
            Marker(degrees: 12, show: false),
            Marker(degrees: 14, show: false),
            Marker(degrees: 16, show: false),
            Marker(degrees: 18, show: false),
            Marker(degrees: 20, show: false),
            Marker(degrees: 22, show: false),
            Marker(degrees: 24, show: false),
            Marker(degrees: 26, show: false),
            Marker(degrees: 28, show: false),


            Marker(degrees: 30, show: true),
            
            Marker(degrees: 32, show: false),
            Marker(degrees: 34, show: false),
            Marker(degrees: 36, show: false),
            Marker(degrees: 38, show: false),
            Marker(degrees: 40, show: false),
            Marker(degrees: 42, show: false),
            Marker(degrees: 44, show: false),
            Marker(degrees: 46, show: false),
            Marker(degrees: 48, show: false),
            Marker(degrees: 50, show: false),
            Marker(degrees: 52, show: false),
            Marker(degrees: 54, show: false),
            Marker(degrees: 56, show: false),
            Marker(degrees: 58, show: false),
            
            Marker(degrees: 60, show: true),
            
            Marker(degrees: 62, show: false),
            Marker(degrees: 64, show: false),
            Marker(degrees: 66, show: false),
            Marker(degrees: 68, show: false),
            Marker(degrees: 70, show: false),
            Marker(degrees: 72, show: false),
            Marker(degrees: 74, show: false),
            Marker(degrees: 76, show: false),
            Marker(degrees: 78, show: false),
            Marker(degrees: 80, show: false),
            Marker(degrees: 82, show: false),
            Marker(degrees: 84, show: false),
            Marker(degrees: 86, show: false),
            Marker(degrees: 88, show: false),
            
            Marker(degrees: 90, label: "E", show: true),
            
            Marker(degrees: 92, show: false),
            Marker(degrees: 94, show: false),
            Marker(degrees: 96, show: false),
            Marker(degrees: 98, show: false),
            Marker(degrees: 100, show: false),
            Marker(degrees: 102, show: false),
            Marker(degrees: 104, show: false),
            Marker(degrees: 106, show: false),
            Marker(degrees: 108, show: false),
            Marker(degrees: 110, show: false),
            Marker(degrees: 112, show: false),
            Marker(degrees: 114, show: false),
            Marker(degrees: 116, show: false),
            Marker(degrees: 118, show: false),
            
            Marker(degrees: 120, show: true),
            
            Marker(degrees: 122, show: false),
            Marker(degrees: 124, show: false),
            Marker(degrees: 126, show: false),
            Marker(degrees: 128, show: false),
            Marker(degrees: 130, show: false),
            Marker(degrees: 132, show: false),
            Marker(degrees: 134, show: false),
            Marker(degrees: 136, show: false),
            Marker(degrees: 138, show: false),
            Marker(degrees: 140, show: false),
            Marker(degrees: 142, show: false),
            Marker(degrees: 144, show: false),
            Marker(degrees: 146, show: false),
            Marker(degrees: 148, show: false),
            
            Marker(degrees: 150, show: true),
            
            Marker(degrees: 152, show: false),
            Marker(degrees: 154, show: false),
            Marker(degrees: 156, show: false),
            Marker(degrees: 158, show: false),
            Marker(degrees: 160, show: false),
            Marker(degrees: 162, show: false),
            Marker(degrees: 164, show: false),
            Marker(degrees: 166, show: false),
            Marker(degrees: 168, show: false),
            Marker(degrees: 170, show: false),
            Marker(degrees: 172, show: false),
            Marker(degrees: 174, show: false),
            Marker(degrees: 176, show: false),
            Marker(degrees: 178, show: false),
            
            Marker(degrees: 180, label: "S", show: true),
            
            Marker(degrees: 182, show: false),
            Marker(degrees: 184, show: false),
            Marker(degrees: 186, show: false),
            Marker(degrees: 188, show: false),
            Marker(degrees: 190, show: false),
            Marker(degrees: 192, show: false),
            Marker(degrees: 194, show: false),
            Marker(degrees: 196, show: false),
            Marker(degrees: 198, show: false),
            Marker(degrees: 200, show: false),
            Marker(degrees: 202, show: false),
            Marker(degrees: 204, show: false),
            Marker(degrees: 206, show: false),
            Marker(degrees: 208, show: false),
            
            Marker(degrees: 210, show: true),
            
            Marker(degrees: 212, show: false),
            Marker(degrees: 214, show: false),
            Marker(degrees: 216, show: false),
            Marker(degrees: 218, show: false),
            Marker(degrees: 220, show: false),
            Marker(degrees: 222, show: false),
            Marker(degrees: 224, show: false),
            Marker(degrees: 226, show: false),
            Marker(degrees: 228, show: false),
            Marker(degrees: 230, show: false),
            Marker(degrees: 232, show: false),
            Marker(degrees: 234, show: false),
            Marker(degrees: 236, show: false),
            Marker(degrees: 238, show: false),
            
            Marker(degrees: 240, show: true),
            
            Marker(degrees: 242, show: false),
            Marker(degrees: 244, show: false),
            Marker(degrees: 246, show: false),
            Marker(degrees: 248, show: false),
            Marker(degrees: 250, show: false),
            Marker(degrees: 252, show: false),
            Marker(degrees: 254, show: false),
            Marker(degrees: 256, show: false),
            Marker(degrees: 258, show: false),
            Marker(degrees: 260, show: false),
            Marker(degrees: 262, show: false),
            Marker(degrees: 264, show: false),
            Marker(degrees: 266, show: false),
            Marker(degrees: 268, show: false),
            
            Marker(degrees: 270, label: "W", show: true),
            
            Marker(degrees: 272, show: false),
            Marker(degrees: 274, show: false),
            Marker(degrees: 276, show: false),
            Marker(degrees: 278, show: false),
            Marker(degrees: 280, show: false),
            Marker(degrees: 282, show: false),
            Marker(degrees: 284, show: false),
            Marker(degrees: 286, show: false),
            Marker(degrees: 288, show: false),
            Marker(degrees: 290, show: false),
            Marker(degrees: 292, show: false),
            Marker(degrees: 294, show: false),
            Marker(degrees: 296, show: false),
            Marker(degrees: 298, show: false),
            
            Marker(degrees: 300, show: true),
            
            Marker(degrees: 302, show: false),
            Marker(degrees: 304, show: false),
            Marker(degrees: 306, show: false),
            Marker(degrees: 308, show: false),
            Marker(degrees: 310, show: false),
            Marker(degrees: 312, show: false),
            Marker(degrees: 314, show: false),
            Marker(degrees: 316, show: false),
            Marker(degrees: 318, show: false),
            Marker(degrees: 320, show: false),
            Marker(degrees: 322, show: false),
            Marker(degrees: 324, show: false),
            Marker(degrees: 326, show: false),
            Marker(degrees: 328, show: false),
            
            Marker(degrees: 330, show: true),
            
            Marker(degrees: 332, show: false),
            Marker(degrees: 334, show: false),
            Marker(degrees: 336, show: false),
            Marker(degrees: 338, show: false),
            Marker(degrees: 340, show: false),
            Marker(degrees: 342, show: false),
            Marker(degrees: 344, show: false),
            Marker(degrees: 346, show: false),
            Marker(degrees: 348, show: false),
            Marker(degrees: 350, show: false),
            Marker(degrees: 352, show: false),
            Marker(degrees: 354, show: false),
            Marker(degrees: 356, show: false),
            Marker(degrees: 358, show: false)
        ]
    }
}
