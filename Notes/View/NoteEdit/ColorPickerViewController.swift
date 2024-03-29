//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by andrey on 2019-07-20.
//  Copyright © 2019 andrey. All rights reserved.
//

import UIKit

protocol ColorPickDelegate {
    func didColorPicked(color: UIColor)
}

class ColorPickerViewController: UIViewController {

    private let colorPickerView = ColorPickerView()

    private var pickedColor: UIColor = UIColor.white
    private var brightness: CGFloat = 1
    private var selectedColor: UIColor = UIColor.white {
        didSet {
            let selectedHex: String = selectedColor.toHexString()
            colorPickerView.selectedColorView.backgroundColor = selectedColor
            colorPickerView.selectedHexLabel.text = selectedHex
        }
    }

    var colorPickDelegate: ColorPickDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustLayouts()
    }

    override func viewWillAppear(_ animated: Bool) {
        if (self.isMovingToParent) {
            self.navigationController?.isNavigationBarHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if (self.isMovingFromParent) {
            self.navigationController?.isNavigationBarHidden = false
        }
    }

    private func setupViews() {
        view.backgroundColor = UIColor.white
        view.addSubview(colorPickerView)

        brightnessSliderChange()
        doneButtonTap()

        colorPickerView.paletteView.onColorDidChange = { [weak self] color in DispatchQueue.main.async {
            self?.pickedColor = color
            self?.changeSelectedColor()
        }}
    }

    private func adjustLayouts() {
        colorPickerView.frame = view.safeAreaLayoutGuide.layoutFrame
    }

    private func changeSelectedColor() {
        selectedColor = self.pickedColor.withBrightness(self.brightness)
    }

    func setSelectedColor(_ color: UIColor) {
        if let brightness = color.getBrightnessValue() {
            self.brightness = brightness
        } else {
            return
        }

        colorPickerView.brightnessSlider.value = Float(self.brightness)
        colorPickerView.paletteView.pickedColor = color.withBrightness(1)
    }


    // ---------- Brightness slider change ----------

    private func brightnessSliderChange() {
        colorPickerView.brightnessSlider.addTarget(self, action: #selector(brightnessSliderChanged), for: UIControl.Event.valueChanged)
    }

    @objc private func brightnessSliderChanged() {
        brightness = CGFloat(colorPickerView.brightnessSlider.value)
        changeSelectedColor()
    }

    // ---------- Done button tap ----------

    private func doneButtonTap() {
        let doneButtonTap = UITapGestureRecognizer(target: self, action: #selector (doneButtonTapped))
        colorPickerView.doneButton.addGestureRecognizer(doneButtonTap)
    }

    @objc private func doneButtonTapped() {
        let color: UIColor = selectedColor
        colorPickDelegate?.didColorPicked(color: color)
        self.navigationController?.popViewController(animated: false)
    }
}
