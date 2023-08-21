//
//  ContentView.swift
//  Moonshot
//
//  Created by Prakhar Trivedi on 6/3/23.
//

import SwiftUI

enum ListType {
    case grid, list
}

struct SetupEnvironment: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .background(.darkBackground)
            .preferredColorScheme(.dark)
    }
    
    init(_ title: String) {
        self.title = title
    }
}

extension View {
    func setupEnvironment(withTitle title: String) -> some View {
        modifier(SetupEnvironment(title))
    }
}

struct MissionGridCell: View {
    let mission: Mission
    let astronauts: [String: Astronaut]
    
    var body: some View {
        NavigationLink {
            MissionView(mission: mission, astronauts: astronauts)
        } label: {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                
                VStack {
                    Text(mission.displayName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(mission.formattedLaunchDate)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(.lightBackground) // Our custom color from Color-Theme.swift
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.lightBackground)
            )
        }
    }
}

struct MissionListCell: View {
    let mission: Mission
    let astronauts: [String: Astronaut]
    
    var body: some View {
        NavigationLink {
            MissionView(mission: mission, astronauts: astronauts)
        } label: {
            HStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.vertical)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(mission.displayName)
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                    
                    Text(mission.formattedLaunchDate)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(20)
    }
}

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    @State var showingAs: ListType = .grid
    
    var body: some View {
        NavigationView {
            if showingAs == .grid {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(missions) { mission in
                            MissionGridCell(mission: mission, astronauts: astronauts)
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
                .setupEnvironment(withTitle: "Moonshot")
                .toolbar {
                    Button {
                        if showingAs == .grid {
                            withAnimation {
                                showingAs = .list
                            }
                        } else {
                            withAnimation {
                                showingAs = .grid
                            }
                        }
                    } label: {
                        Image(systemName: showingAs == .grid ? "list.bullet": "square.grid.3x3")
                    }
                }
            } else {
                ScrollView(.vertical) {
                    ForEach(missions) { mission in
                        MissionListCell(mission: mission, astronauts: astronauts)
                    }
                }
                .setupEnvironment(withTitle: "Moonshot")
                .toolbar {
                    Button {
                        if showingAs == .grid {
                            withAnimation {
                                showingAs = .list
                            }
                        } else {
                            withAnimation {
                                showingAs = .grid
                            }
                        }
                    } label: {
                        Image(systemName: showingAs == .grid ? "list.bullet": "square.grid.3x3")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
