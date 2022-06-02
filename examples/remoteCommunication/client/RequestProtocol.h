#ifndef REQUESTPROTOCOL_H
#define REQUESTPROTOCOL_H

namespace Protocol
{
    namespace services
    {
        enum
        {
            SkeletonFactory,
            Sobel
        };
    } // namespace services

    namespace functions
    {
        namespace SkeletonFactory
        {
            enum
            {
                createSobelSkeleton,
                destroy
            };
        } // namespace SkeletonFactory

        namespace Sobel
        {
            enum
            {
                getXDerivative,
                setXDerivative,
                getYDerivative,
                setYDerivative,
                calculate
            };

        } // namespace Sobel

    } // namespace functions

} // namespace Protocol

#endif // REQUESTPROTOCOL_H