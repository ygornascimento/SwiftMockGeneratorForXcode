import XCTest
@testable import SwiftStructureInterface

class ElementProxyTest: XCTestCase {

    func test_shouldManageLifecycleOfFile() {
        weak var weakFile: File?
        autoreleasepool {
            let fileProxy = createFile()
            let file = fileProxy.managed as! FileImpl
            XCTAssertGreaterThan(file.retainCount, 0)
            weakFile = file
        }
        XCTAssertNil(weakFile)
    }

    func test_shouldManageLifecycleOfFileWhenHoldingChild() {
        weak var weakFile: File?
        weak var weakChild: Element?
        autoreleasepool {
            let fileProxy = createFile()
            let file = fileProxy.managed as! FileImpl
            let child = fileProxy.children[0]
            XCTAssertGreaterThan(file.retainCount, 0)
            weakChild = child
            weakFile = file
        }
        XCTAssertNil(weakFile)
        XCTAssertNil(weakChild)
    }

    func test_shouldManageLifecycleOfFileWhenHoldingGrandchild() {
        weak var weakFile: File?
        weak var weakGrandchild: Element?
        autoreleasepool {
            let fileProxy = createFile()
            let file = fileProxy.managed as! FileImpl
            let grandchild = fileProxy.children[0].children[0]
            XCTAssertGreaterThan(file.retainCount, 0)
            weakGrandchild = grandchild
            weakFile = file
        }
        XCTAssertNil(weakFile)
        XCTAssertNil(weakGrandchild)
    }

    func test_shouldKeepStructureAliveWhenAtLeastOneReference() {
        weak var weakFile: File?
        weak var weakChild: Element?
        var strongGrandchild: Element?
        autoreleasepool {
            let fileProxy = createFile()
            let file = fileProxy.managed as! FileImpl
            strongGrandchild = fileProxy.children[0].children[0]
            XCTAssertGreaterThan(file.retainCount, 0)
            weakFile = file
            weakChild = file.children[0]
        }
        XCTAssertNotNil(weakFile)
        XCTAssertNotNil(weakChild)
        XCTAssertNotNil(weakChild?.file)
        XCTAssertNotNil(strongGrandchild)
    }

    func test_shouldWrapElement() {
        let file = createFile()
        let child = file.children[0]
        let rawFile = file.managed as! FileImpl
        let rawChild = rawFile.children[0]
        XCTAssertEqual(rawChild.children.count, child.children.count)
        XCTAssertEqual(rawChild.text, child.text)
    }

    private func wrap(_ element: Element) -> ElementProxy? {
        return ElementProxy(element as! ElementImpl)
    }

    private func suppressWarning(_ proxy: Element?) {
    }

    private func createFile() -> FileProxy {
        return ElementParser.parseFile("protocol A { var a: A { get } }") as! FileProxy
    }

    private class VisitorSpy: ElementVisitor {

        var invokedVisitElement = false
        override func visitElement(_ element: Element) {
            invokedVisitElement = true
            super.visitElement(element)
        }

        var invokedVisitTypeDeclaration = false
        override func visitTypeDeclaration(_ element: TypeDeclaration) {
            invokedVisitTypeDeclaration = true
            super.visitTypeDeclaration(element)
        }
    }
}
