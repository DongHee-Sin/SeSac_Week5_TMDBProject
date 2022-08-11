//
//  MapViewController.swift
//  SeSacTMDBProject
//
//  Created by 신동희 on 2022/08/11.
//

import UIKit

import MapKit
import CoreLocation

class MapViewController: UIViewController, CommonSetting {

    static let identifier = String(describing: MapViewController.self)
    
    // MARK: - Property, Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    let sesacCoordinate = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
    
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialUI()
    }
    
    
    
    // MARK: - Methods
    func configureInitialUI() {
        locationManager.delegate = self
        
        setNavigationBarButton()
        
        setRegion(center: sesacCoordinate)
        setAnnotations(theaters: TheaterList().mapAnnotations)
    }
    
    
    func setNavigationBarButton() {
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = .darkGray
        self.navigationItem.leftBarButtonItem = dismissButton
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func filterButtonTapped() {
        let filterActionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let megabox = UIAlertAction(title: "메가박스", style: .default) { [weak self] _ in
            self?.setAnnotations(theaters: TheaterList().mapAnnotations, type: .메가박스)
        }
        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { [weak self] _ in
            self?.setAnnotations(theaters: TheaterList().mapAnnotations, type: .롯데시네마)
        }
        let cgv = UIAlertAction(title: "CGV", style: .default) { [weak self] _ in
            self?.setAnnotations(theaters: TheaterList().mapAnnotations, type: .CGV)
        }
        let all = UIAlertAction(title: "전체보기", style: .default) { [weak self] _ in
            self?.setAnnotations(theaters: TheaterList().mapAnnotations)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [megabox, lotte, cgv, all, cancel].forEach { filterActionSheetController.addAction($0) }
        
        present(filterActionSheetController, animated: true)
    }
}




// MARK: - MapView 관련 User Defined 메서드
extension MapViewController {
    
    // 사용자에게 보여지는 영역 변경
    func setRegion(center: CLLocationCoordinate2D) {
        // center(중심)를 기반으로 사용자에게 보여줄 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    func setAnnotations(theaters: [Theater], type: TheaterType? = nil) {
        removeAllAnnotation()
        if let theaterType = type {
            theaters.filter { $0.type == type }.forEach { theater in
                setAnnotation(theater: theater)
            }
        }else {
            theaters.forEach { theater in
                setAnnotation(theater: theater)
            }
        }
    }
    
    
    func setAnnotation(theater: Theater) {
        let coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
        setAnnotation(title: theater.type.rawValue, subTitle: theater.location, coordinate: coordinate)
    }
    
    
    // map에 핀(annotation) 추가
    func setAnnotation(title: String?, subTitle: String?, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subTitle
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
    
    
    func removeAllAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
    }
}




// MARK: - 위치 관련 User Defined 메서드
extension MapViewController {
    
    // 사용자 디바이스가 위치 서비스를 활성화하고 있는지 여부를 확인하여 분기처리
    func checkUserDeviceLocationServiceAuthorization() {
        
        // 사용자 디바이스의 위치 서비스 활성화 여부 확인하고, 활성화 상태인 경우에만 권한 요청
        guard CLLocationManager.locationServicesEnabled() else {
            print("사용자 디바이스의 위치 서비스가 비활성화 상태로, 앱 내의 위치 권한 요청을 할 수 없습니다.")
            return
        }
        
        // 앱의 위치 서비스 사용 권한을 열거형으로 나타낸다.
        let authorizationStatus: CLAuthorizationStatus
        
        // locationManager를 통해 앱의 위치 서비스 권한을 조회하여 authorizationStatus에 저장
        // iOS 14.0을 기점으로 권한 상태를 받아오는 코드가 변경되어 분기처리가 필요
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // authorizationStatus 기반으로 분기처리 수행하는 메서드 호출
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    
    // 앱에 대한 사용자의 위치 권한 상태를 기반으로 분기처리 (사용자 디바이스의 위치 서비스가 활성화 상태인지 여부 파악이 선행되어야 함)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("Not Determined : 권한 설정 여부를 사용자가 선택하지 않은 상태")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest    // 위치 서비스의 정확도 설정
            locationManager.requestWhenInUseAuthorization()              // 위치 서비스 권한 요청 (info.plist에 등록 필수!)
            
        case .restricted:
            print("Restricted : 앱의 위치 권한 자체가 없는 경우 / 자녀 보호 기능같은 이유로 기능이 제한된 상황")
        case .denied:
            print("Denied : 위치 권한을 허용하지 않은 상태 또는 시스템 설정에서 전역적으로 권한을 비활성화한 상황")
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            print("Authorized When In Use : 앱이 포그라운드 상태인 경우에만 위치 서비스 허용")
            
            // startUpdatingLocation()를 실행시켜서 위치 정보를 업데이트 받도록 설정하면
            // CLLocationManagerDelegate의 Method, didUpdateLocations를 통해 업데이트된 정보를 처리할 수 있게 된다.
            locationManager.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
    
    
    // 위치 서비스 권한 요청 : 커스텀 얼럿
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
}




// MARK: - CLLocationManager Delegate Protocol
extension MapViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가져온 경우 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 사용자 위치를 매개변수로 받아서 사용
        // ex) 위치 기반으로 날씨를 조회하거나, 지도를 다시 세팅하는 등의 처리
        
        if let coordinate = locations.last?.coordinate {
            setRegion(center: coordinate)
        }
        
        // CLLocationManager는 startUpdatingLocation을 한번 실행시키면, 지속적으로 업데이트 시킴 (멈출때까지)
        // 반복 실행한다고 중복되는 문제는 없음. 다만, 적당한 시점에 stop을 명시적으로 실행시키지 않으면 리소스를 계속 잡아먹는 문제가 있음
        // 동작하는 동안에는 실제 디바이스의 위치가 변경되었을 때 변경된 위치로 업데이트됨
        locationManager.stopUpdatingLocation()
    }
    
    
    // 사용자의 위치를 가져오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    
    // 사용자의 권한 상태가 변경될 때 호출되는 메서드 (iOS 14 ~)
    // 권한 상태 변경 뿐만 아니라, CLLocationManager의 인스턴스가 생성되는 시점에도 호출된다.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 인스턴스가 생성되거나, 권한 상태가 변경되면 => 다시 권한을 조회하고, 필요한 경우 권한 요청
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // 권한 상태가 변경되면 호출 (iOS 14 미만에서 사용)
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print(#function)
//    }
}
