//
//  ViewController.swift
//  DouughApp
//
//  Created by raman singh on 17/01/19.
//  Copyright © 2019 raman singh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsersListViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var usersSegmentControl: UISegmentedControl!
    @IBOutlet weak var usersTableView: UITableView!
    
    //MARK:- Variables
    lazy var userViewModel:UserViewModel = {
        return UserViewModel()
    }()
    
    var disposeBag = DisposeBag()
    
    //MARK:- ViewLife cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

extension UsersListViewController{
    func bindViewModel() {
        _ = usersSegmentControl.rx.selectedSegmentIndex.subscribe( { [weak self] index in
            switch index.element {
            case 0:
                self?.userViewModel.sortUsersByFirstName()
            case 1:
                self?.userViewModel.sortUsersByLastName()
            case 2:
                self?.userViewModel.sortUsersByID()
            default:
                print("Con not Sort Users")
            }
        }).disposed(by: disposeBag)
        
        usersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        _ = userViewModel.newValue.rx_elements().observeOn(MainScheduler.instance)
            .bind(to: usersTableView.rx.items(cellIdentifier: "cell",cellType: UITableViewCell.self)) {  row, element, cell in
                cell.textLabel?.text = "\(String(describing: element.firstName!))"
                return
        }
        
        usersTableView.rx.itemSelected
            .subscribe({ [weak self] indexPath in
                self?.userViewModel.newValue.remove(at: indexPath.element?.row ?? 0)
            }).disposed(by: disposeBag)
    }
}

