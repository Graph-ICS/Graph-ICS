/****************************************************************************
** Meta object code from reading C++ file 'itkcannyedgedetectionfilter.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../Sources/Filter/itkcannyedgedetectionfilter.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'itkcannyedgedetectionfilter.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_ItkCannyEdgeDetectionFilter_t {
    QByteArrayData data[8];
    char stringdata0[128];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ItkCannyEdgeDetectionFilter_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ItkCannyEdgeDetectionFilter_t qt_meta_stringdata_ItkCannyEdgeDetectionFilter = {
    {
QT_MOC_LITERAL(0, 0, 27), // "ItkCannyEdgeDetectionFilter"
QT_MOC_LITERAL(1, 28, 15), // "varianceChanged"
QT_MOC_LITERAL(2, 44, 0), // ""
QT_MOC_LITERAL(3, 45, 21), // "upperThresholdChanged"
QT_MOC_LITERAL(4, 67, 21), // "lowerThresholdChanged"
QT_MOC_LITERAL(5, 89, 8), // "variance"
QT_MOC_LITERAL(6, 98, 14), // "upperThreshold"
QT_MOC_LITERAL(7, 113, 14) // "lowerThreshold"

    },
    "ItkCannyEdgeDetectionFilter\0varianceChanged\0"
    "\0upperThresholdChanged\0lowerThresholdChanged\0"
    "variance\0upperThreshold\0lowerThreshold"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ItkCannyEdgeDetectionFilter[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       3,   32, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   29,    2, 0x06 /* Public */,
       3,    0,   30,    2, 0x06 /* Public */,
       4,    0,   31,    2, 0x06 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // properties: name, type, flags
       5, QMetaType::Double, 0x00495103,
       6, QMetaType::Double, 0x00495103,
       7, QMetaType::Double, 0x00495103,

 // properties: notify_signal_id
       0,
       1,
       2,

       0        // eod
};

void ItkCannyEdgeDetectionFilter::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ItkCannyEdgeDetectionFilter *_t = static_cast<ItkCannyEdgeDetectionFilter *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->varianceChanged(); break;
        case 1: _t->upperThresholdChanged(); break;
        case 2: _t->lowerThresholdChanged(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (ItkCannyEdgeDetectionFilter::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&ItkCannyEdgeDetectionFilter::varianceChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (ItkCannyEdgeDetectionFilter::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&ItkCannyEdgeDetectionFilter::upperThresholdChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (ItkCannyEdgeDetectionFilter::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&ItkCannyEdgeDetectionFilter::lowerThresholdChanged)) {
                *result = 2;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        ItkCannyEdgeDetectionFilter *_t = static_cast<ItkCannyEdgeDetectionFilter *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< double*>(_v) = _t->getVariance(); break;
        case 1: *reinterpret_cast< double*>(_v) = _t->getUpperThreshold(); break;
        case 2: *reinterpret_cast< double*>(_v) = _t->getLowerThreshold(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        ItkCannyEdgeDetectionFilter *_t = static_cast<ItkCannyEdgeDetectionFilter *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setVariance(*reinterpret_cast< double*>(_v)); break;
        case 1: _t->setUpperThreshold(*reinterpret_cast< double*>(_v)); break;
        case 2: _t->setLowerThreshold(*reinterpret_cast< double*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
    Q_UNUSED(_a);
}

QT_INIT_METAOBJECT const QMetaObject ItkCannyEdgeDetectionFilter::staticMetaObject = {
    { &Node::staticMetaObject, qt_meta_stringdata_ItkCannyEdgeDetectionFilter.data,
      qt_meta_data_ItkCannyEdgeDetectionFilter,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *ItkCannyEdgeDetectionFilter::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ItkCannyEdgeDetectionFilter::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ItkCannyEdgeDetectionFilter.stringdata0))
        return static_cast<void*>(this);
    return Node::qt_metacast(_clname);
}

int ItkCannyEdgeDetectionFilter::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = Node::qt_metacall(_c, _id, _a);
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
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 3;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 3;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void ItkCannyEdgeDetectionFilter::varianceChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void ItkCannyEdgeDetectionFilter::upperThresholdChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void ItkCannyEdgeDetectionFilter::lowerThresholdChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
