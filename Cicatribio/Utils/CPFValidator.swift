////
////  CPFValidator.swift
////  Cicatribio
////
////  Created by Gustavo Costa on 31/10/23.
////
//
//import Foundation
//
//func isValidCPF(_ cpf: String?) -> Bool {
//    guard let cpf = cpf else { return false }
//    
//    // Remova caracteres não numéricos e verifique se o CPF tem 11 dígitos
//    let cleanedCPF = cpf.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
//    guard cleanedCPF.count == 11 else { return false }
//    
//    // Verifique se todos os dígitos são iguais (CPF inválido se forem)
//    let firstDigit = cleanedCPF.first!
//    if Set(cleanedCPF).count == 1 {
//        return false
//    }
//    
//    // Cálculo dos dígitos verificadores
//    let digits = cleanedCPF.map { Int(String($0))! }
//    let firstCheckDigit = cpfDigit(for: Array(digits.prefix(9)))
//    let secondCheckDigit = cpfDigit(for: Array(digits.prefix(9) + [firstCheckDigit]))
//    
//    // Verifique se os dígitos verificadores correspondem
//    return firstCheckDigit == digits[9] && secondCheckDigit == digits[10]
//}
//
//    // Função para calcular um dígito verificador do CPF
//    func cpfDigit(for digits: [Int]) -> Int {
//        var sum = 0
//        for (index, digit) in digits.enumerated() {
//            sum += digit * (digits.count + 1 - index)
//        }
//        let remainder = sum % 11
//        return remainder < 2 ? 0 : 11 - remainder
//    }
//
//    // Função para exibir uma mensagem de alerta
//    func showAlert(message: String) {
//        let alertController = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        present(alertController, animated: true, completion: nil)
//    }
