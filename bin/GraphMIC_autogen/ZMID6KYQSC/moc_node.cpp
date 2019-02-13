/****************************************************************************
** Meta object code from reading C++ file 'node.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../Sources/node.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'node.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Node_t {
    QByteArrayData data[13];
    char stringdata0[137];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Node_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Node_t qt_meta_stringdata_Node = {
    {
QT_MOC_LITERAL(0, 0, 4), // "Node"
QT_MOC_LITERAL(1, 5, 14), // "inNodesChanged"
QT_MOC_LITERAL(2, 20, 0), // ""
QT_MOC_LITERAL(3, 21, 15), // "outNodesChanged"
QT_MOC_LITERAL(4, 37, 9), // "addInNode"
QT_MOC_LITERAL(5, 47, 5), // "Node*"
QT_MOC_LITERAL(6, 53, 4), // "node"
QT_MOC_LITERAL(7, 58, 12), // "removeInNode"
QT_MOC_LITERAL(8, 71, 10), // "addOutNode"
QT_MOC_LITERAL(9, 82, 13), // "removeOutNode"
QT_MOC_LITERAL(10, 96, 9), // "getResult"
QT_MOC_LITERAL(11, 106, 7), // "inNodes"
QT_MOC_LITERAL(12, 114, 22) // "QQmlListProperty<Node>"

    },
    "Node\0inNodesChanged\0\0outNodesChanged\0"
    "addInNode\0Node*\0node\0removeInNode\0"
    "addOutNode\0removeOutNode\0getResult\0"
    "inNodes\0QQmlListProperty<Node>"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Node[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       1,   64, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   49,    2, 0x06 /* Public */,
       3,    0,   50,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
       4,    1,   51,    2, 0x02 /* Public */,
       7,    1,   54,    2, 0x02 /* Public */,
       8,    1,   57,    2, 0x02 /* Public */,
       9,    1,   60,    2, 0x02 /* Public */,
      10,    0,   63,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void, 0x80000000 | 5,    6,
    QMetaType::Void, 0x80000000 | 5,    6,
    QMetaType::Void, 0x80000000 | 5,    6,
    QMetaType::Void, 0x80000000 | 5,    6,
    QMetaType::QPixmap,

 // properties: name, type, flags
      11, 0x80000000 | 12, 0x00095009,

       0        // eod
};

void Node::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Node *_t = static_cast<Node *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->inNodesChanged(); break;
        case 1: _t->outNodesChanged(); break;
        case 2: _t->addInNode((*reinterpret_cast< Node*(*)>(_a[1]))); break;
        case 3: _t->removeInNode((*reinterpret_cast< Node*(*)>(_a[1]))); break;
        case 4: _t->addOutNode((*reinterpret_cast< Node*(*)>(_a[1]))); break;
        case 5: _t->removeOutNode((*reinterpret_cast< Node*(*)>(_a[1]))); break;
        case 6: { QPixmap _r = _t->getResult();
            if (_a[0]) *reinterpret_cast< QPixmap*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 2:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< Node* >(); break;
            }
            break;
        case 3:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< Node* >(); break;
            }
            break;
        case 4:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< Node* >(); break;
            }
            break;
        case 5:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< Node* >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (Node::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Node::inNodesChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (Node::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Node::outNodesChanged)) {
                *result = 1;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        Node *_t = static_cast<Node *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QQmlListProperty<Node>*>(_v) = _t->getInNodes(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject Node::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_Node.data,
      qt_meta_data_Node,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *Node::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Node::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Node.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Node::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    }
#ifndef QT_NO_PROPERTIES
   else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 1;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void Node::inNodesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void Node::outNodesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
