//
//  RegisterPatientViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 25/10/23.
//

import UIKit

class RegisterPatientViewController: UIViewController {

    let apiManager = ApiManager()
    
    static let identifier: String = "RegisterPatientViewController"
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var CPFTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ocupationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        // Do any additional setup after loading the view.
    }
    @IBAction func pressSaveButton(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        let patientData: [String: Any] = [
            "no_completo": nameTextField.text!,
            "nu_cpf": CPFTextField.text!,
            "nu_telefone_completo": phoneTextField.text!,
            "ds_sexo": sexTextField.text!,
            "ds_cor_raca": colorTextField.text!,
            "ds_ocupacao": ocupationTextField.text!,
            "ds_email": emailTextField.text!,
            "dt_nascimento": dateString
        ]
        if isValidCPF(CPFTextField.text) {
            apiManager.postData(endpoint: "pacientes", postData: patientData, dataType: PatientsData.self) { (data, error) in
                if let error {
                    print("Erro ao cadastrar usuário", error)
                } else if let data {
                    print(data)
                }
            }
        } else {
            showAlert(message: "CPF inválido. Por favor, insira um CPF válido.")
        }
    }
    
    func isValidCPF(_ cpf: String?) -> Bool {
        guard let cpf = cpf else { return false }
        
        // Remova caracteres não numéricos e verifique se o CPF tem 11 dígitos
        let cleanedCPF = cpf.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
        guard cleanedCPF.count == 11 else { return false }
        
        // Verifique se todos os dígitos são iguais (CPF inválido se forem)
        let firstDigit = cleanedCPF.first!
        if Set(cleanedCPF).count == 1 {
            return false
        }
        
        // Cálculo dos dígitos verificadores
        let digits = cleanedCPF.map { Int(String($0))! }
        let firstCheckDigit = cpfDigit(for: Array(digits.prefix(9)))
        let secondCheckDigit = cpfDigit(for: Array(digits.prefix(9) + [firstCheckDigit]))
        
        // Verifique se os dígitos verificadores correspondem
        return firstCheckDigit == digits[9] && secondCheckDigit == digits[10]
    }

        // Função para calcular um dígito verificador do CPF
        func cpfDigit(for digits: [Int]) -> Int {
            var sum = 0
            for (index, digit) in digits.enumerated() {
                sum += digit * (digits.count + 1 - index)
            }
            let remainder = sum % 11
            return remainder < 2 ? 0 : 11 - remainder
        }

        // Função para exibir uma mensagem de alerta
        func showAlert(message: String) {
            let alertController = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    
}
