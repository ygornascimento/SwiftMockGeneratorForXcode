class TupleTypeElementImpl: ElementImpl, TupleTypeElement {

    let label: String?
    let typeAnnotation: TypeAnnotation

    static let errorTupleTypeElement = TupleTypeElementImpl(text: "", children: [], offset: -1, length: -1, label: nil, typeAnnotation: SwiftTypeAnnotationImpl.errorTypeAnnotation)

    init(text: String, children: [Element], offset: Int64, length: Int64, label: String?, typeAnnotation: TypeAnnotation) {
        self.label = label
        self.typeAnnotation = typeAnnotation
        super.init(text: text, children: children, offset: offset, length: length)
    }

    override func accept(_ visitor: ElementVisitor) {
        visitor.visitTupleTypeElement(self)
    }
}