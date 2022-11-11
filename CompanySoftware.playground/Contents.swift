import Foundation

enum MaritalStatus : String {
    
    case Evli = "Evli"
    case Bekar = "Bekar"
}

enum EmloyeeStatus : Double { // Çalışan statüsüne göre maaş katsayısı
    
    case Junior = 1
    case Middle = 1.5
    case Senior = 2
}

struct Employee {
    
    var name: String
    var maritalStatus: MaritalStatus
    var middleName: String? // Optional kullanımı
    var surName: String
    var age: Int
    var employeeStatus: EmloyeeStatus
    var fullName: String {  // Computed Property kullanımı
        get {
        if let withMiddleName = middleName { // Optional kullanımı
            return name + withMiddleName + surName
        } else {
            return name + surName
        }
        }}
}

protocol CompanyProtocol {
    
    var name: String {get set}
    var budget: Double {get set}
    var yearOfFoundation: Int {get set}
    var employee: [Employee] {get set} // Şirket oluştururken minimum bir çalışan olmalı
    
    func addRevenue(revenue: Double) // Şirkete gelir ekleme
    func addExpense(expense: Double) // Şirkete gider ekleme
    func addEmployee(employee: [Employee]) // Şirkete çalışan ekleme
    func makeSalaryPayment() -> (Bool) // Yeteri kadar bütçe varsa ödeme yapılır true döner yoksa false döner
    func getTotalSalaryPayment() -> (Double) // Ödenmesi gereken toplam maaşı getirir
}

class Company : CompanyProtocol {
    
    var name: String
    var budget: Double
    var yearOfFoundation: Int
    var employee: [Employee]
    
    init(name: String, budget: Double, yearOfFoundation: Int, employee: [Employee]){
    
        self.name = name
        self.budget = budget
        self.yearOfFoundation = yearOfFoundation
        self.employee = employee
        print("Şirket başarıyla oluşturuldu.")
    }
    
    func addRevenue(revenue: Double) {
        print("Bütçe \(budget) idi. \(revenue) ₺ gelir olarak eklendi. Yeni bütçe : \(budget + revenue)")
        budget += revenue
    }
    
    func addExpense(expense: Double) {
        print("Bütçe \(budget) idi. \(expense) ₺ gider olarak eklendi. Yeni bütçe : \(budget - expense)")
        budget -= expense
    }
    
    func addEmployee(employee: [Employee]) {
        self.employee += employee
        print("Çalışan(lar) başarıyla eklendi.")
    }
    
    var calculateSalaryForEmployee : (Int,Double) -> Double = { // Closure Kullanımı (Her çalışana göre maaşını hesaplar.)
        return Double($0) * $1 * 1000
    }
    
    func getTotalSalaryPayment() -> (Double) {
        
        var total : Double = 0
        
        for i in 0..<employee.count {
            total += calculateSalaryForEmployee(employee[i].age, employee[i].employeeStatus.rawValue)
        }
        print("Toplam maaş ödemesi : \(total) ₺ şirketin kasasındaki para : \(budget) ₺")
        return total
    }
    
    func makeSalaryPayment() -> (Bool) {
        
        var totalSalaryPayment = getTotalSalaryPayment()
        
        if (budget >= totalSalaryPayment){
            budget -= totalSalaryPayment
            print("Ödeme başarıyla yapıldı. Kalan para : \(budget) ₺")
            return true
        } else {
            print("Kasada yeterli para yok. Ödeme yapılamadı.")
            return false
        }
    }
}


// ---------------------------------------------------------------  ÇALIŞTIRMA KISMI ----------------------------------------------------------------------------------------
 
var company : Company = Company(name: "Ahmet", budget: 128000, yearOfFoundation: 1996, employee: [Employee(name: "Ahmet", maritalStatus: .Bekar, surName: "Gokdemir", age: 25, employeeStatus: .Junior),Employee(name: "Selin", maritalStatus: .Bekar, surName: "Deniz", age: 22, employeeStatus: .Middle)])
company.addRevenue(revenue: 5000)
company.addExpense(expense: 4000)
company.addEmployee(employee: [Employee(name: "Ceren", maritalStatus: .Evli, surName: "Dere", age: 35, employeeStatus: .Senior)])
company.makeSalaryPayment()
