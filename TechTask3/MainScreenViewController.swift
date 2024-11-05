//
//  MainScreenViewController.swift
//  TechTask3
//
//  Created by Vladimir Vinakheras on 02.11.2024.
//

//
//  MainScreenViewController.swift
//  TechTask3
//

import UIKit
import SnapKit
import CHTCollectionViewWaterfallLayout
import TimerTechTaskPackage
import BannerTechTaskPackage

class MainScreenViewController: UIViewController {
    
    // MARK: - UI Elements
    private var bannerController = BannerTechTaskViewController()
    private var timerController = TimerTechTaskViewController()
    
    private let goodForLabel: UILabel = {
        let label = UILabel()
        label.text = Asset.Texts.goodforLabelText
        label.font = UIFont(name: Asset.Fonts.labelFont, size: 12)
        label.textColor = Asset.Colors.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemRenderDirection = .rightToLeft
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    private let tags = ["#Осень", "#Портрет", "#Insta-стиль", "#Люди", "#Природа"]
    private let imageNamesList = ["CollectionImage1", "CollectionImage2", "CollectionImage3", "CollectionImage4", "CollectionImage5", "CollectionImage6", "CollectionImage7"]
    
    private lazy var tagsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var bannerSize: CGSize = .zero
    
    // MARK: - ViewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setupChildControllers()
        setupLabel()
        setupTags()
        setupCollectionView()
        activateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupChildControllers() {
        addChild(bannerController)
        view.addSubview(bannerController.view)
        bannerController.didMove(toParent: self)
        
        timerController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(timerController)
        view.addSubview(timerController.view)
        timerController.didMove(toParent: self)
    }
    
    private func setupLabel() {
        view.addSubview(goodForLabel)
    }
    
    private func setupTags() {
        view.addSubview(tagsScrollView)
        tagsScrollView.addSubview(tagsStackView)
        for tag in tags {
            let tagButton = UIButton()
            let font = UIFont(name: Asset.Fonts.buttonTextFont, size: 13)
            let color = Asset.Colors.buttonTextColor
            let attributedText = NSAttributedString(string: tag, attributes: [.font: font,
                                                                              .foregroundColor: color,
                                                                              .kern: 0.07,
                                                                              .paragraphStyle: {
                                                                                  let paragraphStyle = NSMutableParagraphStyle()
                                                                                  paragraphStyle.minimumLineHeight = 13
                                                                                  return paragraphStyle
                                                                              }()])
            
            tagButton.setAttributedTitle(attributedText, for: .normal)
            tagButton.backgroundColor = Asset.Colors.buttonTextColor?.withAlphaComponent(0.15)
            tagButton.layer.cornerRadius = 13
            tagButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            tagsStackView.addArrangedSubview(tagButton)
        }
    }
    
    // MARK: - Setup Collection View
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "ImageCollectionCell")
        
        view.addSubview(collectionView)
    }
    
    func activateConstraints() {
        bannerController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        timerController.view.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(88)
            make.width.equalTo(88)
        }
        
        view.bringSubviewToFront(timerController.view)
        
        goodForLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerController.view.snp.top).offset(149)
            make.leading.equalToSuperview().offset(16)
        }
        
        tagsScrollView.snp.makeConstraints { make in
            make.top.equalTo(goodForLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        tagsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(tagsScrollView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
    }
}

// Extensión de protocolo para UICollectionView
extension MainScreenViewController: UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNamesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        let imageName = imageNamesList[indexPath.item]
        cell.imageView.image = UIImage(named: imageName)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fixedWidth: CGFloat = (collectionView.bounds.width - 8) / 2
        let imageName = imageNamesList[indexPath.item]
        if let image = UIImage(named: imageName) {
            let aspectRatio = image.size.height / image.size.width
            let height = fixedWidth * aspectRatio
            return CGSize(width: fixedWidth, height: height)
        }
        return CGSize(width: fixedWidth, height: 100)
    }
}


