//
//  InfoAtividade.swift
//  HabitTracker
//
//  Created by Rodrigo Cavalcanti on 20/05/21.
//

import SwiftUI

struct InfoAtividade: View {
    @ObservedObject var atividade: Hábito
    var todasAsAtividades: Atividades
    @State private var novaData = Date()
    @State private var novaHora = 1
    private var datasString: [String] {
        transformarDataEmString()
    }
    private var duraçãoMédia: Double {
        média(números: atividade.duração)
    }
    
    func transformarDataEmString() -> [String] {
        var arrayQueRetornará = [String]()
        let formatador = DateFormatter()
        formatador.dateFormat = "yyyy-MM-dd"
        formatador.dateStyle = .long
        for data in atividade.datas {
            arrayQueRetornará.append(formatador.string(from: data))
        }
        return arrayQueRetornará
    }
    
    func média(números: [Int]) -> Double {
        var total: Double = 0
        for i in números {
            total += Double(i)
        }
        return total/Double(números.count)
    }
    
    var body: some View {
        List {
            if atividade.descrição != "" {
                Section(header: Text("Descrição")) {
                    Text(atividade.descrição)
                }
            }
            Section(header: Text("Quando")) {
                ForEach(0..<datasString.count, id: \.self) {numero in
                    Text("\(datasString[numero]) por \(atividade.duração[numero]) hora\(atividade.duração[numero] > 1 ? "s" : "")")
                }
            }
            
            Section(header: Text("Frequência")) {
                Text("\(atividade.quantidade) vez\(atividade.quantidade > 1 ? "es": "")")
            }
            
            Section(header: Text("Tempo médio da atividade")) {
                Text("\(duraçãoMédia, specifier: "%g") hora\(duraçãoMédia > 1 ? "s" : "")")
            }
            
            Section(header: Text("Adicionar nova atividade")) {
                Picker("Selecione a duração", selection: $novaHora) {
                    ForEach(1...12, id: \.self) {
                        Text("\($0) hora\($0 > 1 ? "s" : "")")
                    }
                    .pickerStyle(InlinePickerStyle())
                }
                DatePicker("Selecione uma data", selection: $novaData, displayedComponents: .date)
                Button(action: {
                    self.atividade.datas.append(novaData)
                    atividade.duração.append(novaHora)
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(todasAsAtividades.atividade) {
                        UserDefaults.standard.set(encoded, forKey: "Atividade")
                    }
                }, label: {
                    Text("Adicionar")
                })
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(atividade.nome)
    }
}

struct InfoAtividade_Previews: PreviewProvider {
    static var previews: some View {
        InfoAtividade(atividade: Hábito(nome: "Atividade", descrição: "Descrição", datas: [Date](), duração: [1]), todasAsAtividades: Atividades())
    }
}
