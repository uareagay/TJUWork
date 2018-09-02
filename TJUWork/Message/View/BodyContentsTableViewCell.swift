//
//  BodyContentsTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/24.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit

class BodyContentsTableViewCell: UITableViewCell {
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = .lightGray
        
        var content = ""
        content += "求实BBS用户协议\n"
        content += "\n"
        content += "欢迎您注册求实BBS账号。求实BBS开发者，对“求实BBS”所提供的站点、APP等服务进行开发、维护和运营。在您使用“求实BBS”提供的服务之前，应当知晓并同意本协议的全部内容。\n"
        content += "\n"
        content += "一 协议的适用范围\n"
        content += "\n"
        content += "当您以任何方式使用求实BBS提供的服务（所属求实BBS的网站、APP）时，适用本协议。\n"
        content += "\n"
        content += "二 账号信息管理\n"
        content += "\n"
        content += "2.1 求实BBS账号是您在求实BBS相关服务中的唯一用户标识。在您使用求实BBS提供的部分服务时，需要注册求实BBS账号。\n"
        content += "2.2 只有天津大学的学生（包括在读或毕业的专、本、硕、博学生）和教工才能注册求实BBS账号。注册时，需要提供您的学/工号（新生可使用通知书号）和身份证号，系统将与从学校获取的信息进行比对，并将您的账号与您的身份绑定。\n"
        content += "2.3 您应当妥善保管求实BBS账号对应的用户名、密码以及所关联的邮箱、第三方账号。因上述内容丢失而导致的账号被盗或丢失责任由您个人承担。\n"
        content += "2.4 求实BBS保证，在得到您的允许之前，仅将您的邮箱用于账号安全（如：密码重置、安全验证）及必要的通知。\n"
        content += "2.5 如遇相关法律法规或法院、政府机关要求，求实BBS可能会将您的部分或全部信息提供给相关部门。\n"
        content += "\n"
        content += "三 用户内容管理\n"
        content += "\n"
        content += "3.1 您在使用求实BBS提供的服务时，不得以任何形式提交或发布包含下列内容的信息：\n"
        content += "(1) 反对宪法所确定的基本原则的；\n"
        content += "(2) 危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n"
        content += "(3) 损害国家荣誉和利益的；\n"
        content += "(4) 煽动民族仇恨、民族歧视，破坏民族团结的；\n"
        content += "(5) 破坏国家宗教政策，宣扬邪教和封建迷信的；\n"
        content += "(6) 散布谣言，扰乱社会秩序，破坏社会稳定的；\n"
        content += "(7) 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n"
        content += "(8) 侮辱或者诽谤他人，侵害他人合法权益的；\n"
        content += "(9) 泄露商业机密或国家机密，或侵害他人知识产权的；\n"
        content += "(10) 含有法律、行政法规禁止的其他内容的；\n"
        content += "3.2 您不能使用下列内容作为 用户名、头像 等展示信息：\n"
        content += "(1) 现实存在的 国家/地区/党派/团体/企业/机构 的名称、旗帜或相关的徽章、图标（已获得授权的除外）；\n"
        content += "(2) 现实存在的 国家/地区/党派/团体/企业/机构 的知名成员的姓名、照片、签名；\n"
        content += "(3) 容易引起争议的内容（包括但不限于主权争议、归属争议等）；\n"
        content += "(4) 不文明（包括但不限于暴力、性暗示等）的文字、图片；\n"
        content += "(5) 违反法律法规的内容（包括但不限于非法广告、恶意链接等）。\n"
        content += "3.3 您不得以任何方式、任何形式进行下列任何活动：\n"
        content += "(1) 盗用或冒用求实BBS官方身份；\n"
        content += "(2) 攻击求实BBS的服务及相关服务；\n"
        content += "(3) 取得不当利益或盗取他人信息；\n"
        content += "(4) 存储/展示/传播 病毒或恶意代码；\n"
        content += "(5) 无故消耗服务器资源\n"
        content += "3.4 您理解并同意，求实BBS有权对上述相关违规行为进行独立判断，在不预先通知的情况下采取包括但不限于对相关内容进行屏蔽、删除或对您的求实BBS账号进行封停、删除等措施，并保留上报有关部门的权利。且可能由此造成的一切后果由您个人承担。\n"
        content += "3.5 未经求实BBS的授权或许可，您不得借用求实BBS的名义从事任何商业活动，也不得将求实BBS提供的平台作为从事商业活动的场所、平台或其他任何形式的媒介。禁止将求实BBS用作从事各种非法活动的场所、平台或者其他任何形式的媒介。\n"
        content += "\n"
        content += "四 权利说明\n"
        content += "\n"
        content += "4.1 求实BBS所提供的各项服务，如无特殊声明，相关设计、程序的所有权归求实BBS工作室所有（引用组件除外）。未经授权，不得仿制。\n"
        content += "4.2 由用户发布的任何信息，除本协议另有声明的情况下，所有的权利及义务均属于发布者。求实BBS及其他用户不对其内容或可能产生的任何后果承担任何责任。\n"
        content += "4.3 在不以营利为目的的前提下，求实BBS可以对用户提交的内容进行整合、汇编并公开发布。发布时应当注明原作者。\n"
        content += "\n"
        content += "五 责任免除\n"
        content += "\n"
        content += "5.1 您理解并同意，求实BBS的服务是按照现有技术和条件所能达到的现状提供的。求实BBS会尽最大努力向您提供服务，但不保证服务随时可用。\n"
        content += "5.2 您理解并同意，求实BBS所提供的服务可能会包含用户或其他第三方提供的内容。求实BBS无法预知这些内容的实际情况，且不对这些信息的真实性或有效性提供担保。对于用户经上述内容取得的任何产品、信息或资料，求实BBS不承担任何责任，需由用户自行负担风险。\n"
        content += "5.3 您理解并同意，在使用求实BBS的服务时，您的网络连接可能会受到第三方（包括但不限于网络服务商、政府机关以及可能的攻击者等）的监听、审查或干扰（包括但不限于插入广告、推送信息、劫持连接和中断访问等）。求实BBS对因此导致的影响不承担责任。\n"
        content += "5.4 您理解并同意，如遇下列情况导致服务出现中断或终止，求实BBS对因此导致的影响不承担责任：\n"
        content += "(1) 遇到不可抗力等因素（包括但不限于自然灾害如洪水、地震、瘟疫流行和风暴等以及社会事件如战争、动乱、政府行为等）；\n"
        content += "(2) 由于第三方过错导致的服务中断（包括但不限于服务提供商过错等）；\n"
        content += "(3) 由于服务遭受攻击或受到病毒、木马等恶意程序影响的；\n"
        content += "(4) 其它应当免除求实BBS之责任的情形。\n"
        content += "\n"
        content += "六 协议生效\n"
        content += "\n"
        content += "6.1 本协议最终解释权归求实BBS工作室所有，求实BBS工作室有权在不进行通知的情况下修改服务协议。\n"
        content += "6.2 本协议未尽事宜，依照中华人民共和国相关法律法规处理。\n"
        content += "6.3 无论因何种原因导致本协议中部分无效或不可执行，其余条款仍对双方有效。\n"
        content += "6.4 本协议中所有标题仅作索引使用，不能作为解释协议内容的依据。"
        
        label.text = content
        
       
        label.textAlignment = .justified
       
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        
        
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(whiteView)
        whiteView.addSubview(contentLabel)
        
        whiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(25)
        }
        
       
    }
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//       print("subviews")
//
//
//    }
    

    
//    override var frame: CGRect {
//        didSet {
//
//            print("frame")
//            print(bounds)
//            print(self.contentLabel.frame)
//
//            var newFrame = frame
//
//            newFrame.origin.x += 10
//            newFrame.size.width -= 20
//            super.frame = newFrame
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
