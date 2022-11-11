import Foundation

struct PetSitter {
    
    var id: Int
    var name: String
    var age: Int
    var middleName: String? // Optional kullanımı
    var surName: String
    var yearsOfWorkExperience: Int
    var fullName: String {  // Computed Property kullanımı
        get {
        if let withMiddleName = middleName { // Optional kullanımı
            return name + withMiddleName + surName
        } else {
            return name + surName
        }
        }}
    var responsibleAnimalIds: [Int] // bir bakıcı birden fazla hayvana bakabilir.
}

enum kindOfAnimal : String {
    
    case Cat = "miyavvvv"
    case Dog = "hav hav"
    case Bird = "cik cik"
    case Chicken = "gıt gıt gıdak"
    case Sheep = "meeee"
}

struct Animal {

    var id: Int
    var kind: kindOfAnimal
    var name: String
    var dailyWaterConsumption: Double
    var sitterId: Int // her hayvanın tek bakıcısı olabilir.
}

protocol ZooManagementCompanyProtocol {
    
    var name: String {get set}
    var dailyWaterLimit: Double {get set}
    var dailyLiceBudget: Double {get set}
    var generalBudget: Double {get set} // bit bütçesi dahil değil
    var petSitters: [PetSitter] {get set}
    var animals: [Animal] {get set}
    
    func increaseWaterLimit(kilogram: Double)
    func addRevenue(revenue: Double) // gelir ekleme
    func addExpense(expense: Double) // gider ekleme
    func makeSalaryPayment() -> (Bool) // Yeteri kadar bütçe varsa ödeme yapılır true döner yoksa false döner
    func getTotalSalaryPayment() -> (Double) // Ödenmesi gereken toplam maaşı getirir
    func addPetSitter(petSitter: [PetSitter])
    func addAnimal(animal: [Animal])
    func getAnimalSound(animalId: Int)
    func getDailyWaterLimit() -> (Bool) // Günlük su limiti hayvanların ihtiyacını karşılıyorsa true karşılamıyorsa false döner
}

class ZooManagementCompany : ZooManagementCompanyProtocol {
    
    var name: String
    var dailyWaterLimit: Double
    var dailyLiceBudget: Double
    var generalBudget: Double
    var petSitters: [PetSitter]
    var animals: [Animal]
    
    init(name: String, dailyWaterlimit: Double, dailyLiceBudget: Double, generalBudget: Double, petSitters: [PetSitter], animals: [Animal]){
        
        self.name = name
        self.dailyWaterLimit = dailyWaterlimit
        self.dailyLiceBudget = dailyLiceBudget
        self.generalBudget = generalBudget
        self.petSitters = petSitters
        self.animals = animals
        
        print("Hayvanat bahçesi yönetim sistemi başarıyla oluşturuldu.")
    }
    
    func increaseWaterLimit(kilogram: Double) {
        print("\(dailyWaterLimit) olan günlük su limiti \(kilogram) kilogram arttırılarak toplam \(dailyWaterLimit + kilogram) olmuştur.")
        dailyWaterLimit += kilogram
    }
    
    func addRevenue(revenue: Double) {
        print("\(generalBudget) olan genel bütçe \(revenue) ₺ arttırılarak toplam \(generalBudget + revenue) ₺ olmuştur.")
        generalBudget += revenue
    }
    
    func addExpense(expense: Double) {
        print("\(generalBudget) olan genel bütçe \(expense) ₺ gider eklenerek toplam \(generalBudget - expense) ₺ olmuştur.")
        generalBudget -= expense
    }
    
    func makeSalaryPayment() -> (Bool) {
        
        var totalSalaryPayment = getTotalSalaryPayment()
        if (generalBudget > totalSalaryPayment){
            generalBudget -= totalSalaryPayment
            print("Çalışanların maaş ödemesi başarıyla yapılmıştır. Kalan bütçe \(generalBudget) ₺")
            return true
        } else {
            print("Çalışanların ödemesi yapılamamıştır. Gereken tutar: \(totalSalaryPayment - generalBudget) ₺")
            return false
        }
    }
    
    var calculateSalaryForEmployee : (Int, Int) -> (Double) = {  // Closure kullanımı (Her çalışan için maaşını hesaplar)
        return Double($0 * $1 * 100)
    }
    
    func getTotalSalaryPayment() -> (Double) {
        
        var total: Double = 0
        
        for i in 0..<petSitters.count {
            total += calculateSalaryForEmployee(petSitters[i].age, petSitters[i].yearsOfWorkExperience)
        }
        print("Toplam maaş ödemesi : \(total) ₺ şirketin kasasındaki para : \(generalBudget) ₺")
        return total
        
    }
    
    func addPetSitter(petSitter: [PetSitter]) {
        self.petSitters += petSitter
    }
    
    func addAnimal(animal: [Animal]) {
        print("Hayvanlar")
        self.animals += animal
    }
    
    func getAnimalSound(animalId: Int) {
        for i in 0..<animals.count{
            if (animals[i].id == animalId){
                print(" \(animals[i].name) isimli hayvanın sesi : \(animals[i].kind.rawValue)")
                break
            }
        }
    }
    
    func getDailyWaterLimit() -> (Bool) {
        
        var total: Double = 0
        for i in 0..<animals.count {
            total += animals[i].dailyWaterConsumption
        }
        if (dailyWaterLimit > total){
            print("Toplam su limiti = \(dailyWaterLimit) Hayvanların günlük \(total) litre suyu verilmiştir. Kalan su : \(dailyWaterLimit - total)")
            dailyWaterLimit -= total
            return true
        } else {
           print("Hayvanların suyu verilememiştir. Gereken su miktarı : \(total - dailyWaterLimit)")
            return false
        }
    }
}


// ---------------------------------------------------------------------- ÇALIŞTIRMA -----------------------------------------------------------------------------------

var zooManagementCompany = ZooManagementCompany(name: "Animal Planet", dailyWaterlimit: 5000, dailyLiceBudget: 5000, generalBudget: 100000, petSitters: [PetSitter(id: 12345, name: "David", age: 25, surName: "Smith", yearsOfWorkExperience: 2, responsibleAnimalIds: [1]),PetSitter(id: 12346, name: "Ella", age: 30, surName: "Walker", yearsOfWorkExperience: 5, responsibleAnimalIds: [2])], animals: [Animal(id: 1, kind: .Bird, name: "Boncuk", dailyWaterConsumption: 100, sitterId: 12345),Animal(id: 2, kind: .Cat, name: "Zeytin", dailyWaterConsumption: 200, sitterId: 12346)])
zooManagementCompany.addRevenue(revenue: 8000)
zooManagementCompany.addExpense(expense: 5000)
zooManagementCompany.increaseWaterLimit(kilogram: 200)
zooManagementCompany.addRevenue(revenue: 2000)
zooManagementCompany.getAnimalSound(animalId: 1)
zooManagementCompany.getDailyWaterLimit()
zooManagementCompany.makeSalaryPayment()
