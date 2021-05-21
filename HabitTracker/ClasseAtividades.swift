//
//  Atividades.swift
//  HabitTracker
//
//  Created by Rodrigo Cavalcanti on 20/05/21.
//

import Foundation

class Atividades: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case atividade
    }
    @Published var atividade = [Hábito]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(atividade) {
                UserDefaults.standard.set(encoded, forKey: "Atividade")
            }
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        atividade = try container.decode([Hábito].self, forKey: .atividade)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(atividade, forKey: .atividade)
    }
    
    init() {
            if let atividade = UserDefaults.standard.data(forKey: "Atividade") {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([Hábito].self, from: atividade) {
                    self.atividade = decoded
                    return
                }
            }
            self.atividade = []
        }
    }


class Hábito: Identifiable, ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case datas
        case duração
        case nome
        case descrição
    }
    var id = UUID()
    var nome = ""
    var descrição = ""
    var quantidade: Int {
        datas.count
    }
    @Published var datas = [Date]()
    @Published var duração = [Int]()
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        datas = try container.decode([Date].self, forKey: .datas)
        duração = try container.decode([Int].self, forKey: .duração)
        nome = try container.decode(String.self, forKey: .nome)
        descrição = try container.decode(String.self, forKey: .descrição)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(datas, forKey: .datas)
        try container.encode(duração, forKey: .duração)
        try container.encode(nome, forKey: .nome)
        try container.encode(descrição, forKey: .descrição)
    }
    
    init(nome: String, descrição: String, datas: [Date], duração: [Int]) {
        self.nome = nome
        self.descrição = descrição
        self.datas = datas
        self.duração = duração
    }
}
