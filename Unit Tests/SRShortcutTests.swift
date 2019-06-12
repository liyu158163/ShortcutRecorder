//
//  Copyright 2018 ShortcutRecorder Contributors
//  CC BY 4.0
//

import XCTest
import ShortcutRecorder


class SRShortcutTests: XCTestCase {
    /*!
        Raw values of the constants must not be changed for the sake of compatibility.
    */
    func testShortcutKeyEnum() {
        XCTAssertEqual(ShortcutKey.keyCode.rawValue, "keyCode")
        XCTAssertEqual(ShortcutKey.modifierFlags.rawValue, "modifierFlags")
        XCTAssertEqual(ShortcutKey.characters.rawValue, "characters")
        XCTAssertEqual(ShortcutKey.charactersIgnoringModifiers.rawValue, "charactersIgnoringModifiers")
    }

    func testInitialization() {
        let s = Shortcut.default
        XCTAssertEqual(s.keyCode, 0)
        XCTAssertEqual(s.modifierFlags, [.option, .command])
        XCTAssertEqual(s.characters, "å")
        XCTAssertEqual(s.charactersIgnoringModifiers, "a")
    }

    func testInitializationWithEvent() {
        let e = NSEvent.keyEvent(with: .keyUp,
                                 location: .zero,
                                 modifierFlags: .option,
                                 timestamp: 0.0,
                                 windowNumber: 0,
                                 context: nil,
                                 characters: "å",
                                 charactersIgnoringModifiers: "a",
                                 isARepeat: false,
                                 keyCode: 0)
        let s = ShortcutRecorder.Shortcut(event: e!)!
        XCTAssertEqual(s.keyCode, 0)
        XCTAssertEqual(s.modifierFlags, .option)
        XCTAssertEqual(s.characters, "å")
        XCTAssertEqual(s.charactersIgnoringModifiers, "a")
    }

    func testSubscription() {
        let s = Shortcut.default
        XCTAssertEqual(s[.keyCode] as! UInt16, 0)
        XCTAssertEqual(NSEvent.ModifierFlags(rawValue: s[.modifierFlags] as! UInt), [.option, .command])
        XCTAssertEqual(s[.characters] as! String, "å")
        XCTAssertEqual(s[.charactersIgnoringModifiers] as! String, "a")
    }

    func testKVC() {
        let s = Shortcut.default
        XCTAssertEqual(s.value(forKey: ShortcutKey.keyCode.rawValue) as! UInt16, 0)
        XCTAssertEqual(NSEvent.ModifierFlags(rawValue: s.value(forKey: ShortcutKey.modifierFlags.rawValue) as! UInt), [.option, .command])
        XCTAssertEqual(s.value(forKey: ShortcutKey.characters.rawValue) as! String, "å")
        XCTAssertEqual(s.value(forKey: ShortcutKey.charactersIgnoringModifiers.rawValue) as! String, "a")
    }

    func testDictionaryInitialization() {
        let s1 = Shortcut(dictionary: [ShortcutKey.keyCode: 0])!
        XCTAssertEqual(s1.keyCode, 0)
        XCTAssertEqual(s1.modifierFlags, [])
        XCTAssertEqual(s1.characters, nil)
        XCTAssertEqual(s1.charactersIgnoringModifiers, nil)

        let s2 = Shortcut(dictionary: [ShortcutKey.keyCode: 0, ShortcutKey.modifierFlags: NSEvent.ModifierFlags.option.rawValue])!
        XCTAssertEqual(s2.keyCode, 0)
        XCTAssertEqual(s2.modifierFlags, NSEvent.ModifierFlags.option)
        XCTAssertEqual(s2.characters, nil)
        XCTAssertEqual(s2.charactersIgnoringModifiers, nil)

        let s3 = Shortcut(dictionary: [ShortcutKey.keyCode: 0, ShortcutKey.modifierFlags: NSEvent.ModifierFlags.option.rawValue,
                                       ShortcutKey.characters: NSNull(), ShortcutKey.charactersIgnoringModifiers: NSNull()])!
        XCTAssertEqual(s3.keyCode, 0)
        XCTAssertEqual(s3.modifierFlags, NSEvent.ModifierFlags.option)
        XCTAssertEqual(s3.characters, nil)
        XCTAssertEqual(s3.charactersIgnoringModifiers, nil)

        let s4 = Shortcut(dictionary: [ShortcutKey.keyCode: 0, ShortcutKey.modifierFlags: NSEvent.ModifierFlags.option.rawValue,
                                       ShortcutKey.characters: "å", ShortcutKey.charactersIgnoringModifiers: "a"])!
        XCTAssertEqual(s4.keyCode, 0)
        XCTAssertEqual(s4.modifierFlags, NSEvent.ModifierFlags.option)
        XCTAssertEqual(s4.characters, "å")
        XCTAssertEqual(s4.charactersIgnoringModifiers, "a")
    }

    func testDictionaryRepresentation() {
        let s1 = Shortcut(dictionary: [ShortcutKey.keyCode: 0])!
        XCTAssertEqual(s1.dictionaryRepresentation as NSDictionary, [ShortcutKey.keyCode: 0,
                                                                     ShortcutKey.modifierFlags: 0])

        let s2 = Shortcut(dictionary: [ShortcutKey.keyCode: 0, ShortcutKey.modifierFlags: NSEvent.ModifierFlags.option.rawValue])!
        XCTAssertEqual(s2.dictionaryRepresentation as NSDictionary, [ShortcutKey.keyCode: 0,
                                                                     ShortcutKey.modifierFlags: NSEvent.ModifierFlags.option.rawValue])

        let s3 = Shortcut(dictionary: [ShortcutKey.keyCode: 0, ShortcutKey.modifierFlags: NSEvent.ModifierFlags.option.rawValue,
                                       ShortcutKey.characters: "å", ShortcutKey.charactersIgnoringModifiers: "a"])!
        XCTAssertEqual(s3.dictionaryRepresentation as NSDictionary, [ShortcutKey.keyCode: 0,
                                                                     ShortcutKey.modifierFlags: NSEvent.ModifierFlags.option.rawValue,
                                                                     ShortcutKey.characters: "å",
                                                                     ShortcutKey.charactersIgnoringModifiers: "a"])
    }

    func testEquality() {
        let s = Shortcut.default
        let modifierFlags: NSEvent.ModifierFlags = [.option, .command]

        XCTAssertEqual(s, s)
        XCTAssertEqual(s, Shortcut.default)
        XCTAssertNotEqual(s, Shortcut(code: 0, modifierFlags: .command, characters: nil, charactersIgnoringModifiers: nil));
        XCTAssertTrue(s.isEqual(dictionary: [ShortcutKey.keyCode: 0,
                                             ShortcutKey.modifierFlags: modifierFlags.rawValue,
                                             ShortcutKey.characters: "å",
                                             ShortcutKey.charactersIgnoringModifiers: "a"]))
        XCTAssertFalse(s.isEqual(dictionary: [ShortcutKey.modifierFlags: modifierFlags.rawValue,
                                              ShortcutKey.characters: "å",
                                              ShortcutKey.charactersIgnoringModifiers: "a"]))
    }

    func testSimpleSubclassEquality() {
        class SimpleSubclass: Shortcut {}

        let s1 = Shortcut.default
        let s2 = SimpleSubclass.default as! SimpleSubclass

        XCTAssertEqual(s1, s2)
        XCTAssertEqual(s2, s1)
    }

    func testExtendedSubclassEquality() {
        class ExtendedSubclass: Shortcut {
            var myProperty: Int = 0

            override func isEqual(to aShortcut: Shortcut) -> Bool {
                guard let aShortcut = aShortcut as? ExtendedSubclass else { return false }
                return super.isEqual(to: aShortcut) && self.myProperty == aShortcut.myProperty
            }
        }

        class SimpleOfExtendedSubclass: ExtendedSubclass {}

        class ExtendedOfSimpleOfExtendedSubclass: SimpleOfExtendedSubclass {
            var anotherProperty: Int = 0

            override func isEqual(to aShortcut: Shortcut) -> Bool {
                guard let aShortcut = aShortcut as? ExtendedOfSimpleOfExtendedSubclass else { return false }
                return super.isEqual(to: aShortcut) && self.anotherProperty == aShortcut.anotherProperty
            }
        }

        func AssertEqual(_ a: Shortcut, _ b: Shortcut) {
            XCTAssertEqual(a, b)
            XCTAssertEqual(b, a)
        }

        func AssertNotEqual(_ a: Shortcut, _ b: Shortcut) {
            XCTAssertNotEqual(a, b)
            XCTAssertNotEqual(b, a)
        }

        let s1 = Shortcut.default

        let e1 = ExtendedSubclass.default as! ExtendedSubclass
        let e2 = ExtendedSubclass.default as! ExtendedSubclass
        let e3 = ExtendedSubclass.default as! ExtendedSubclass
        e3.myProperty = 1

        XCTContext.runActivity(named: ExtendedSubclass.className()) { _ in
            AssertNotEqual(s1, e1)
            AssertNotEqual(s1, e2)
            AssertEqual(e1, e2)
            AssertNotEqual(e2, e3)
        }

        let se1 = SimpleOfExtendedSubclass.default as! SimpleOfExtendedSubclass
        let se2 = SimpleOfExtendedSubclass.default as! SimpleOfExtendedSubclass
        let se3 = SimpleOfExtendedSubclass.default as! SimpleOfExtendedSubclass
        se3.myProperty = e3.myProperty + 1

        XCTContext.runActivity(named: SimpleOfExtendedSubclass.className()) { _ in
            AssertNotEqual(se1, s1)
            AssertEqual(se1, e1)
            AssertNotEqual(se1, e3)
            AssertEqual(se1, se2)
            AssertNotEqual(se1, se3)
        }

        let ese1 = ExtendedOfSimpleOfExtendedSubclass.default as! ExtendedOfSimpleOfExtendedSubclass
        let ese2 = ExtendedOfSimpleOfExtendedSubclass.default as! ExtendedOfSimpleOfExtendedSubclass
        let ese3 = ExtendedOfSimpleOfExtendedSubclass.default as! ExtendedOfSimpleOfExtendedSubclass
        ese3.anotherProperty = se3.myProperty + 1

        XCTContext.runActivity(named: SimpleOfExtendedSubclass.className()) { _ in
            AssertNotEqual(ese1, s1)
            AssertNotEqual(ese1, e1)
            AssertNotEqual(ese1, se1)
            AssertEqual(ese1, ese2)
            AssertNotEqual(ese1, ese3)
        }
    }

    func testSiblingSubclassEquality() {
        class ASubclass: Shortcut {}
        class BSubclass: Shortcut {}

        let a = ASubclass.default
        let b = BSubclass.default

        XCTAssertEqual(a, b);
        XCTAssertEqual(b, a);
    }

    func testEncoding() {
        let s = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: Shortcut.default))!
        XCTAssertEqual(s as! Shortcut, Shortcut.default)
    }

    func testCopying() {
        let s = Shortcut.default
        let c = s.copy() as! Shortcut
        XCTAssertEqual(s, c)
    }

    func testKeyEquivalentComparison() {
        let a = Shortcut(code: UInt16(kVK_ANSI_A), modifierFlags: [], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertTrue(a.isEqual(keyEquivalent: "a", modifierFlags: []))
        XCTAssertFalse(a.isEqual(keyEquivalent: "a", modifierFlags: [.shift]))
        XCTAssertFalse(a.isEqual(keyEquivalent: "A", modifierFlags: []))
        XCTAssertFalse(a.isEqual(keyEquivalent: "A", modifierFlags: [.shift]))

        let opt_a = Shortcut(code: UInt16(kVK_ANSI_A), modifierFlags: [.option], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertTrue(opt_a.isEqual(keyEquivalent: "å", modifierFlags: []))
        XCTAssertFalse(opt_a.isEqual(keyEquivalent: "å", modifierFlags: [.shift]))
        XCTAssertFalse(opt_a.isEqual(keyEquivalent: "Å", modifierFlags: []))
        XCTAssertFalse(opt_a.isEqual(keyEquivalent: "Å", modifierFlags: [.shift]))
        XCTAssertTrue(opt_a.isEqual(keyEquivalent: "a", modifierFlags: [.option]))
        XCTAssertFalse(opt_a.isEqual(keyEquivalent: "a", modifierFlags: [.option, .shift]))
        XCTAssertFalse(opt_a.isEqual(keyEquivalent: "A", modifierFlags: [.option]))
        XCTAssertFalse(opt_a.isEqual(keyEquivalent: "A", modifierFlags: [.option, .shift]))

        let ctrl_a = Shortcut(code: UInt16(kVK_ANSI_A), modifierFlags: [.control], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertTrue(ctrl_a.isEqual(keyEquivalent: "a", modifierFlags: [.control]))
        XCTAssertFalse(ctrl_a.isEqual(keyEquivalent: "A", modifierFlags: [.control]))
        XCTAssertFalse(ctrl_a.isEqual(keyEquivalent: "a", modifierFlags: [.control, .shift]))
        XCTAssertFalse(ctrl_a.isEqual(keyEquivalent: "a", modifierFlags: []))

        let cmd_a = Shortcut(code: UInt16(kVK_ANSI_A), modifierFlags: [.command], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertTrue(cmd_a.isEqual(keyEquivalent: "a", modifierFlags: [.command]))
        XCTAssertFalse(cmd_a.isEqual(keyEquivalent: "A", modifierFlags: [.command]))
        XCTAssertFalse(cmd_a.isEqual(keyEquivalent: "a", modifierFlags: [.command, .shift]))
        XCTAssertFalse(cmd_a.isEqual(keyEquivalent: "a", modifierFlags: []))

        let shift_a = Shortcut(code: UInt16(kVK_ANSI_A), modifierFlags: [.shift], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertFalse(shift_a.isEqual(keyEquivalent: "a", modifierFlags: []))
        XCTAssertTrue(shift_a.isEqual(keyEquivalent: "a", modifierFlags: [.shift]))
        XCTAssertTrue(shift_a.isEqual(keyEquivalent: "A", modifierFlags: []))
        XCTAssertTrue(shift_a.isEqual(keyEquivalent: "A", modifierFlags: [.shift]))

        let ctrl_tab = Shortcut(code: UInt16(kVK_Tab), modifierFlags: [.control], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertTrue(ctrl_tab.isEqual(keyEquivalent: "\u{0009}", modifierFlags: [.control]))
        XCTAssertTrue(ctrl_tab.isEqual(keyEquivalent: "\u{0019}", modifierFlags: [.control]))

        let ctrl_del = Shortcut(code: UInt16(kVK_Delete), modifierFlags: [.control], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertTrue(ctrl_del.isEqual(keyEquivalent: "\u{0008}", modifierFlags: [.control]));
        XCTAssertFalse(ctrl_del.isEqual(keyEquivalent: "\u{007f}", modifierFlags: [.control]));

        let ctrl_fdel = Shortcut(code: UInt16(kVK_ForwardDelete), modifierFlags: [.control], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertFalse(ctrl_fdel.isEqual(keyEquivalent: "\u{0008}", modifierFlags: [.control]));
        XCTAssertTrue(ctrl_fdel.isEqual(keyEquivalent: "\u{007f}", modifierFlags: [.control]));
    }

    func testInitializationWithKeyEquivalent() {
        let shift_cmd_a = Shortcut(code: UInt16(kVK_ANSI_A), modifierFlags: [.shift, .command], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertEqual(Shortcut(keyEquivalent: "⇧⌘A"), shift_cmd_a)

        let ctrl_esc = Shortcut(code: UInt16(kVK_Escape), modifierFlags: [.control], characters: nil, charactersIgnoringModifiers: nil)
        XCTAssertEqual(Shortcut(keyEquivalent: "⌃Escape"), ctrl_esc)
    }
}
