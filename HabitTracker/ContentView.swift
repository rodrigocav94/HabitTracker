//
//  ContentView.swift
//  HabitTracker
//
//  Created by Rodrigo Cavalcanti on 20/05/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var atividades = Atividades()
    @State private var mostrandoSheet = false
    
    func removerLinha(at offsets: IndexSet) {
        atividades.atividade.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(atividades.atividade) {atividade in
                    NavigationLink(destination: InfoAtividade(atividade: atividade, todasAsAtividades: self.atividades)) {
                        Text("\(atividade.nome)")
                    }
                }
                .onDelete(perform: removerLinha)
            }
            .navigationBarTitle(Text("Rastreador de Hábitos"))
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { mostrandoSheet.toggle() }, label: {
                        Image(systemName: "plus")
                    })
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    if atividades.atividade.count > 0 {
                        EditButton()
                    }
                }
            })
        }
        .sheet(isPresented: $mostrandoSheet) {
            NovaAtividade(todasAsAtividades: atividades)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
