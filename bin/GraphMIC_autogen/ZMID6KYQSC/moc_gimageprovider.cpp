/****************************************************************************
** Meta object code from reading C++ file 'gimageprovider.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../Sources/gimageprovider.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'gimageprovider.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_GImageProvider_t {
    QByteArrayData data[8];
    char stringdata0[68];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_GImageProvider_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_GImageProvider_t qt_meta_stringdata_GImageProvider = {
    {
QT_MOC_LITERAL(0, 0, 14), // "GImageProvider"
QT_MOC_LITERAL(1, 15, 10), // "imgChanged"
QT_MOC_LITERAL(2, 26, 0), // ""
QT_MOC_LITERAL(3, 27, 9), // "loadImage"
QT_MOC_LITERAL(4, 37, 4), // "path"
QT_MOC_LITERAL(5, 42, 15), // "saveImageToFile"
QT_MOC_LITERAL(6, 58, 5), // "image"
QT_MOC_LITERAL(7, 64, 3) // "img"

    },
    "GImageProvider\0imgChanged\0\0loadImage\0"
    "path\0saveImageToFile\0image\0img"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_GImageProvider[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       1,   38, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   29,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
       3,    1,   30,    2, 0x02 /* Public */,
       5,    2,   33,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void,

 // methods: parameters
    QMetaType::QPixmap, QMetaType::QString,    4,
    QMetaType::Void, QMetaType::QPixmap, QMetaType::QString,    6,    4,

 // properties: name, type, flags
       7, QMetaType::QPixmap, 0x00495103,

 // properties: notify_signal_id
       0,

       0        // eod
};

void GImageProvider::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        GImageProvider *_t = static_cast<GImageProvider *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->imgChanged(); break;
        case 1: { QPixmap _r = _t->loadImage((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QPixmap*>(_a[0]) = std::move(_r); }  break;
        case 2: _t->saveImageToFile((*reinterpret_cast< QPixmap(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (GImageProvider::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&GImageProvider::imgChanged)) {
                *result = 0;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        GImageProvider *_t = static_cast<GImageProvider *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QPixmap*>(_v) = _t->getImg(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        GImageProvider *_t = static_cast<GImageProvider *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setImg(*reinterpret_cast< QPixmap*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject GImageProvider::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_GImageProvider.data,
      qt_meta_data_GImageProvider,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *GImageProvider::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *GImageProvider::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_GImageProvider.stringdata0))
        return static_cast<void*>(this);
    if (!strcmp(_clname, "QQuickImageProvider"))
        return static_cast< QQuickImageProvider*>(this);
    return QObject::qt_metacast(_clname);
}

int GImageProvider::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 3;
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
void GImageProvider::imgChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
