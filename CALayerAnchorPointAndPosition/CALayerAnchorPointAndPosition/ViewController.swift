//
//  ViewController.swift
//  CALayerAnchorPointAndPosition
//
//  Created by Ficow on 2020/10/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var animationView: UIView!

    var initialPosition: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        reset()
    }

    func reset() {
        animationView.layer.anchorPoint = .init(x: 0.5, y: 0.5)
        animationView.transform = .identity
        // 防止自动布局造成干扰，animationView 使用 frame 进行布局
        animationView.frame = CGRect(x: containerView.bounds.width/2-60, y: containerView.bounds.height/2-60, width: 120, height: 120)
        // 记录默认的 position，在此基础上做动画
        initialPosition = animationView.layer.position
    }

    @IBAction func resetAnimationView(_ sender: Any) {
        reset()
    }

    @IBAction func playVerticalAnimation(_ sender: Any) {

        animationView.layer.position = initialPosition

        animationView.layer.anchorPoint = .init(x: 0.5, y: 0) // 上方的中间位置
        animationView.transform = CGAffineTransform(scaleX: 1, y: 0.01)

        print("错误的 position：", animationView.layer.position) // 改动 anchorPoint 后， position 的位置不再正确
        animationView.layer.position.y = 60 // 移到顶部
        print("纠正后的 position：", animationView.layer.position)

        let duration: TimeInterval = 0.4

        UIView.animate(withDuration: duration) {
            self.animationView.transform = .identity
        } completion: { finish in
            UIView.animate(withDuration: duration) {
                self.animationView.transform = CGAffineTransform(scaleX: 1, y: 0.001)
            }
        }
    }

    @IBAction func playHorizontalAnimation(_ sender: Any) {

        animationView.layer.position = initialPosition

        animationView.layer.anchorPoint = .init(x: 0, y: 0.5) // 左方的中间位置
        animationView.transform = CGAffineTransform(scaleX: 0.001, y: 1)

        print("错误的 position：", animationView.layer.position) // 改动 anchorPoint 后， position 的位置不再正确
        animationView.layer.position.x = 120 // 移到左方
        print("纠正后的 position：", animationView.layer.position)

        let duration: TimeInterval = 0.4

        UIView.animate(withDuration: duration) {
            self.animationView.transform = .identity
        } completion: { finish in
            UIView.animate(withDuration: duration) {
                self.animationView.transform = CGAffineTransform(scaleX: 0.001, y: 1)
            }
        }
    }

    @IBAction func moveToLeftTop(_ sender: Any) {
        animationView.layer.anchorPoint = .init(x: 0, y: 0) // 定位到自身左上角
        animationView.layer.position = containerView.bounds.origin // 定位到父视图的左上角
    }

    @IBAction func moveToRightBottom(_ sender: Any) {
        animationView.layer.anchorPoint = .init(x: 1, y: 1) // 定位到自身右下角
        animationView.layer.position = .init(x: containerView.bounds.maxX, y: containerView.bounds.maxY) // 定位到父视图的右下角
    }


}

