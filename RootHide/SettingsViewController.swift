import UIKit

final class SettingsViewController: UITableViewController {
    init() {
        super.init(style: .insetGrouped)
        title = localized("Settings")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableHeaderView = brandHeader()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let header = tableView.tableHeaderView else { return }
        let width = tableView.bounds.width
        let height = header.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel
        ).height
        if header.frame.width != width || abs(header.frame.height - height) > 0.5 {
            header.frame.size = CGSize(width: width, height: height)
            tableView.tableHeaderView = header
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String?
    {
        localized("Advanced")
    }

    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = detailCell(in: tableView, reuseIdentifier: "Rules")
        var content = cell.defaultContentConfiguration()
        content.text = localized("Custom Cleanup Rules")
        content.secondaryText = localized("Edit cleanup rules in Filza.")
        content.textProperties.numberOfLines = 0
        content.secondaryTextProperties.numberOfLines = 0
        content.secondaryTextProperties.color = .secondaryLabel
        content.textToSecondaryTextVerticalPadding = 6
        content.image = UIImage(systemName: "doc.text")
        content.imageProperties.tintColor = AppTheme.tint
        content.imageProperties.maximumSize = CGSize(width: 26, height: 26)
        content.imageProperties.reservedLayoutSize = CGSize(width: 32, height: 26)
        content.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 26)
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16, leading: 20, bottom: 16, trailing: 20)
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    private func brandHeader() -> UIView {
        let header = UIView()
        header.backgroundColor = .systemGroupedBackground

        let icon = UIImageView(image: UIImage(named: "BrandIcon"))
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 17
        icon.clipsToBounds = true
        let name = UILabel()
        name.text = "RootHide"
        name.font = UIFontMetrics(forTextStyle: .title2).scaledFont(
            for: .systemFont(ofSize: 24, weight: .semibold))
        let version = UILabel()
        version.text = String(
            format: localized("Version %@"),
            Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
                ?? "—")
        version.font = .preferredFont(forTextStyle: .subheadline)
        version.textColor = .secondaryLabel
        for label in [name, version] {
            label.numberOfLines = 0
            label.textAlignment = .center
            label.adjustsFontForContentSizeCategory = true
        }
        let stack = UIStackView(arrangedSubviews: [icon, name, version])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.setCustomSpacing(16, after: icon)
        stack.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stack)
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 76),
            icon.heightAnchor.constraint(equalToConstant: 76),
            name.widthAnchor.constraint(equalTo: stack.widthAnchor),
            version.widthAnchor.constraint(equalTo: stack.widthAnchor),
            stack.topAnchor.constraint(equalTo: header.topAnchor, constant: 44),
            stack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(
                equalTo: header.trailingAnchor, constant: -24),
        ])
        header.isAccessibilityElement = true
        header.accessibilityLabel = name.text
        header.accessibilityValue = version.text
        header.accessibilityTraits = .staticText
        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openInFilza(path: RHBackend.customRulesPath(), from: self)
    }
}
