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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ocupationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    
    
    let sexPickerView = UIPickerView()
    let sexPickerToolbar = UIToolbar()
    
    var sex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        CPFTextField.addTarget(self, action: #selector(cpfTextFieldDidChange), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange), for: .editingChanged)
        
        sexPickerView.delegate = self
        sexPickerView.dataSource = self
        
        // Configurar o UIToolbar
        sexPickerToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Concluído", style: .done, target: self, action: #selector(doneSexPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        sexPickerToolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        // Atribuir o UIPickerView como inputView para sexTextField
        sexTextField.inputView = sexPickerView
        sexTextField.inputAccessoryView = sexPickerToolbar
    }
    @IBAction func pressSaveButton(_ sender: UIButton) {
        
        guard let cpf = CPFTextField.text, cpf.isCPF else {
            print("CPF inválido")
            self.view.showToast(message: "Favor insira um CPF válido", isSuccess: false)
            return
        }

        // Validação do campo de telefone
        guard let phone = phoneTextField.text, isValidPhoneNumber(phone) else {
            self.view.showToast(message: "Favor insira um telefone válido", isSuccess: false)
            return
        }
        
        guard let email = emailTextField.text, email.isEmail else {
            self.view.showToast(message: "Favor insira um email válido", isSuccess: false)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        let patientData: [String: Any] = [
            "no_completo": nameTextField.text!,
            "nu_cpf": cpf, // Certifique-se de validar o CPF antes da conversão
            "nu_telefone_completo": phone, // Certifique-se de validar o telefone antes da conversão
            "ds_sexo": Int(sexTextField.text!) ?? 0,
            "ds_cor_raca": NSNull(), // Certifique-se de validar o valor de cor/raça antes da conversão
            "ds_ocupacao": ocupationTextField.text!,
            "ds_email": email,
            "dt_nascimento": dateString
        ]

        if CPFTextField.text!.isCPF {
            apiManager.postData(endpoint: "pacientes", postData: patientData, dataType: PatientsData.self) { (data, error) in
                if let error {
                    print("Erro ao cadastrar usuário", error)
                    DispatchQueue.main.async {
                        self.view.showToast(message: "Erro ao cadastrar usuário", isSuccess: false)
                    }
                } else if data != nil {
                    DispatchQueue.main.async {
                        self.view.showToast(message: "Paciente cadastrado com sucesso", isSuccess: true)
                        self.clearFields()
                    }

                }
            }
        } else {
            self.view.showToast(message: "CPF inválido. Por favor, insira um CPF válido.", isSuccess: false)
        }
    }

    func clearFields() {
        nameTextField.text = ""
        CPFTextField.text = ""
        datePicker.date = Date()
        emailTextField.text = ""
        ocupationTextField.text = ""
        phoneTextField.text = ""
        sexTextField.text = ""
        sex = nil
    }
    
    @objc func cpfTextFieldDidChange() {
        if let text = CPFTextField.text {
            // Remover caracteres não numéricos (como espaços e traços)
            let numericText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            if numericText.count == 11 {
                if numericText.isCPF {
                    CPFTextField.text = formattedCPF(numericText)
                } else {
                    print("CPF inválido")
                }
            }
        }
    }
    
    func formattedCPF(_ cpf: String) -> String {
        let formattedCPF = "\(cpf.prefix(3)).\(cpf.dropFirst(3).prefix(3)).\(cpf.dropFirst(6).prefix(3))-\(cpf.suffix(2))"
        return formattedCPF
    }
    
    @objc func phoneTextFieldDidChange() {
        if let text = phoneTextField.text {
            let numericText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            if numericText.count > 11 {
                phoneTextField.text = String(numericText.prefix(11))
            }
            
            if numericText.count == 11 {
                let formattedPhoneNumber = "(\(numericText.prefix(2))) \(numericText.dropFirst(2).prefix(5))-\(numericText.dropFirst(7))"
                phoneTextField.text = formattedPhoneNumber
            }
        }
    }
    
    func isValidPhoneNumber(_ phone: String) -> Bool {
        let numericText = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Verificar se o número de telefone tem 11 dígitos
        if numericText.count != 11 {
            return false
        }
        
        // Verificar se todos os caracteres são numéricos
        if let _ = Int(numericText) {
            // Formatar como (XX) XXXXX-XXXX
            let formattedPhoneNumber = "(\(numericText.prefix(2))) \(numericText.dropFirst(2).prefix(5))-\(numericText.dropFirst(7))"
            phoneTextField.text = formattedPhoneNumber
            return true
        } else {
            return false
        }
    }
}

extension RegisterPatientViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2 // Dois itens: "Masculino" e "Feminino"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "Feminino" : "Masculino"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sex = row
    }
    
    @objc func doneSexPicker() {
        if let selectedSex = sex {
            sexTextField.text = selectedSex == 0 ? "Feminino" : "Masculino"
            sex = selectedSex
        }
        sexTextField.resignFirstResponder()
    }
}
