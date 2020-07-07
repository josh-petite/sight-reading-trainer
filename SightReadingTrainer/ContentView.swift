//
//  ContentView.swift
//  SightReadingTrainer
//
//  Created by Josh Petite on 6/23/20.
//  Copyright © 2020 Josh Petite. All rights reserved.
//

import SwiftUI

/// this is the main content view
struct ContentView: View {
    enum Pitch {
        case a, b, c, d, e, f, g
    }
    
    enum NoteType {
        case whole, half, quarter, eighth, sixteenth
    }
    
    struct Note: View {
        let type: NoteType
        let width: CGFloat
        let height: CGFloat
        let location: CGPoint
        
        var body: some View {
            ZStack {
                if type == .whole {
                    ZStack {
                        Ellipse()
                            .fill(Color.black)
                            .frame(width: width, height: height * 0.6)
                        Ellipse()
                            .fill(Color.white)
                            .frame(width: width * 0.5, height: height * 0.5)
                            .rotationEffect(.init(degrees: -30), anchor: .center)
                    }
                    .offset(x: location.x, y: location.y)
                } else if type == .half {
                    Group {
                        Ellipse()
                            .fill(Color.black)
                            .frame(width: width, height: height)
                            .rotationEffect(.init(degrees: 90), anchor: .center)
                        Ellipse()
                            .fill(Color.white)
                            .frame(width: width * 0.4, height: height * 0.9)
                            .rotationEffect(.init(degrees: 30), anchor: .center)
                    }.offset(x: location.x, y: location.y)
                } else {
                    Text("Not implemented!")
                        .foregroundColor(.red)
                }
            }
        }
        
        init(type: NoteType, width: CGFloat, height: CGFloat, location: CGPoint) {
            self.type = type
            self.width = width
            self.height = height
            self.location = location
        }
    }
    
    struct StaffNote : Identifiable {
        let id = UUID()
        let type: NoteType
        let octave: Int
        let pitch: Pitch
        
        init(type: NoteType, octave: Int, pitch: Pitch) {
            self.type = type
            self.octave = octave
            self.pitch = pitch
        }
    }
    
    struct TrebleStaff: View {
        let width: CGFloat
        let height: CGFloat
        let notes: [StaffNote]
        
        @State var trebleClefImage: Image?
        
        var body: some View {
            GeometryReader { geo in
                let staffLineOffset = geo.size.height / 15
                let noteWidth = staffLineOffset
                let noteHeight = staffLineOffset
                let staffWidth = geo.size.width
                let staffTop = geo.size.height * 0.33
                let staffHeight = staffTop + (staffLineOffset * 4)
                let staffFrame = geo.size
                
                ZStack(alignment: .leading) {
                    Image("treble")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(x: 0.68, y: 0.68, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .offset(x: 0, y: -staffLineOffset / 2)
                        .frame(height: staffHeight)
                    
//                    Text("4")
//                        .fontWeight(.bold)
//                        .font(.largeTitle)
                    
                    ForEach(0..<notes.count) { i in
                        let note: StaffNote = notes[i]
                        let location: CGPoint = self.calculateNoteLocation(
                            parentFrame: staffFrame,
                            octave: note.octave,
                            pitch: note.pitch,
                            noteNumber: CGFloat(i + 1))
                        
                        Note(type: note.type,
                             width: noteWidth,
                             height: noteHeight,
                             location: location)
                    }
                    
                    // ledger lines
                    ForEach(0..<5) { lineIndex in
                        let y = 0 + (CGFloat(lineIndex) * staffLineOffset)
                        self.drawHLine(
                            CGPoint(x: 0, y: y),
                            CGPoint(x: staffWidth, y: y))
                            .foregroundColor(.blue)
                    }

                    self.drawVLine(
                        CGPoint(x: 0, y: staffTop),
                        CGPoint(x: 0, y: staffHeight))
                    
                    ForEach(0..<5) { lineIndex in
                        let y = staffTop + (CGFloat(lineIndex) * staffLineOffset)
                        self.drawHLine(
                            CGPoint(x: 0, y: y),
                            CGPoint(x: staffWidth, y: y))
                            .foregroundColor(.black)
                    }
                    
                    self.drawVLine(
                        CGPoint(x: staffWidth * 0.995, y: staffTop),
                        CGPoint(x: staffWidth * 0.995, y: staffHeight))
                    
                    self.drawVLine(
                        CGPoint(x: staffWidth, y: staffTop),
                        CGPoint(x: staffWidth, y: staffHeight))
                    
                    // ledger lines
                    ForEach(0..<5) { lineIndex in
                        let y = staffHeight + staffLineOffset + (CGFloat(lineIndex) * staffLineOffset)
                        self.drawHLine(
                            CGPoint(x: 0, y: y),
                            CGPoint(x: staffWidth, y: y))
                            .foregroundColor(.blue)
                    }
                }
            }
            .frame(width: width, height: height, alignment: .center)
//            .onAppear(perform: loadTrebleClefImage)
        }
        
        init(width: CGFloat, height: CGFloat) {
            self.width = width
            self.height = height
            
            self.notes = [
                StaffNote(type: .half, octave: 4, pitch: .f),
//                StaffNote(type: .whole, octave: 4, pitch: .d),
//                StaffNote(type: .whole, octave: 4, pitch: .e),
//                StaffNote(type: .whole, octave: 4, pitch: .f),
                StaffNote(type: .whole, octave: 4, pitch: .g),
//                StaffNote(type: .whole, octave: 4, pitch: .a),
//                StaffNote(type: .whole, octave: 4, pitch: .b),
//                StaffNote(type: .whole, octave: 5, pitch: .c)
            ]
        }
        
        private func calculateNoteLocation(parentFrame: CGSize, octave: Int, pitch: Pitch, noteNumber: CGFloat) -> CGPoint {
            let stepSize = parentFrame.width * 0.05
            let noteStart = parentFrame.width * 0.15
            let x: CGFloat = noteStart + (stepSize * noteNumber)
            
            switch(pitch) {
                case .a:
                    if (octave == 4) {
                        return CGPoint(x: x, y: parentFrame.height * 0.4)
                    }
                case .b:
                    if (octave == 4) {
                        return CGPoint(x: x, y: parentFrame.height * 0.35)
                    }
                case .c:
                    if (octave == 4) {
                        return CGPoint(x: x, y: parentFrame.height * 0.3)
                    }
                case .d:
                    if (octave == 4) {
                        return CGPoint(x: x, y: parentFrame.height * 0.25)
                    }
                case .e:
                    if (octave == 4) {
                        return CGPoint(x: x, y: parentFrame.height * 0.2)
                    }
                case .f:
                    if (octave == 4) {
                        return CGPoint(x: x, y: parentFrame.height * 0.15)
                    }
                case .g:
                    if (octave == 4) {
                        return CGPoint(x: x, y: parentFrame.height * 0.1)
                    }
            }
            
            return CGPoint(x: 0, y: 0)
        }
        
        private func drawHLine(_ a: CGPoint, _ b: CGPoint) -> Path {
            var line = Path()
            line.move(to: CGPoint(x: a.x, y: a.y))
            
            line.addLine(to: CGPoint(x: b.x, y: b.y    ))
            line.addLine(to: CGPoint(x: b.x, y: b.y + 1))
            line.addLine(to: CGPoint(x:  a.x, y: b.y + 1))
            
            return line
        }
        
        private func drawVLine(_ a: CGPoint, _ b: CGPoint) -> Path {
            var line = Path()
            line.move(to: CGPoint(x: a.x, y: a.y))
            
            line.addLine(to: CGPoint(x: b.x,     y: b.y))
            line.addLine(to: CGPoint(x: b.x + 1, y: b.y))
            line.addLine(to: CGPoint(x:  a.x + 1, y: a.y + 1))
            
            return line
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer()
                
                VStack(alignment: .center) {
                    TrebleStaff(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                        .padding(geometry.size.height * 0.01)
                }
                
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewLayout(.fixed(width: 568, height: 320))
            
            ContentView()
                .previewLayout(.fixed(width: 1792, height: 828))
        }
    }
}
