import UIKit
import CoreLocation

// MARK: - User Model
struct User {
    var phoneNumber: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var gender: String = ""
    var age: String = ""
    var college: String = ""
    var hometown: String = ""
    var industry: String = ""
}

// MARK: - First Screen: Phone Number Entry
class PhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.becomeFirstResponder()
    }
    
    @IBAction func joinWaitlistTapped(_ sender: UIButton) {
        // Validate phone number
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            // Present an error to the user
            return
        }
        
        let user = User(phoneNumber: phoneNumber)
        performSegue(withIdentifier: "ShowDetailsSegue", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailsSegue", let detailsVC = segue.destination as? UserDetailsViewController, let user = sender as? User {
            detailsVC.user = user
        }
    }
}

// MARK: - Second Screen: User Details Entry
class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var hometownTextField: UITextField!
    @IBOutlet weak var industryTextField: UITextField!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.becomeFirstResponder()
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        // Validate and store user details
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty else {
            // Present an error to the user
            return
        }
        
        user.firstName = firstName
        user.lastName = lastName
        user.gender = genderTextField.text ?? ""
        user.age = ageTextField.text ?? ""
        user.college = collegeTextField.text ?? ""
        user.hometown = hometownTextField.text ?? ""
        user.industry = industryTextField.text ?? ""
        
        performSegue(withIdentifier: "ShowLocationPermissionSegue", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLocationPermissionSegue", let locationVC = segue.destination as? LocationPermissionViewController, let user = sender as? User {
            locationVC.user = user
        }
    }
}

// MARK: - Third Screen: Location Permission
class LocationPermissionViewController: UIViewController {
    
    var user: User!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    @IBAction func startHavingLunchTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationPermissionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            // Handle case where user denies location services
            break
        case .notDetermined:
            // Request permission
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError("Unhandled case in CLLocationManagerDelegate")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        // Use location for further processing and match the user with others
        // Transition to the next part of the app, possibly the main interface
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle error in getting location
    }
}
