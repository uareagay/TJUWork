//
//  ScheduleViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/19.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit
import FSCalendar
import MJRefresh
import SwiftMessages

class ScheduleViewController: UIViewController {
    
    fileprivate var calendar: FSCalendar!
    fileprivate var tableView: UITableView!
    fileprivate var calendarLists: WorkCalendarModel!
    fileprivate var selectedList: [WorkCalendarData] = []
    fileprivate var messageDisplay: [Date] = []
    
    fileprivate var selectedDate: Date {
        didSet {
            let tomorrowDate = Date(timeInterval: 24*60*60, since: selectedDate)
            guard self.calendarLists != nil else {
                return
            }
            self.selectedList = self.calendarLists.data.filter({ data in
                if self.selectedDate <= data.to &&  tomorrowDate > data.to {
                    return true
                } else {
                    return false
                }
            })
            self.tableView.reloadData()
        }
    }
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: 80, height: 30))
        label.text = "当日事件"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x00518e)
        return label
    }()
    
    fileprivate let dateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: (UIScreen.main.bounds.size.width-20)*2/3, y: 15, width: 100, height: 20))
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY / MM / dd"
        label.text = formatter.string(from: Date())
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.textAlignment = .right
        label.textColor = UIColor(hex6: 0x8db6d4)
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let currentCalendar = Calendar.current
        let components = currentCalendar.dateComponents([.year, .month, .day], from: Date())
        let currentDate = currentCalendar.date(from: components)!
        self.selectedDate = currentDate
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentLoginView), name: NotificationName.NotificationLoginFail.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(headerRefresh), name: NotificationName.NotificationRefreshCalendar.name, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleMessageTableViewCell.self, forCellReuseIdentifier: "ScheduleMessageTableViewCell")
        tableView.estimatedRowHeight = 65
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UITableView(frame: CGRect.zero, style: .grouped).backgroundColor
        self.view.addSubview(tableView)
        self.view.backgroundColor = .gray
        
        calendar = FSCalendar(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.size.width-20, height: 250))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerTitleColor = UIColor(hex6: 0x8db6d4)
        calendar.appearance.weekdayTextColor = UIColor(hex6: 0x8db6d4)
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.placeholderType = .none
        calendar.appearance.todayColor = .gray
        calendar.bottomBorder.backgroundColor = .clear
        calendar.setValue(nil, forKey: "topBorder")
        calendar.backgroundColor = .white
        calendar.layer.masksToBounds = true
        calendar.layer.cornerRadius = 10
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        
        AccountManager.getToken(username: WorkUser.shared.username, password: WorkUser.shared.password, success: { token in
            WorkUser.shared.token = token
            print(token)
            WorkUser.shared.save()
            //SwiftMessages.showSuccessMessage(title: "登录成功", body: "")
           self.tableView.mj_header.beginRefreshing()
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: "您似乎已断开与互联网连接", body: "")
            } else {
                SwiftMessages.showErrorMessage(title: "请重新登录", body: "")
            }
            NotificationCenter.default.post(name: NotificationName.NotificationLoginFail.name, object: nil)
        })
        
        
        
        //self.tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "日程"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    @objc func headerRefresh() {
        PersonalMessageHelper.getCalendarList(success: { model in
            self.calendarLists = model
            
            let currentCalendar = Calendar.current
            let datas = model.data
            self.messageDisplay = []
            for i in 0..<datas.count {
                let deadline = datas[i].to
                let components = currentCalendar.dateComponents([.year, .month, .day], from: deadline)
                let currentDate = currentCalendar.date(from: components)!
                self.messageDisplay.append(currentDate)
            }
            
            let tomorrowDate = Date(timeInterval: 24*60*60, since: self.selectedDate)
            self.selectedList = self.calendarLists.data.filter({ data in
                if self.selectedDate <= data.to && tomorrowDate > data.to {
                    return true
                } else {
                    return false
                }
            })
            
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
            
            self.tableView.reloadData()
            self.calendar.reloadData()
        }, failure: {
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
        })
    }
    
    @objc func presentLoginView() {
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
}

extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 50
        }
        return 270
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
            view.backgroundColor = .clear
            let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width-20, height: 50))
            contentView.backgroundColor = .white

            self.titleLabel.removeFromSuperview()
            self.dateLabel.removeFromSuperview()
            contentView.addSubview(titleLabel)
            contentView.addSubview(dateLabel)
            view.addSubview(contentView)
            dateLabel.snp.makeConstraints { make in
                make.top.bottom.right.equalToSuperview().inset(15)
                make.width.equalTo(120)
            }
            
            return view
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 270))
        view.backgroundColor = .clear
        calendar.removeFromSuperview()
        view.addSubview(calendar)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 1 else {
            return 0
        }
        return self.selectedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleMessageTableViewCell") as! ScheduleMessageTableViewCell
        cell.selectionStyle = .none
        
        let data = self.selectedList[indexPath.row]
        cell.titleLabel.text = data.title
        cell.nameLabel.text = data.author
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        cell.dateLabel.text = dateFormatter.string(from: data.to)
        
        return cell
    }
    
}

extension ScheduleViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY / MM / dd"
        self.dateLabel.text = dateFormatter.string(from: date)
        self.selectedDate = date
        
        if let today = self.calendar.today {
            let result = today.compare(date)
            switch result {
            case .orderedSame:
                self.titleLabel.text = "当日事件"
            case .orderedAscending:
                self.titleLabel.text = "未来事件"
            case .orderedDescending:
                self.titleLabel.text = "过去事件"
            }
        }
    }
    
    
}

extension ScheduleViewController: FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var number = 0
        for i in 0..<self.messageDisplay.count {
            if self.messageDisplay[i] == date {
                number += 1
            }
        }
        return number
    }
    
}
