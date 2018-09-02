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

class ScheduleViewController: UIViewController {
    
    var calendar: FSCalendar!
    var tableView: UITableView!
    var selectedDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY / MM / dd"
        selectedDate = formatter.string(from: Date())
        
        
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
        //self.view.addSubview(calendar)
    
        calendar.backgroundColor = .white
        
        calendar.layer.masksToBounds = true
        calendar.layer.cornerRadius = 10
        
        //self.view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "日程"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
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
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 10
            
            
            let titlelaLabel = UILabel(frame: CGRect(x: 15, y: 10, width: 80, height: 30))
            titlelaLabel.text = "当日事件"
            titlelaLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
            titlelaLabel.textAlignment = .left
            titlelaLabel.textColor = UIColor(hex6: 0x00518e)
            
            
            let dateLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.size.width-20)*2/3, y: 15, width: 100, height: 20))
            dateLabel.text = selectedDate
            dateLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
            dateLabel.textAlignment = .right
            dateLabel.textColor = UIColor(hex6: 0x8db6d4)
            
            contentView.addSubview(titlelaLabel)
            contentView.addSubview(dateLabel)
            view.addSubview(contentView)
            
            dateLabel.snp.makeConstraints { make in
                make.top.bottom.right.equalToSuperview().inset(15)
                make.width.equalTo(100)
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
        guard section != 0 else {
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleMessageTableViewCell") as! ScheduleMessageTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
}

extension ScheduleViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let newDate = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY / MM / dd"
        selectedDate = dateFormatter.string(from: date)
        self.tableView.reloadSections(IndexSet.init(integer: 1), with: .none)
    }
    
    
}

extension ScheduleViewController: FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        return 1
    }
    
    
    
    
    
}
