import ProjectDescription

private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
  description: "A tamplate for Demo target",
  attributes: [
    nameAttribute
  ],
  items: [
    .file(
      path: "Projects/Feature/\(nameAttribute)/Example/Sources/\(nameAttribute)Example.swift",
      templatePath: "Example.stencil",
    )
  ],
)
