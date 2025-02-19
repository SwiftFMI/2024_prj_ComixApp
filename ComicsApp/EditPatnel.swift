
import SwiftUI
import PhotosUI

struct EditPatnel: View {//patnel=panel :(, greshka v burzaneto
    //@State var patern = ComicsPatern(count: 1, originals: [])
    @State var countSnimki = 1
    @State var snimki: [PhotosPickerItem] = []
    @State var selectedImages: [UIImage] = []
    @State var layers: [PhotoLayer] = []
    @State var oformlenie: [[String]] = [
        ["По подразбиране"],
        ["Една до друга", "Една под друга"],
        ["Една до друга", "Една под друга", "Една горе и две долу", "Една долу и две горе", "Една вляво и две вдясно", "Една вдясно и две вляво"]
    ]
    
    
    //Kodut za gradientite ot tuk:
    //https://www.youtube.com/watch?v=_lsnGyF2WZg
    
    
    @State var appear = false
    @State var appear2 = false
    

        var body: some View {
            ZStack {
                //background gradientut
                MeshGradient(
                    width: 3, height: 3,
                    points: [
                        [0.0, 0.0], [appear2 ? 0.5 : 1.0, 0.0], [1.0, 0.0],
                        [0.0, 0.5], appear ? [0.1, 0.5] : [0.8, 0.2], [1.0, -0.5],
                        [0.0, 1.0], [1.0, appear2 ? 1.5 : 1.0], [1.0, 1.0]
                    ],
                    colors: [
                        appear2 ? .red.opacity(0.5) : .mint.opacity(0.5), appear2 ? .yellow.opacity(0.5) : .cyan.opacity(0.5),
                        .orange,
                        appear ? .blue.opacity(0.5) : .red.opacity(0.5), appear ? .cyan.opacity(0.5) : .white.opacity(0.5), appear ? .red.opacity(0.5) : .purple.opacity(0.5),
                        appear ? .red.opacity(0.5): .cyan.opacity(0.5), appear ? .mint.opacity(0.5) : .blue.opacity(0.5), appear ? .red.opacity(0.5) : .blue.opacity(0.5)
                    ]
                )
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                        appear.toggle()
                    }
                    withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                        appear2.toggle()
                    }
                }

                VStack {
                    Text("Edit Panel")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    
                    
                    if countSnimki == 2 {
                        //switch case za grid
                    }
                    
                    
                }
            }
        }
    }
//navigation spkit view za podobriavane na dizaina? ne, uf
