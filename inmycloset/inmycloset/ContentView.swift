import SwiftUI
import MapKit

//
// MARK: - MODEL
//
struct Outfit: Identifiable, Equatable {
    let id: String
    let imageName: String
    let title: String
    let description: String
    let height: CGFloat
}
class AppState: ObservableObject {
    @Published var savedOutfits: [Outfit] = []
}
//
// MARK: - HOME VIEW
//
struct ContentView: View {
    @StateObject var appState = AppState();    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // HERO IMAGE
                ZStack(alignment: .bottomLeading) {
                    Image("closet")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipped()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("inmycloset")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Organize your style")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                }
                
                // MENU CARDS
                VStack(spacing: 20) {
                    
                    NavigationLink(destination: GalleryView().environmentObject(appState)) {
                        HomeCard(
                            title: "my closet",
                            subtitle: "let's take a look",
                            icon: "tshirt"
                        )
                    }
                    
                    NavigationLink(destination: NewPageView().environmentObject(appState)) {
                        HomeCard(
                            title: "inspiration",
                            subtitle: "shop links from your followers",
                            icon: "plus.square"
                        )
                    }
                        
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.systemGroupedBackground))
            }
            .ignoresSafeArea(edges: .top)
        }
    }


//
// MARK: - INSPIRATION PAGE (SAVED OUTFITS)
//
struct NewPageView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            
            if appState.savedOutfits.isEmpty {
                
                VStack(spacing: 20) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No Saved Inspiration Yet")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Save outfits from My Closet to see them here.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 100)
                
            } else {
                
                HStack(alignment: .top, spacing: 20) {
                    
                    VStack(spacing: 20) {
                        ForEach(leftColumn) { outfit in
                            OutfitCardView(outfit: outfit)
                        }
                    }
                    
                    VStack(spacing: 20) {
                        ForEach(rightColumn) { outfit in
                            OutfitCardView(outfit: outfit)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Inspiration")
    }
    
    // LEFT COLUMN
    var leftColumn: [Outfit] {
        appState.savedOutfits.enumerated().compactMap { index, item in
            index % 2 == 0 ? item : nil
        }
    }
    
    // RIGHT COLUMN
    var rightColumn: [Outfit] {
        appState.savedOutfits.enumerated().compactMap { index, item in
            index % 2 != 0 ? item : nil
        }
    }
}

//
// MARK: - GALLERY (PINTEREST STYLE)
//
struct GalleryView: View {
    
    let outfits = [
        Outfit(id: "1", imageName: "outfit1", title: "Casual Fit", description: "Comfy everyday outfit.", height: 180),
        Outfit(id: "2", imageName: "outfit2", title: "Night Out", description: "Perfect for going out.", height: 260),
        Outfit(id: "3", imageName: "outfit3", title: "Workout", description: "Gym-ready look.", height: 200),
        Outfit(id: "4", imageName: "outfit4", title: "Formal", description: "Dressy outfit for events.", height: 300),
        Outfit(id: "5", imageName: "outfit1", title: "Streetwear", description: "Trendy casual look.", height: 220),
        Outfit(id: "6", imageName: "outfit2", title: "Brunch Fit", description: "Cute daytime outfit.", height: 240),
        Outfit(id: "7", imageName: "outfit3", title: "Sporty", description: "Activewear vibe.", height: 170),
        Outfit(id: "8", imageName: "outfit4", title: "Date Night", description: "Cute and stylish.", height: 280)
    ]
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: 20) {
                
                VStack(spacing: 20) {
                    ForEach(leftColumn) { outfit in
                        OutfitCardView(outfit: outfit)
                    }
                }
                
                VStack(spacing: 20) {
                    ForEach(rightColumn) { outfit in
                        OutfitCardView(outfit: outfit)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .navigationTitle("My Closet")
    }
    
    var leftColumn: [Outfit] {
        outfits.enumerated().compactMap { index, item in
            index % 2 == 0 ? item : nil
        }
    }
    
    var rightColumn: [Outfit] {
        outfits.enumerated().compactMap { index, item in
            index % 2 != 0 ? item : nil
        }
    }
}

//
// MARK: - OUTFIT CARD (FIXED LIKE BUTTON)
//
struct OutfitCardView: View {
    let outfit: Outfit
    @EnvironmentObject var appState: AppState
    @State private var isLiked = false
    
    var body: some View {
        NavigationLink(destination: OutfitDetailView(outfit: outfit)) {
            
            VStack(alignment: .leading, spacing: 8) {
                
                ZStack(alignment: .topTrailing) {
                    
                    Image(outfit.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: outfit.height)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.42)
                        .clipped()
                        .cornerRadius(12)
                    
                    Button(action: {
                        if appState.savedOutfits.contains(where: { $0.id == outfit.id }) {
                            appState.savedOutfits.removeAll { $0.id == outfit.id }
                        } else {
                            appState.savedOutfits.append(outfit)
                        }
                    }) {
                        Image(systemName:
                            appState.savedOutfits.contains(where: { $0.id == outfit.id }) ? "bookmark.fill" : "bookmark"
                        )
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                    }
                    .padding(8)
                }
                        Image(systemName:
                            appState.savedOutfits.contains(where: { $0.id == outfit.id }) ? "bookmark.fill" : "bookmark"
                        )
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(8)
                }
                
                Text(outfit.title)
                    .font(.headline)
                
                Text(outfit.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: {
                    isLiked.toggle()
                }) {
                    HStack {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                        Text("Like")
                    }
                    .font(.subheadline)
                    .foregroundColor(isLiked ? .pink : .black)
                }
                
            }
        }



//
// MARK: - DETAIL VIEW
//
struct OutfitDetailView: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(outfit.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(12)
            
            Text(outfit.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(outfit.description)
                .font(.body)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Outfit Details")
    }
}

//
// MARK: - HOME CARD
//
struct HomeCard: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: icon)
                .font(.title)
                .frame(width: 50, height: 50)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}
struct SavedView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: 20) {
                
                VStack(spacing: 20) {
                    ForEach(leftColumn) { outfit in
                        OutfitCardView(outfit: outfit)
                    }
                }
                
                VStack(spacing: 20) {
                    ForEach(rightColumn) { outfit in
                        OutfitCardView(outfit: outfit)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .navigationTitle("Saved")
    }
    
    // LEFT COLUMN
    var leftColumn: [Outfit] {
        appState.savedOutfits.enumerated().compactMap { index, item in
            index % 2 == 0 ? item : nil
        }
    }
    
    // RIGHT COLUMN
    var rightColumn: [Outfit] {
        appState.savedOutfits.enumerated().compactMap { index, item in
            index % 2 != 0 ? item : nil
        }
    }
}
//
// MARK: - PREVIEW
struct InspirationPostView: View {
let outfit: Outfit

@EnvironmentObject var appState: AppState
@State private var isLiked = false
@State private var note = ""
@State private var notes: [String] = []
@State private var showNotes = false

var body: some View {
    VStack(alignment: .leading, spacing: 12) {
        
        Image(outfit.imageName)
            .resizable()
            .scaledToFill()
            .frame(height: 300)
            .clipped()
            .cornerRadius(12)
        
        Text(outfit.title)
            .font(.headline)
        
        Text(outfit.description)
            .font(.subheadline)
            .foregroundColor(.gray)
        
        HStack(spacing: 20) {
            
            // LIKE             Button {
            Button(action: {
                isLiked.toggle()
            }) {
                HStack {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                    Text("Like")
                }
                .font(.subheadline)
                .foregroundColor(isLiked ? Color.pink.opacity(0.6) : .black)
            }
            
            // SAVE
            Button {
                if appState.savedOutfits.contains(where: { $0.id == outfit.id }) {
                    appState.savedOutfits.removeAll { $0.id == outfit.id }
                } else {
                    appState.savedOutfits.append(outfit)
                }
            } label: {
                Image(systemName:
                    appState.savedOutfits.contains(where: { $0.id == outfit.id }) ? "bookmark.fill" : "bookmark"
                )
            }
            
            // NOTES
            Button {
                showNotes.toggle()
            } label: {
                Image(systemName: "bubble.right")
            }
        }
        .font(.title3)
        
        if showNotes {
            VStack(alignment: .leading) {
                ForEach(notes, id: \.self) { n in
                    Text("• \(n)")
                }
                
                HStack {
                    TextField("Add note...", text: $note)
                    Button("Post") {
                        if !note.isEmpty {
                            notes.append(note)
                            note = ""
                        }
                    }
                }
            }
            .padding(.top, 8)
        }
    }
}
}
