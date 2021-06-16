//
//  NovaAtividade.swift
//  HabitTracker
//
//  Created by Rodrigo Cavalcanti on 20/05/21.
//

import SwiftUI

struct NovaAtividade: View {
    @ObservedObject var todasAsAtividades: Atividades
    @State private var nome = ""
    @State private var descrição = ""
    @State private var duração = 1
    @State private var quando = Date()
    @State private var mostrandoAlerta = false
    @State private var alertaTitulo = ""
    @State private var alertaMensagem = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nome")) {
                    TextField("Insira o nome da atividade", text: $nome)
                }
                Section(header: Text("Descrição")) {
                    TextField("Insira uma descrição", text: $descrição)
                }
                Section(header: Text("Duração")) {
                    Picker("Selecione a duração da atividade", selection: $duração) {
                        ForEach(1...12, id: \.self) { hora in
                            Text("\(hora) hora\(hora > 1 ? "s" : "")")
                        }
                    } .pickerStyle(WheelPickerStyle())
                }
                Section(header: Text("Quando")) {
                    DatePicker("", selection: $quando, displayedComponents: .date)
                        .environment(\.locale, .init(identifier: "pt_BR"))
                }
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .navigationBarTitle(Text("Nova Atividade"))
                .alert(isPresented: $mostrandoAlerta, content: {
                    Alert(title: Text(alertaTitulo), message: Text(alertaMensagem), dismissButton: .default(Text("Continuar")))
                })
            }
            .navigationBarTitle("Nova Atividade")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Adicionar") {
                        if nome == "" {
                            alertaTitulo = "Está faltando o nome"
                            alertaMensagem = "Insira um nome para atividade"
                            mostrandoAlerta.toggle()
                        } else if let _ = todasAsAtividades.atividade.first(where: {$0.nome == nome}) {
                            alertaTitulo = "Atividade repetida"
                            alertaMensagem = "Esta atividade já está presente"
                            mostrandoAlerta.toggle()
                        } else {
                            todasAsAtividades.atividade.append(Hábito(nome: nome, descrição: descrição, datas: [quando], duração: [duração]))
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct NovaAtividade_Previews: PreviewProvider {
    static var previews: some View {
        NovaAtividade(todasAsAtividades: Atividades())
    }
}
