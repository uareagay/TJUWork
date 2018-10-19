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
import EventKit

class ScheduleViewController: UIViewController {
    
    
    fileprivate let eventStore = EKEventStore()
    fileprivate var events: [EKEvent] = []
    
    fileprivate var chineseCalendar: Calendar!
    fileprivate var calendar: FSCalendar!
    fileprivate let lunarDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
    
    fileprivate var tableView: UITableView!
//    fileprivate var calendarLists: WorkCalendarModel!
//    fileprivate var selectedList: [WorkCalendarData] = []
    fileprivate var calendarLists: ScheduleListsModel!
    fileprivate var unSelectedList: [ScheduleListsData] = []
    fileprivate var selectedList: [ScheduleListsData] = []
    fileprivate var messageDisplay: [Date] = []
    
    // MessageViewController Code
    fileprivate var cancelBarButtonItem: UIBarButtonItem!
    
    fileprivate let deleteBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-30-40, y: UIScreen.main.bounds.size.height-130, width: 60, height: 60))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "删除")!, scaledToWidth: 60.0), for: .normal)
        btn.alpha = 0.0
        return btn
    }()
    
    fileprivate let selectAllBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width/2-30+40, y: UIScreen.main.bounds.size.height-130, width: 60, height: 60))
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "全选")!, scaledToWidth: 49.0), for: .normal)
        btn.alpha = 0.0
        return btn
    }()
    
    fileprivate var selectedArrs: [Int] = []
    
    fileprivate var isSelecting: Bool = false {
        didSet {
            if isSelecting == true {
                
                self.calendar.isUserInteractionEnabled = false
                self.tableView.mj_header = nil
                self.deleteBtn.alpha = 1.0
                self.selectAllBtn.alpha = 1.0
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(cancelEditStatus(_:)))
            } else {

                self.calendar.isUserInteractionEnabled = true
                self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCalendar(_:)))
                
                self.deleteBtn.alpha = 0.0
                self.selectAllBtn.alpha = 0.0
                
                selectedArrs = []
                self.tableView.reloadData()
                
            }
        }
    }
    
    
    fileprivate var selectedDate: Date {
        didSet {
            let tomorrowDate = Date(timeInterval: 24*60*60, since: selectedDate)
            guard self.calendarLists != nil else {
                return
            }
            
            self.selectedList = self.calendarLists.data.filter { data in
                if self.selectedDate <= data.to &&  tomorrowDate > data.to {
                    return true
                } else {
                    return false
                }
            }
            self.selectedList.sort { $0.to < $1.to }
            self.unSelectedList = self.calendarLists.data.filter { data in
                if self.selectedDate > data.to || tomorrowDate <= data.to {
                    return true
                } else {
                    return false
                }
            }
            self.unSelectedList.sort { $0.to < $1.to }
            
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleMessageTableViewCell.self, forCellReuseIdentifier: "ScheduleMessageTableViewCell")
        //tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        //tableView.backgroundColor = UITableView(frame: CGRect.zero, style: .grouped).backgroundColor
        tableView.backgroundColor = UIColor(red: 0.937255, green: 0.937255, blue: 0.956863, alpha: 1.0)
        self.view.addSubview(tableView)
        self.view.backgroundColor = .red
        
        calendar = FSCalendar(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.size.width-20, height: 370))
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.headerTitleColor = UIColor(hex6: 0x8db6d4)
        calendar.appearance.weekdayTextColor = UIColor(hex6: 0x8db6d4)
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.titlePlaceholderColor = .lightGray
        calendar.appearance.subtitlePlaceholderColor = .lightGray
        calendar.appearance.subtitleDefaultColor = .gray
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 15.0)
        calendar.placeholderType = .fillSixRows
        calendar.appearance.todayColor = .gray
        calendar.bottomBorder.backgroundColor = .clear
        calendar.setValue(nil, forKey: "topBorder")
        calendar.backgroundColor = .white
        calendar.layer.masksToBounds = true
        calendar.layer.cornerRadius = 10
        calendar.locale = Locale(identifier: "zh-CN")
        calendar.appearance.subtitleOffset = CGPoint(x: 0.0, y: 3.0)
        
        chineseCalendar = Calendar(identifier: .chinese)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        
        AccountManager.getToken(username: WorkUser.shared.username, password: WorkUser.shared.password, success: { token in
            WorkUser.shared.token = token
            WorkUser.shared.save()
            
            self.headerRefresh()
        }, failure: { error in
            if error is NetworkManager.NetworkNotExist {
                SwiftMessages.showErrorMessage(title: "您似乎已断开与互联网连接", body: "")
            } else {
                SwiftMessages.showErrorMessage(title: "请重新登录", body: "")
            }
            NotificationCenter.default.post(name: NotificationName.NotificationLoginFail.name, object: nil)
        })
        
        cancelBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(cancelEditStatus(_:)))
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEditing(_:)))
        longPress.minimumPressDuration = 0.7
        longPress.name = "LongPress"
        longPress.delegate = self
        longPress.delaysTouchesBegan = true
        tableView.addGestureRecognizer(longPress)
        
        self.view.addSubview(deleteBtn)
        self.view.addSubview(selectAllBtn)
        selectAllBtn.addTarget(self, action: #selector(selectAllMessage(_:)), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteMessage(_:)), for: .touchUpInside)
        
        requestEvents()
        NotificationCenter.default.addObserver(self, selector: #selector(presentLoginView), name: NotificationName.NotificationLoginFail.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(headerRefresh), name: NotificationName.NotificationRefreshCalendar.name, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "日程"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCalendar(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isSelecting = false
        
        self.tableView.mj_header.endRefreshing()
    }
    
}

extension ScheduleViewController {
    
    func requestEvents() {
        eventStore.requestAccess(to: .event, completion: { [weak self] granted, error in
            if granted {
                let calendars = self?.eventStore.calendars(for: .event).filter { calendar in
                    return calendar.type == EKCalendarType.subscription
                }
                
                let startDate = Date().addingTimeInterval(-2*365*24*60*60)
                let endDate = Date().addingTimeInterval(2*365*24*60*60)
                let fetchCalendarEvents = self?.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
                
                self?.events = self?.eventStore.events(matching: fetchCalendarEvents!) ?? []
            }
            
        })
    }
    
    @objc func addCalendar(_ sender: UIButton) {
        let addVC = AddScheduleViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    @objc func longPressEditing(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let pressPoint = gesture.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: pressPoint), indexPath.section == 1 {
                isSelecting = true
                selectedArrs.append(indexPath.row)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func headerRefresh() {
        ScheduleHelper.getCalendarList(success: { model in
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
            self.selectedList.sort { $0.to < $1.to }
            self.unSelectedList = self.calendarLists.data.filter { data in
                if self.selectedDate > data.to || tomorrowDate <= data.to {
                    return true
                } else {
                    return false
                }
            }
            self.unSelectedList.sort { $0.to < $1.to }
            
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
    
    @objc func cancelEditStatus(_ sender: UIBarButtonItem) {
        self.isSelecting = false
    }

    @objc func selectAllMessage(_ sender: UIButton) {
        self.selectedArrs = []
        for index in 0..<self.selectedList.count {
            selectedArrs.append(index)
        }
        self.tableView.reloadData()
    }
    
    @objc func deleteMessage(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "删除", message: "确定要删除吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "不了", style: .default, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        let outAction = UIAlertAction(title: "删除", style: .default, handler: { _ in
            var idArrs: [String] = []
            var typeArrs: [String] = []
            
            idArrs = self.selectedArrs.map { String(self.selectedList[$0].id) }
            typeArrs = self.selectedArrs.map {
                let type = self.selectedList[$0].type
                switch type {
                case .integer(let value):
                    return String(value)
                case .string(let value):
                    return value
                }
            }
            
            var tmp: [ScheduleListsData] = []
            self.selectedList = self.selectedList.filter { !(self.selectedArrs.contains($0.id)) }
            for (index,value) in self.selectedList.enumerated() where !self.selectedArrs.contains(index) {
                tmp.append(value)
            }
            self.selectedList = tmp
            
            self.isSelecting = false
            ScheduleHelper.deleteCalendarList(idArrs: idArrs, typeArrs: typeArrs, success: {
                self.headerRefresh()
            }, failure: {
                
            })
        })
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(outAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 50
        }
        return 390
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
            view.backgroundColor = .clear
            let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width-20, height: 50))
            contentView.backgroundColor = .white
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 10
            
            let titleLabel = UILabel(frame: CGRect(x: 15, y: 10, width: 80, height: 30))
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
            titleLabel.textAlignment = .left
            titleLabel.textColor = UIColor(hex6: 0x00518e)
            
            contentView.addSubview(titleLabel)
            view.addSubview(contentView)
            
            if section == 1 {
                titleLabel.text = "今日事件"
                self.dateLabel.removeFromSuperview()
                contentView.addSubview(dateLabel)
                dateLabel.snp.makeConstraints { make in
                    make.top.bottom.right.equalToSuperview().inset(15)
                    make.width.equalTo(120)
                }
            } else {
                titleLabel.text = "提醒事项"
            }
            return view
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 390))
        view.backgroundColor = .clear
        calendar.removeFromSuperview()
        view.addSubview(calendar)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 20
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else {
            return
        }
        
        guard self.isSelecting == false else {
            let cell = tableView.cellForRow(at: indexPath) as! ScheduleMessageTableViewCell
            if let index = selectedArrs.index(of: indexPath.row) {
                selectedArrs.remove(at: index)
                cell.imgView.image = cell.unselectedImg
            } else {
                selectedArrs.append(indexPath.row)
                cell.imgView.image = cell.selectedImg
            }
            return
        }
        
        let data = self.selectedList[indexPath.row]
        // 0: integer 自创日程
        // 1: string 工作消息
        switch data.type {
        case .integer:
            return
        case .string:
            let detailVC = DetailMessageViewController(mid: String(data.id), isReply: true, messageType: .inbox, isReaded: true)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return self.selectedList.count
        case 2:
            return self.unSelectedList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleMessageTableViewCell") as! ScheduleMessageTableViewCell
        cell.selectionStyle = .none
        
        var data: ScheduleListsData
        if indexPath.section == 1 {
            data = self.selectedList[indexPath.row]
        } else {
            data = self.unSelectedList[indexPath.row]
        }
        
        //let data = self.selectedList[indexPath.row]
        
        cell.titleLabel.text = data.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        cell.dateLabel.text = dateFormatter.string(from: data.to)
        
        if let author = data.author {
            cell.nameLabel.text = author
        }
        if let className = data.className {
            cell.nameLabel.text = className
        }
        
        guard self.isSelecting == true else {
            cell.imgView.alpha  = 0.0
            return cell
        }

        cell.imgView.alpha  = 1.0
        if selectedArrs.contains(indexPath.row) {
            cell.imgView.image = cell.selectedImg
        } else {
            cell.imgView.image = cell.unselectedImg
        }
        
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
    
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let currentDateEvents = self.events.filter { event in
            return event.occurrenceDate == date
        }
        if let event = currentDateEvents.first {
            return event.title
        }
        
        let lunarDay = self.chineseCalendar.component(.day, from: date)
        return self.lunarDays[lunarDay - 1]
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

extension ScheduleViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
}
