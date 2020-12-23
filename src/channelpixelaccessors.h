/*
 * Klasse für die Umwandlung von normale PixelTypes
 * in RGBA PixelTypes, damit werden die einzelne Channels
 * berücksichtig
 *
 * Trennung der einzelnen RGBA Channels des Bildes
 * die Funktionen können auch nur in eine einzelne Klasse
 * definiert werden zB ChannelsPixelAccessor
*/

/*
 * Ansatzt für eine ähnlioche Implementierung des ITK MediansFilters
 *

#ifndef CHANNELPIXELACCESSORS_H
#define CHANNELPIXELACCESSORS_H

#include <itkImageAdaptor.h>
#include <itkImage.hxx>
#include <itkRGBAPixel.h>

namespace ChannelPixelAccessors{

    class RedChannelPixelAccessor
    {
    public:
        explicit RedChannelPixelAccessor();

        using InternalType = itk::RGBAPixel<unsigned char>;
        using ExternalType = unsigned char;

        static ExternalType Get( const InternalType & input )
        {
            return static_cast<ExternalType>( input.GetRed() );
        }
    };

    class GreenChannelPixelAccessor
    {
    public:
        explicit GreenChannelPixelAccessor();

        using InternalType = itk::RGBAPixel<unsigned char>;
        using ExternalType = unsigned char;

        static ExternalType Get( const InternalType & input )
        {
            return static_cast<ExternalType>( input.GetGreen() );
        }
    };

    class BlueChannelPixelAccessor
    {
    public:
        explicit BlueChannelPixelAccessor();

        using InternalType = itk::RGBAPixel<unsigned char>;
        using ExternalType = unsigned char;

        static ExternalType Get( const InternalType & input )
        {
            return static_cast<ExternalType>( input.GetBlue() );
        }
    };

    class AlphaChannelPixelAccessor
    {
    public:
        explicit AlphaChannelPixelAccessor();

        using InternalType = itk::RGBAPixel<unsigned char>;
        using ExternalType = unsigned char;

        static ExternalType Get( const InternalType & input )
        {
            return static_cast<ExternalType>( input.GetAlpha() );
        }
    };

}
#endif // CHANNELPIXELACCESSORS_H


*/
