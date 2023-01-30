module WebP.Decode ( webPDecodeRGBA
                   , webPDecodeRGB
                   , webPDecodeYUV
                   , UInt8
                   ) where

import Data.Coerce (coerce)
import Foreign.C.Types (CInt, CSize)
import Foreign.Marshal.Alloc (alloca)
import Foreign.Ptr (Ptr, castPtr)
import Foreign.Storable (peek)

#include <webp/decode.h>

type UInt8 = {# type uint8_t #}

-- see docs: https://developers.google.com/speed/webp/docs/api

{# fun WebPDecodeRGBA as ^ { castPtr `Ptr a', coerce `CSize', alloca- `CInt' peek*, alloca- `CInt' peek* } -> `Ptr UInt8' id #}
{# fun WebPDecodeRGB as ^ { castPtr `Ptr a', coerce `CSize', alloca- `CInt' peek*, alloca- `CInt' peek* } -> `Ptr UInt8' id #}

{# fun WebPDecodeYUV as ^ { castPtr `Ptr a'
                          , coerce `CSize'
                          , alloca- `CInt' peek*
                          , alloca- `CInt' peek*
                          , alloca- `Ptr UInt8' peek*
                          , alloca- `Ptr UInt8' peek*
                          , alloca- `CInt' peek*
                          , alloca- `CInt' peek*
                          } -> `Ptr UInt8' id #}
