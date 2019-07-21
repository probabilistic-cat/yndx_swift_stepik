//
//  ListViewController.swift
//  Notes
//
//  Created by andrey on 2019-07-20.
//  Copyright © 2019 andrey. All rights reserved.
//

import UIKit

class NoteListViewController: UIViewController {

    private let fileNotebook = FileNotebook()
    private var notes: [Note] = []

    let notesTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override internal func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustLayouts()
    }

    override internal func viewWillAppear(_ animated: Bool) {
        if (!self.isMovingToParent) {
            fileNotebook.loadFromFile()
        }
        fillNotesFromFileNotebook()
        if (!self.isMovingToParent) {
            notesTableView.reloadData()
        }
    }

    private func setupViews() {
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(plusTapped(_:))
        )
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        notesTableView.dataSource = self
        notesTableView.delegate = self
        view.addSubview(notesTableView)
    }

    private func adjustLayouts() {
        notesTableView.frame = view.safeAreaLayoutGuide.layoutFrame
    }

    private func fillNotesFromFileNotebook() {
        notes = fileNotebook.getNotesArraySortedByTitle()
    }

    @objc private func plusTapped(_ sender: Any) {
        showNoteEditViewController()
    }

    private func showNoteEditViewController(editingNoteUid: String? = nil) {
        let noteEditViewController = NoteEditViewController()

        if (editingNoteUid != nil) {
            noteEditViewController.editingNoteUid = editingNoteUid
        }

        self.navigationController?.pushViewController(noteEditViewController, animated: true)
    }
}


extension NoteListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNotebook.notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let note = notes[indexPath.row]

        cell.textLabel?.text = note.title
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.text = note.content
        cell.detailTextLabel?.numberOfLines = 5

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notes"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showNoteEditViewController(editingNoteUid: notes[indexPath.row].uid)
    }
}
